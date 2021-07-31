//
//  Invocation.swift
//  Web3
//
//  Created by Josh Pyles on 6/5/18.
//

import Foundation


public enum InvocationError: Error {
    case contractNotDeployed
    case invalidConfiguration
    case invalidInvocation
    case encodingError
}

/// Represents invoking a given contract method with parameters
public protocol SolidityInvocation {
    /// The function that was invoked
    var method: SolidityFunction { get }
    
    /// Parameters method was invoked with
    var parameters: [SolidityWrappedValue] { get }
    
    /// Handler for submitting calls and sends
    var handler: SolidityFunctionHandler { get }
    
    /// Generates an EthereumCall object
    func createCall() -> Call?
    
    /// Generates an EthereumTransaction object
    func createTransaction(nonce: Quantity?, from: Address, value: Quantity?, gas: Quantity, gasPrice: Quantity?) -> Transaction?
    
    /// Read data from the blockchain. Only available for constant functions.
    func call(block: QuantityTag, completion: @escaping ([String: Any]?, Error?) -> Void)
    
    /// Write data to the blockchain. Only available for non-constant functions.
    func send(nonce: Quantity?, from: Address, value: Quantity?, gas: Quantity, gasPrice: Quantity?, completion: @escaping (DataObject?, Error?) -> Void)
    
    /// Estimate how much gas is needed to execute this transaction.
    func estimateGas(from: Address?, gas: Quantity?, value: Quantity?, completion: @escaping (Quantity?, Error?) -> Void)
    
    /// Encodes the ABI for this invocation
    func encodeABI() -> DataObject?
    
    init(method: SolidityFunction, parameters: [ABIEncodable], handler: SolidityFunctionHandler)
}

// MARK: - Read Invocation

/// An invocation that is read-only. Should only use .call()
public struct SolidityReadInvocation: SolidityInvocation {
    
    public let method: SolidityFunction
    public let parameters: [SolidityWrappedValue]
    
    public let handler: SolidityFunctionHandler
    
    public init(method: SolidityFunction, parameters: [ABIEncodable], handler: SolidityFunctionHandler) {
        self.method = method
        self.parameters = zip(parameters, method.inputs).map { SolidityWrappedValue(value: $0, type: $1.type) }
        self.handler = handler
    }
    
    public func call(block: QuantityTag = .latest, completion: @escaping ([String: Any]?, Error?) -> Void) {
        guard handler.address != nil else {
            completion(nil, InvocationError.contractNotDeployed)
            return
        }
        guard let call = createCall() else {
            completion(nil, InvocationError.encodingError)
            return
        }
        let outputs = method.outputs ?? []
        handler.call(call, outputs: outputs, block: block, completion: completion)
    }
    
    public func send(nonce: Quantity? = nil, from: Address, value: Quantity?, gas: Quantity, gasPrice: Quantity?, completion: @escaping (DataObject?, Error?) -> Void) {
        completion(nil, InvocationError.invalidInvocation)
    }
    
    public func createCall() -> Call? {
        guard let data = encodeABI() else { return nil }
        guard let to = handler.address else { return nil }
        return Call(from: nil, to: to, gas: nil, gasPrice: nil, value: nil, data: data)
    }
    
    public func createTransaction(nonce: Quantity?, from: Address, value: Quantity?, gas: Quantity, gasPrice: Quantity?) -> Transaction? {
        return nil
    }
    
}

// MARK: - Payable Invocation

/// An invocation that writes to the blockchain and can receive ETH. Should only use .send()
public struct SolidityPayableInvocation: SolidityInvocation {
    
    public let method: SolidityFunction
    public let parameters: [SolidityWrappedValue]
    
    public let handler: SolidityFunctionHandler
    
    public init(method: SolidityFunction, parameters: [ABIEncodable], handler: SolidityFunctionHandler) {
        self.method = method
        self.parameters = zip(parameters, method.inputs).map { SolidityWrappedValue(value: $0, type: $1.type) }
        self.handler = handler
    }
    
    public func createTransaction(nonce: Quantity? = nil, from: Address, value: Quantity?, gas: Quantity, gasPrice: Quantity?) -> Transaction? {
        guard let data = encodeABI() else { return nil }
        guard let to = handler.address else { return nil }
        return Transaction(nonce: nonce, gasPrice: gasPrice, gas: gas, from: from, to: to, value: value ?? 0, data: data)
    }
    
    public func createCall() -> Call? {
        return nil
    }
    
    public func call(block: QuantityTag = .latest, completion: @escaping ([String: Any]?, Error?) -> Void) {
        completion(nil, InvocationError.invalidInvocation)
    }
    
    public func send(nonce: Quantity? = nil, from: Address, value: Quantity?, gas: Quantity, gasPrice: Quantity?, completion: @escaping (DataObject?, Error?) -> Void) {
        guard handler.address != nil else {
            completion(nil, InvocationError.contractNotDeployed)
            return
        }
        guard let transaction = createTransaction(nonce: nonce, from: from, value: value, gas: gas, gasPrice: gasPrice) else {
            completion(nil, InvocationError.encodingError)
            return
        }
        handler.send(transaction, completion: completion)
    }
}

// MARK: - Non Payable Invocation

/// An invocation that writes to the blockchain and cannot receive ETH. Should only use .send().
public struct SolidityNonPayableInvocation: SolidityInvocation {
    public let method: SolidityFunction
    public let parameters: [SolidityWrappedValue]
    
    public let handler: SolidityFunctionHandler
    
    public init(method: SolidityFunction, parameters: [ABIEncodable], handler: SolidityFunctionHandler) {
        self.method = method
        self.parameters = zip(parameters, method.inputs).map { SolidityWrappedValue(value: $0, type: $1.type) }
        self.handler = handler
    }
    
    public func createTransaction(nonce: Quantity? = nil, from: Address, value: Quantity?, gas: Quantity, gasPrice: Quantity?) -> Transaction? {
        guard let data = encodeABI() else { return nil }
        guard let to = handler.address else { return nil }
        return Transaction(nonce: nonce, gasPrice: gasPrice, gas: gas, from: from, to: to, value: value ?? 0, data: data)
    }
    
    public func createCall() -> Call? {
        return nil
    }
    
    public func call(block: QuantityTag = .latest, completion: @escaping ([String: Any]?, Error?) -> Void) {
        completion(nil, InvocationError.invalidInvocation)
    }
    
    public func send(nonce: Quantity? = nil, from: Address, value: Quantity?, gas: Quantity, gasPrice: Quantity?, completion: @escaping (DataObject?, Error?) -> Void) {
        guard handler.address != nil else {
            completion(nil, InvocationError.contractNotDeployed)
            return
        }
        guard let transaction = createTransaction(nonce: nonce, from: from, value: value, gas: gas, gasPrice: gasPrice) else {
            completion(nil, InvocationError.encodingError)
            return
        }
        handler.send(transaction, completion: completion)
    }
}

// MARK: - PromiseKit convenience

public extension SolidityInvocation {
    
    // Default Implementations
    
    func call(completion: @escaping ([String: Any]?, Error?) -> Void) {
        self.call(block: .latest, completion: completion)
    }
    
    func estimateGas(from: Address? = nil, gas: Quantity? = nil, value: Quantity? = nil, completion: @escaping (Quantity?, Error?) -> Void) {
        guard let data = encodeABI() else {
            completion(nil, InvocationError.encodingError)
            return
        }
        guard let to = handler.address else {
            completion(nil, InvocationError.contractNotDeployed)
            return
        }
        let call = Call(from: from, to: to, gas: gas, gasPrice: nil, value: value, data: data)
        handler.estimateGas(call, completion: completion)
    }
    
    func encodeABI() -> DataObject? {
        if let hexString = try? ABI.encodeFunctionCall(self) {
            return try? DataObject(value: hexString)
        }
        return nil
    }
}

// MARK: - Contract Creation

/// Represents a contract creation invocation
public struct SolidityConstructorInvocation {
    public let byteCode: DataObject
    public let parameters: [SolidityWrappedValue]
    public let payable: Bool
    public let handler: SolidityFunctionHandler
    
    public init(byteCode: DataObject, parameters: [SolidityWrappedValue], payable: Bool, handler: SolidityFunctionHandler) {
        self.byteCode = byteCode
        self.parameters = parameters
        self.handler = handler
        self.payable = payable
    }
    
    public func createTransaction(nonce: Quantity? = nil, from: Address, value: Quantity = 0, gas: Quantity, gasPrice: Quantity?) -> Transaction? {
        guard let data = encodeABI() else { return nil }
        return Transaction(nonce: nonce, gasPrice: gasPrice, gas: gas, from: from, to: nil, value: value, data: data)
    }
    
    public func send(nonce: Quantity? = nil, from: Address, value: Quantity = 0, gas: Quantity, gasPrice: Quantity?, completion: @escaping (DataObject?, Error?) -> Void) {
        guard payable == true || value == 0 else {
            completion(nil, InvocationError.invalidInvocation)
            return
        }
        guard let transaction = createTransaction(nonce: nonce, from: from, value: value, gas: gas, gasPrice: gasPrice) else {
            completion(nil, InvocationError.encodingError)
            return
        }
        handler.send(transaction, completion: completion)
    }
    
    public func encodeABI() -> DataObject? {
        // The data for creating a new contract is the bytecode of the contract + any input params serialized in the standard format.
        var dataString = "0x"
        dataString += byteCode.hex().replacingOccurrences(of: "0x", with: "")
        if parameters.count > 0, let encodedParams = try? ABI.encodeParameters(parameters) {
            dataString += encodedParams.replacingOccurrences(of: "0x", with: "")
        }
        return try? DataObject(value: dataString)
    }
}
