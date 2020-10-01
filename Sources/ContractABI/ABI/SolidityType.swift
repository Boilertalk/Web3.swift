//
//  ABI.swift
//  AppAuth
//
//  Created by Josh Pyles on 5/19/18.
//

import Foundation
import BigInt
#if !Web3CocoaPods
    import Web3
#endif

/// Recursive enumeration of ABI types.
///
/// - type: A regular single type
/// - array: A homogenous collection of a type with an optional length
/// - tuple: A collection of types
public indirect enum SolidityType {
    
    /// Solidity Base Types
    public enum ValueType {
        
        /// unsigned integer type of M bits, 0 < M <= 256, M % 8 == 0. e.g. uint32, uint8, uint256.
        case uint(bits: UInt16)
        
        /// two’s complement signed integer type of M bits, 0 < M <= 256, M % 8 == 0.
        case int(bits: UInt16)
        
        /// equivalent to uint160, except for the assumed interpretation and language typing.
        /// For computing the function selector, address is used.
        case address
        
        /// equivalent to uint8 restricted to the values 0 and 1. For computing the function selector, bool is used.
        case bool
        
        /// binary type of M bytes, 0 < M <= 32.
        case bytes(length: UInt?)
        
        /// dynamic sized unicode string assumed to be UTF-8 encoded.
        case string
        
        /// signed fixed-point decimal number of M bits, 8 <= M <= 256, M % 8 ==0, and 0 < N <= 80, which denotes the value v as v / (10 ** N).
        case fixed(bits: UInt16, length: UInt8)
        
        /// unsigned variant of fixed<M>x<N>.
        case ufixed(bits: UInt16, length: UInt8)
        
        // MARK: - Convenient shorthands
        
        public static let uint8: ValueType = .uint(bits: 8)
        public static let uint16: ValueType = .uint(bits: 16)
        public static let uint32: ValueType = .uint(bits: 32)
        public static let uint64: ValueType = .uint(bits: 64)
        public static let uint256: ValueType = .uint(bits: 256)
        
        public static let int8: ValueType = .int(bits: 8)
        public static let int16: ValueType = .int(bits: 16)
        public static let int32: ValueType = .int(bits: 32)
        public static let int64: ValueType = .int(bits: 64)
        public static let int256: ValueType = .int(bits: 256)
    }
    
    case type(ValueType)
    case array(type: SolidityType, length: UInt?)
    case tuple([SolidityType])
    
    // Convenience members
    
    public static let string: SolidityType = .type(.string)
    public static let bool: SolidityType = .type(.bool)
    public static let address: SolidityType = .type(.address)
    
    public static let uint: SolidityType = .type(.uint256)
    public static let uint8: SolidityType = .type(.uint8)
    public static let uint16: SolidityType = .type(.uint16)
    public static let uint32: SolidityType = .type(.uint32)
    public static let uint64: SolidityType = .type(.uint64)
    public static let uint256: SolidityType = .type(.uint256)
    
    public static let int: SolidityType = .type(.int(bits: 256))
    public static let int8: SolidityType = .type(.int8)
    public static let int16: SolidityType = .type(.int16)
    public static let int32: SolidityType = .type(.int32)
    public static let int64: SolidityType = .type(.int64)
    public static let int256: SolidityType = .type(.int256)
    
    public static func fixed(bits: UInt16, exponent: UInt8) -> SolidityType {
        return .type(.fixed(bits: bits, length: exponent))
    }
    
    public static func ufixed(bits: UInt16, exponent: UInt8) -> SolidityType {
        return .type(.ufixed(bits: bits, length: exponent))
    }
    
    public static func bytes(length: UInt?) -> SolidityType {
        return .type(.bytes(length: length))
    }
    
    // Initializers
    
    public init(_ type: ValueType) {
        self = .type(type)
    }
    
    public init(tuple: SolidityType...) {
        self = .tuple(tuple)
    }
    
    // ABI Helpers
    
    /// Whether or not the type is considered dynamic
    public var isDynamic: Bool {
        switch self {
        case .type(let type):
            return type.isDynamic
        case .array(let type, let length):
            // T[k] is dynamic if T is dynamic, or if k is nil
            return type.isDynamic || length == nil
        case .tuple(let types):
            //(T1,...,Tk) if any Ti is dynamic for 1 <= i <= k
            return types.count > 1 || types.filter { $0.isDynamic }.count > 0
        }
    }
    
    /// String representation for ABI signature
    public var stringValue: String {
        switch self {
        case .type(let type):
            return type.stringValue
            
        case .array(let type, let length):
            if let length = length {
                return "\(type.stringValue)[\(length)]"
            }
            return "\(type.stringValue)[]"
            
        case .tuple(let types):
            let typesString = types.map { $0.stringValue }.joined(separator: ",")
            return "(\(typesString))"
        }
    }
    
    /// Length in bytes of static portion
    /// Typically 32 bytes, but in the case of a fixed size array, it will be the length of the array * 32 bytes
    public var staticPartLength: UInt {
        switch self {
        case .array(let type, let length):
            if !type.isDynamic, let length = length {
                return length * type.staticPartLength
            }
            return 32
        default:
            return 32
        }
    }
}

public extension SolidityType.ValueType {
    
    var nativeType: ABIConvertible.Type? {
        switch self {
        case .uint(let bits):
            switch bits {
            case 8:
                return UInt8.self
            case 16:
                return UInt16.self
            case 32:
                return UInt32.self
            case 64:
                return UInt64.self
            default:
                return BigUInt.self
            }
        case .int(let bits):
            switch bits {
            case 8:
                return Int8.self
            case 16:
                return Int16.self
            case 32:
                return Int32.self
            case 64:
                return Int64.self
            default:
                return BigInt.self
            }
        case .bool:
            return Bool.self
        case .string:
            return String.self
        case .bytes:
            return Data.self
        case .address:
            return EthereumAddress.self
        case .fixed:
            return nil
        case .ufixed:
            return nil
        }
    }
    
    /// Whether or not the type is considered dynamic
    var isDynamic: Bool {
        switch self {
        case .string:
            // All strings are dynamic
            return true
        case .bytes(let length):
            // bytes without length are dynamic
            return length == nil
        default:
            return false
        }
    }
    
    /// String representation used for ABI signature encoding
    var stringValue: String {
        switch self {
        case .uint(let bits):
            return "uint\(bits)"
            
        case .int(let bits):
            return "int\(bits)"
            
        case .address:
            return "address"
            
        case .bool:
            return "bool"
            
        case .bytes(let length):
            if let length = length {
                return "bytes\(length)"
            }
            return "bytes"
            
        case .string:
            return "string"
            
        case .fixed(let bits, let length):
            return "fixed\(bits)x\(length)"
            
        case .ufixed(let bits, let length):
            return "ufixed\(bits)x\(length)"
        }
    }
}

extension SolidityType: Equatable {
    public static func ==(_ a: SolidityType, _ b: SolidityType) -> Bool {
        switch(a, b) {
        case (.type(let aType), .type(let bType)):
            return aType == bType
        case (.array(let aType, let aLength), .array(let bType, let bLength)):
            return aType == bType && aLength == bLength
        case (.tuple(let aTypes), .tuple(let bTypes)):
            return aTypes == bTypes
        default:
            return false
        }
    }
}

extension SolidityType: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .type(let enumType):
            hasher.combine(enumType)
        case .array(let enumType, let length):
            hasher.combine(enumType)
            hasher.combine(length)
        case .tuple(let enumType):
            hasher.combine(enumType)
        }
    }
}

extension SolidityType.ValueType: Equatable {
    public static func ==(_ a: SolidityType.ValueType, _ b: SolidityType.ValueType) -> Bool {
        switch (a, b) {
        case (.uint(let aBits), .uint(let bBits)):
            return aBits == bBits
        case (.int(let aBits), .int(let bBits)):
            return aBits == bBits
        case (.address, .address):
            return true
        case (.bool, .bool):
            return true
        case (.bytes(let aLength), .bytes(let bLength)):
            return aLength == bLength
        case (.string, .string):
            return true
        case (.fixed(let aBits, let aLength), .fixed(let bBits, let bLength)):
            return aBits == bBits && aLength == bLength
        case (.ufixed(let aBits, let aLength), .ufixed(let bBits, let bLength)):
            return aBits == bBits && aLength == bLength
        default:
            return false
        }
    }
}

extension SolidityType.ValueType: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .uint(let bits):
            hasher.combine("0x00")
            hasher.combine(bits)
        case .int(let bits):
            hasher.combine("0x01")
            hasher.combine(bits)
        case .address:
            hasher.combine("0x02")
        case .bool:
            hasher.combine("0x03")
        case .bytes(let length):
            hasher.combine("0x04")
            hasher.combine(length)
        case .string:
            hasher.combine("0x05")
        case .fixed(let bits, let length):
            hasher.combine("0x06")
            hasher.combine(bits)
            hasher.combine(length)
        case .ufixed(let bits, let length):
            hasher.combine("0x07")
            hasher.combine(bits)
            hasher.combine(length)
        }
    }
}
