//
//  Contract.swift
//  Web3
//
//  Created by Josh Pyles on 6/5/18.
//

import Foundation
#if !Web3CocoaPods
    import Web3
#endif

/// Base protocol all contracts should adopt.
/// Brokers relationship between Web3 and contract methods and events
public protocol EthereumContract: SolidityFunctionHandler {
    var address: EthereumAddress? { get }
    var eth: Web3.Eth { get }
    var events: [SolidityEvent] { get }
}

/// Contract where all methods and events are defined statically
///
/// Pros: more type safety, cleaner calls
/// Cons: more work to implement
///
/// Best for when you want to code the methods yourself
public protocol StaticContract: EthereumContract {
    init(address: EthereumAddress?, eth: Web3.Eth)
}

/// Contract that is dynamically generated from a JSON representation
///
/// Pros: compatible with existing json files
/// Cons: harder to call methods, less type safety
///
/// For when you want to import from json
public class DynamicContract: EthereumContract {
    
    public var address: EthereumAddress?
    public let eth: Web3.Eth
    
    private(set) public var constructor: SolidityConstructor?
    private(set) public var events: [SolidityEvent] = []
    private(set) var methods: [String: SolidityFunction] = [:]
    
    public init(abi: [ABIObject], address: EthereumAddress?, eth: Web3.Eth) {
        self.address = address
        self.eth = eth
        self.parseABIObjects(abi: abi)
    }
    
    private func parseABIObjects(abi: [ABIObject]) {
        for abiObject in abi {
            switch (abiObject.type, abiObject.stateMutability) {
            case (.event, _):
                if let event = SolidityEvent(abiObject: abiObject) {
                    add(event: event)
                }
            case (.function, let stateMutability?) where stateMutability.isConstant:
                if let function = SolidityConstantFunction(abiObject: abiObject, handler: self) {
                    add(method: function)
                }
            case (.function, .nonpayable?):
                if let function = SolidityNonPayableFunction(abiObject: abiObject, handler: self) {
                    add(method: function)
                }
            case (.function, .payable?):
                if let function = SolidityPayableFunction(abiObject: abiObject, handler: self) {
                    add(method: function)
                }
            case (.constructor, _):
                self.constructor = SolidityConstructor(abiObject: abiObject, handler: self)
            default:
                print("Could not parse abi object: \(abiObject)")
            }
        }
    }
    
    /// Adds an event object to list of stored events. Generally this should be done automatically by Web3.
    ///
    /// - Parameter event: `ABIEvent` that can be emitted from this contract
    public func add(event: SolidityEvent) {
        events.append(event)
    }
    
    /// Adds a method object to list of stored methods. Generally this should be done automatically by Web3.
    ///
    /// - Parameter method: `ABIFunction` that can be called on this contract
    public func add(method: SolidityFunction) {
        methods[method.name] = method
    }
    
    /// Invocation of a method with the provided name
    /// For example: `MyContract['balanceOf']?(address).call() { ... }`
    ///
    /// - Parameter name: Name of function to call
    public subscript(_ name: String) -> ((ABIEncodable...) -> SolidityInvocation)? {
        return methods[name]?.invoke
    }
    
    /// Deploys a new instance of this contract to the network
    /// Example: contract.deploy(byteCode: byteCode, parameters: p1, p2)?.send(...) { ... }
    ///
    /// - Parameters:
    ///   - byteCode: Compiled bytecode of the contract
    ///   - parameters: Any input values for the constructor
    /// - Returns: Invocation object that can be called with .send(...)
    public func deploy(byteCode: EthereumData, parameters: ABIEncodable...) -> SolidityConstructorInvocation? {
        return constructor?.invoke(byteCode: byteCode, parameters: parameters)
    }
    
    public func deploy(byteCode: EthereumData, parameters: [ABIEncodable]) -> SolidityConstructorInvocation? {
        return constructor?.invoke(byteCode: byteCode, parameters: parameters)
    }
    
    public func deploy(byteCode: EthereumData) -> SolidityConstructorInvocation? {
        return constructor?.invoke(byteCode: byteCode, parameters: [])
    }
}

// MARK: - Call & Send

extension EthereumContract {
    
    /// Returns data by calling a constant function on the contract
    ///
    /// - Parameters:
    ///   - data: EthereumData object representing the method called
    ///   - outputs: Expected return values
    ///   - completion: Completion handler
    public func call(_ call: EthereumCall, outputs: [SolidityFunctionParameter], block: EthereumQuantityTag = .latest, completion: @escaping ([String: Any]?, Error?) -> Void) {
        eth.call(call: call, block: block) { response in
            switch response.status {
            case .success(let data):
                do {
                    let dictionary = try ABI.decodeParameters(outputs, from: data.hex())
                    completion(dictionary, nil)
                } catch {
                    completion(nil, error)
                }
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    /// Modifies the contract's data by sending a transaction
    ///
    /// - Parameters:
    ///   - data: Encoded EthereumData for the methods called
    ///   - from: EthereumAddress to send from
    ///   - value: Amount of ETH to send, if applicable
    ///   - gas: Maximum gas allowed for the transaction
    ///   - gasPrice: Amount of wei to spend per unit of gas
    ///   - completion: completion handler. Either the transaction's hash or an error.
    public func send(_ transaction: EthereumTransaction, completion: @escaping (EthereumData?, Error?) -> Void) {
        eth.sendTransaction(transaction: transaction) { response in
            switch response.status {
            case .success(let hash):
                completion(hash, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    /// Estimates the amount of gas used for this method
    ///
    /// - Parameters:
    ///   - call: An ethereum call with the data for the transaction.
    ///   - completion: completion handler with either an error or the estimated amount of gas needed.
    public func estimateGas(_ call: EthereumCall, completion: @escaping (EthereumQuantity?, Error?) -> Void) {
        eth.estimateGas(call: call) { response in
            switch response.status {
            case .success(let quantity):
                completion(quantity, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}
