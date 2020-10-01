//
//  ABI.swift
//  Web3
//
//  Created by Josh Pyles on 6/13/18.
//

import Foundation
import BigInt
#if !Web3CocoaPods
    import Web3
#endif

/// ABI Namespace
public struct ABI {
    
    enum Error: Swift.Error {
        case unknownError
        case notImplemented
    }
    
    // MARK: - Encoding
    
    public static func encodeFunctionSignature(_ function: SolidityFunction) -> String {
        return "0x" + String(function.signature.sha3(.keccak256).prefix(8))
    }
    
    public static func encodeEventSignature(_ event: SolidityEvent) -> String {
        return "0x" + event.signature.sha3(.keccak256)
    }
    
    public static func encodeParameter(type: SolidityType, value: ABIEncodable) throws -> String {
        let encoded = try ABIEncoder.encode(value, to: type)
        return "0x" + encoded
    }
    
    public static func encodeParameter(_ wrappedValue: SolidityWrappedValue) throws -> String {
        let encoded = try ABIEncoder.encode(wrappedValue)
        return "0x" + encoded
    }
    
    public static func encodeParameters(types: [SolidityType], values: [ABIEncodable]) throws -> String {
        let wrappedValues = zip(types, values).map { SolidityWrappedValue(value: $0.1, type: $0.0) }
        return try encodeParameters(wrappedValues)
    }
    
    public static func encodeParameters(_ wrappedValues: [SolidityWrappedValue]) throws -> String {
        let encoded = try ABIEncoder.encode(wrappedValues)
        return "0x" + encoded
    }
    
    public static func encodeFunctionCall(_ invocation: SolidityInvocation) throws -> String {
        let encodedInputs = try ABIEncoder.encode(invocation.parameters)
        let signatureString = encodeFunctionSignature(invocation.method)
        return signatureString + encodedInputs
    }
    
    // MARK: - Decoding
    
    public static func decodeParameter(type: SolidityType, from hexString: String) throws -> Any {
        return try ABIDecoder.decode(type, from: hexString)
    }
    
    public static func decodeParameters(types: [SolidityType], from hexString: String ) throws -> [Any] {
        return try ABIDecoder.decode(types, from: hexString)
    }
    
    public static func decodeParameters(_ outputs: [SolidityParameter], from hexString: String) throws -> [String: Any] {
        return try ABIDecoder.decode(outputs: outputs, from: hexString)
    }
    
    public static func decodeLog(event: SolidityEvent, from log: EthereumLogObject) throws -> [String: Any] {
        return try ABIDecoder.decode(event: event, from: log)
    }
}
