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
        public static let uint24: ValueType = .uint(bits: 24)
        public static let uint32: ValueType = .uint(bits: 32)
        public static let uint40: ValueType = .uint(bits: 40)
        public static let uint48: ValueType = .uint(bits: 48)
        public static let uint56: ValueType = .uint(bits: 56)
        public static let uint64: ValueType = .uint(bits: 64)
        public static let uint72: ValueType = .uint(bits: 72)
        public static let uint80: ValueType = .uint(bits: 80)
        public static let uint88: ValueType = .uint(bits: 88)
        public static let uint96: ValueType = .uint(bits: 96)
        public static let uint104: ValueType = .uint(bits: 104)
        public static let uint112: ValueType = .uint(bits: 112)
        public static let uint120: ValueType = .uint(bits: 120)
        public static let uint128: ValueType = .uint(bits: 128)
        public static let uint136: ValueType = .uint(bits: 136)
        public static let uint144: ValueType = .uint(bits: 144)
        public static let uint152: ValueType = .uint(bits: 152)
        public static let uint160: ValueType = .uint(bits: 160)
        public static let uint168: ValueType = .uint(bits: 168)
        public static let uint176: ValueType = .uint(bits: 176)
        public static let uint184: ValueType = .uint(bits: 184)
        public static let uint192: ValueType = .uint(bits: 192)
        public static let uint200: ValueType = .uint(bits: 200)
        public static let uint208: ValueType = .uint(bits: 208)
        public static let uint216: ValueType = .uint(bits: 216)
        public static let uint224: ValueType = .uint(bits: 224)
        public static let uint232: ValueType = .uint(bits: 232)
        public static let uint240: ValueType = .uint(bits: 240)
        public static let uint248: ValueType = .uint(bits: 248)
        public static let uint256: ValueType = .uint(bits: 256)
        
        public static let int8: ValueType = .int(bits: 8)
        public static let int16: ValueType = .int(bits: 16)
        public static let int24: ValueType = .int(bits: 24)
        public static let int32: ValueType = .int(bits: 32)
        public static let int40: ValueType = .int(bits: 40)
        public static let int48: ValueType = .int(bits: 48)
        public static let int56: ValueType = .int(bits: 56)
        public static let int64: ValueType = .int(bits: 64)
        public static let int72: ValueType = .int(bits: 72)
        public static let int80: ValueType = .int(bits: 80)
        public static let int88: ValueType = .int(bits: 88)
        public static let int96: ValueType = .int(bits: 96)
        public static let int104: ValueType = .int(bits: 104)
        public static let int112: ValueType = .int(bits: 112)
        public static let int120: ValueType = .int(bits: 120)
        public static let int128: ValueType = .int(bits: 128)
        public static let int136: ValueType = .int(bits: 136)
        public static let int144: ValueType = .int(bits: 144)
        public static let int152: ValueType = .int(bits: 152)
        public static let int160: ValueType = .int(bits: 160)
        public static let int168: ValueType = .int(bits: 168)
        public static let int176: ValueType = .int(bits: 176)
        public static let int184: ValueType = .int(bits: 184)
        public static let int192: ValueType = .int(bits: 192)
        public static let int200: ValueType = .int(bits: 200)
        public static let int208: ValueType = .int(bits: 208)
        public static let int216: ValueType = .int(bits: 216)
        public static let int224: ValueType = .int(bits: 224)
        public static let int232: ValueType = .int(bits: 232)
        public static let int240: ValueType = .int(bits: 240)
        public static let int248: ValueType = .int(bits: 248)
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
    public static let uint24: SolidityType = .type(.uint24)
    public static let uint32: SolidityType = .type(.uint32)
    public static let uint40: SolidityType = .type(.uint40)
    public static let uint48: SolidityType = .type(.uint48)
    public static let uint56: SolidityType = .type(.uint56)
    public static let uint64: SolidityType = .type(.uint64)
    public static let uint72: SolidityType = .type(.uint72)
    public static let uint80: SolidityType = .type(.uint80)
    public static let uint88: SolidityType = .type(.uint88)
    public static let uint96: SolidityType = .type(.uint96)
    public static let uint104: SolidityType = .type(.uint104)
    public static let uint112: SolidityType = .type(.uint112)
    public static let uint120: SolidityType = .type(.uint120)
    public static let uint128: SolidityType = .type(.uint128)
    public static let uint136: SolidityType = .type(.uint136)
    public static let uint144: SolidityType = .type(.uint144)
    public static let uint152: SolidityType = .type(.uint152)
    public static let uint160: SolidityType = .type(.uint160)
    public static let uint168: SolidityType = .type(.uint168)
    public static let uint176: SolidityType = .type(.uint176)
    public static let uint184: SolidityType = .type(.uint184)
    public static let uint192: SolidityType = .type(.uint192)
    public static let uint200: SolidityType = .type(.uint200)
    public static let uint208: SolidityType = .type(.uint208)
    public static let uint216: SolidityType = .type(.uint216)
    public static let uint224: SolidityType = .type(.uint224)
    public static let uint232: SolidityType = .type(.uint232)
    public static let uint240: SolidityType = .type(.uint240)
    public static let uint248: SolidityType = .type(.uint248)
    public static let uint256: SolidityType = .type(.uint256)
    
    public static let int: SolidityType = .type(.int256)
    public static let int8: SolidityType = .type(.int8)
    public static let int16: SolidityType = .type(.int16)
    public static let int24: SolidityType = .type(.int24)
    public static let int32: SolidityType = .type(.int32)
    public static let int40: SolidityType = .type(.int40)
    public static let int48: SolidityType = .type(.int48)
    public static let int56: SolidityType = .type(.int56)
    public static let int64: SolidityType = .type(.int64)
    public static let int72: SolidityType = .type(.int72)
    public static let int80: SolidityType = .type(.int80)
    public static let int88: SolidityType = .type(.int88)
    public static let int96: SolidityType = .type(.int96)
    public static let int104: SolidityType = .type(.int104)
    public static let int112: SolidityType = .type(.int112)
    public static let int120: SolidityType = .type(.int120)
    public static let int128: SolidityType = .type(.int128)
    public static let int136: SolidityType = .type(.int136)
    public static let int144: SolidityType = .type(.int144)
    public static let int152: SolidityType = .type(.int152)
    public static let int160: SolidityType = .type(.int160)
    public static let int168: SolidityType = .type(.int168)
    public static let int176: SolidityType = .type(.int176)
    public static let int184: SolidityType = .type(.int184)
    public static let int192: SolidityType = .type(.int192)
    public static let int200: SolidityType = .type(.int200)
    public static let int208: SolidityType = .type(.int208)
    public static let int216: SolidityType = .type(.int216)
    public static let int224: SolidityType = .type(.int224)
    public static let int232: SolidityType = .type(.int232)
    public static let int248: SolidityType = .type(.int248)
    public static let int240: SolidityType = .type(.int240)
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
            return types.filter { $0.isDynamic }.count > 0
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
        case .tuple(let types):
            let isDynamic = types.contains(where: { $0.isDynamic })
            if isDynamic {
                return 0
            } else {
                return types.reduce(0, { $0 + $1.staticPartLength })
            }
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
            case 17...32:
                return UInt32.self
            case 33...64:
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
            case 17...32:
                return Int32.self
            case 33...64:
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
