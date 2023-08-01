//
//  Function.swift
//  Web3
//
//  Created by Josh Pyles on 6/5/18.
//

import Foundation
#if !Web3CocoaPods
    import Web3
#endif

/// A class that can accept invocations and forward to Web3
public protocol SolidityFunctionHandler: class {
    var address: EthereumAddress? { get }
    func call(_ call: EthereumCall, outputs: [SolidityFunctionParameter], block: EthereumQuantityTag, completion: @escaping ([String: Any]?, Error?) -> Void)
    func send(_ transaction: EthereumTransaction, completion: @escaping (EthereumData?, Error?) -> Void)
    func estimateGas(_ call: EthereumCall, completion: @escaping (EthereumQuantity?, Error?) -> Void)
}

public protocol SolidityParameter {
    var name: String { get }
    var type: SolidityType { get }
    var components: [SolidityParameter]? { get }
}

/// Represents a value that can be passed into a function or is returned from a function
public struct SolidityFunctionParameter: SolidityParameter {
    public let name: String
    public let type: SolidityType
    public let components: [SolidityParameter]?
    
    public init?(_ parameter: ABIObject.Parameter) {
        self.name = parameter.name
        let components = parameter.components?.compactMap { SolidityFunctionParameter($0) }
        let subTypes = components?.map { $0.type }
        guard let type = SolidityType(parameter.type, subTypes: subTypes) else { return nil }
        self.type = type
        self.components = components
    }
    
    public init(name: String, type: SolidityType, components: [SolidityFunctionParameter]? = nil) {
        self.name = name
        self.type = type
        self.components = components
    }
}

/// Represents a function within a contract
public protocol SolidityFunction: class {
    
    /// Name of the method. Must match the contract source.
    var name: String { get }
    
    /// Values accepted by the function
    var inputs: [SolidityFunctionParameter] { get }
    
    /// Values returned by the function
    var outputs: [SolidityFunctionParameter]? { get }
    
    /// Class responsible for forwarding invocations
    var handler: SolidityFunctionHandler { get }
    
    /// Signature of the function. Used to identify which function you are calling.
    var signature: String { get }
    
    init?(abiObject: ABIObject, handler: SolidityFunctionHandler)
    init(name: String, inputs: [SolidityFunctionParameter], outputs: [SolidityFunctionParameter]?, handler: SolidityFunctionHandler)
    
    
    /// Invokes this function with the provided values
    ///
    /// - Parameter inputs: Input values. Must be in the correct order.
    /// - Returns: Invocation object
    func invoke(_ inputs: ABIEncodable...) -> SolidityInvocation
}

public extension SolidityFunction {
    
    var signature: String {
        return "\(name)(\(inputs.map { $0.type.stringValue }.joined(separator: ",")))"
    }
    
}

// MARK: - Function Implementations

/// Represents a function that is read-only. It will not modify state on the blockchain.
public class SolidityConstantFunction: SolidityFunction {
    public let name: String
    public let inputs: [SolidityFunctionParameter]
    public let outputs: [SolidityFunctionParameter]?
    
    public let handler: SolidityFunctionHandler
    
    public required init?(abiObject: ABIObject, handler: SolidityFunctionHandler) {
        guard abiObject.type == .function, abiObject.stateMutability?.isConstant == true else { return nil }
        guard let name = abiObject.name else { return nil }
        self.name = name
        self.inputs = abiObject.inputs?.compactMap { SolidityFunctionParameter($0) } ?? []
        self.outputs = abiObject.outputs?.compactMap { SolidityFunctionParameter($0) }
        self.handler = handler
    }
    
    public required init(name: String, inputs: [SolidityFunctionParameter] = [], outputs: [SolidityFunctionParameter]?, handler: SolidityFunctionHandler) {
        self.name = name
        self.inputs = inputs
        self.outputs = outputs
        self.handler = handler
    }
    
    public func invoke(_ inputs: ABIEncodable...) -> SolidityInvocation {
        return SolidityReadInvocation(method: self, parameters: inputs, handler: handler)
    }
}

/// Represents a function that can modify the state of the contract and can accept ETH.
public class SolidityPayableFunction: SolidityFunction {
    public let name: String
    public let inputs: [SolidityFunctionParameter]
    public let outputs: [SolidityFunctionParameter]? = nil
    
    public let handler: SolidityFunctionHandler
    
    public required init?(abiObject: ABIObject, handler: SolidityFunctionHandler) {
        guard abiObject.type == .function, abiObject.stateMutability == .payable else { return nil }
        guard let name = abiObject.name else { return nil }
        self.name = name
        self.inputs = abiObject.inputs?.compactMap { SolidityFunctionParameter($0) } ?? []
        self.handler = handler
    }
    
    public required init(name: String, inputs: [SolidityFunctionParameter] = [], outputs: [SolidityFunctionParameter]? = nil, handler: SolidityFunctionHandler) {
        self.name = name
        self.inputs = inputs
        self.handler = handler
    }
    
    public func invoke(_ inputs: ABIEncodable...) -> SolidityInvocation {
        return SolidityPayableInvocation(method: self, parameters: inputs, handler: handler)
    }
}

/// Represents a function that can modify the state of the contract and cannot accept ETH.
public class SolidityNonPayableFunction: SolidityFunction {
    public let name: String
    public let inputs: [SolidityFunctionParameter]
    public let outputs: [SolidityFunctionParameter]? = nil
    
    public let handler: SolidityFunctionHandler
    
    public required init?(abiObject: ABIObject, handler: SolidityFunctionHandler) {
        guard abiObject.type == .function, abiObject.stateMutability == .nonpayable else { return nil }
        guard let name = abiObject.name else { return nil }
        self.name = name
        self.inputs = abiObject.inputs?.compactMap { SolidityFunctionParameter($0) } ?? []
        self.handler = handler
    }
    
    public required init(name: String, inputs: [SolidityFunctionParameter] = [], outputs: [SolidityFunctionParameter]? = nil, handler: SolidityFunctionHandler) {
        self.name = name
        self.inputs = inputs
        self.handler = handler
    }
    
    public func invoke(_ inputs: ABIEncodable...) -> SolidityInvocation {
        return SolidityNonPayableInvocation(method: self, parameters: inputs, handler: handler)
    }
}

/// Represents a function that creates a contract
public class SolidityConstructor {
    public let inputs: [SolidityFunctionParameter]
    public let handler: SolidityFunctionHandler
    public let payable: Bool
    
    public init?(abiObject: ABIObject, handler: SolidityFunctionHandler) {
        guard abiObject.type == .constructor else { return nil }
        self.inputs = abiObject.inputs?.compactMap { SolidityFunctionParameter($0) } ?? []
        self.handler = handler
        self.payable = abiObject.payable ?? false
    }
    
    public init(inputs: [SolidityFunctionParameter], payable: Bool = false, handler: SolidityFunctionHandler) {
        self.inputs = inputs
        self.handler = handler
        self.payable = payable
    }
    
    public func invoke(byteCode: EthereumData, parameters: [ABIEncodable]) -> SolidityConstructorInvocation {
        let wrappedParams = zip(parameters, inputs).map { SolidityWrappedValue(value: $0.0, type: $0.1.type) }
        return SolidityConstructorInvocation(byteCode: byteCode, parameters: wrappedParams, payable: payable, handler: handler)
    }
}
