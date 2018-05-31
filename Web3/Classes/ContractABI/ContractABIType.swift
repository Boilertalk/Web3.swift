//
//  ContractABIType.swift
//  Web3
//
//  Created by Koray Koska on 28.05.18.
//

import Foundation

public enum ContractABIType: Codable {

    // MARK: - Types

    case uint(bits: UInt16)

    case int(bits: UInt16)

    case address

    case bool

    case fixed(bits: UInt16, dividerExponent: UInt8)

    case ufixed(bits: UInt16, dividerExponent: UInt8)

    case bytes(count: UInt8)

    indirect case array(type: ContractABIType, count: UInt)

    case dynamicBytes

    case dynamicString

    indirect case dynamicArray(type: ContractABIType)

    case tuple

    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let str = try decoder.singleValueContainer().decode(String.self)

        try self.init(string: str)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        try container.encode(string)
    }

    public enum Error: Swift.Error {

        case unknownType
    }

    // MARK: - String conversion

    public init(string type: String) throws {
        if type.hasSuffix("[]") {
            self = .dynamicArray(type: try ContractABIType(string: String(type.dropLast("[]".count))))
        } else if type.hasSuffix("]") {
            guard let lastOpen = type.range(of: "[", options: .backwards) else {
                throw Error.unknownType
            }
            let typeStr = String(type[type.startIndex..<lastOpen.lowerBound])
            let countStr = String(type[lastOpen.lowerBound..<type.endIndex].dropFirst("[".count).dropLast("]".count))

            guard let count = UInt(countStr) else {
                throw Error.unknownType
            }
            let type = try ContractABIType(string: typeStr)

            self = .array(type: type, count: count)
        } else if type == "uint" {
            self = .uint(bits: 256)
        } else if type == "int" {
            self = .int(bits: 256)
        } else if type == "address" {
            self = .address
        } else if type == "bool" {
            self = .bool
        } else if type == "fixed" {
            self = .fixed(bits: 128, dividerExponent: 18)
        } else if type == "ufixed" {
            self = .ufixed(bits: 128, dividerExponent: 18)
        } else if type == "bytes" {
            self = .dynamicBytes
        } else if type == "string" {
            self = .dynamicString
        } else if type == "function" {
            self = .bytes(count: 24)
        } else if type == "tuple" {
            self = .tuple
        } else if type.hasPrefix("uint") {
            guard let bits = UInt16(String(type.dropFirst("uint".count))), bits > 0, bits <= 256, bits % 8 == 0 else {
                throw Error.unknownType
            }
            self = .uint(bits: bits)
        } else if type.hasPrefix("int") {
            guard let bits = UInt16(String(type.dropFirst("int".count))), bits > 0, bits <= 256, bits % 8 == 0 else {
                throw Error.unknownType
            }
            self = .int(bits: bits)
        } else if type.hasPrefix("fixed") {
            let numbers = String(type.dropFirst("fixed".count)).split(separator: "x")
            guard numbers.count == 2, let bits = UInt16(numbers[0]), let dividerExponent = UInt8(numbers[1]),
                bits >= 8, bits <= 256, bits % 8 == 0, dividerExponent > 0, dividerExponent <= 80 else {
                    throw Error.unknownType
            }
            self = .fixed(bits: bits, dividerExponent: dividerExponent)
        } else if type.hasPrefix("ufixed") {
            let numbers = String(type.dropFirst("ufixed".count)).split(separator: "x")
            guard numbers.count == 2, let bits = UInt16(numbers[0]), let dividerExponent = UInt8(numbers[1]),
                bits >= 8, bits <= 256, bits % 8 == 0, dividerExponent > 0, dividerExponent <= 80 else {
                    throw Error.unknownType
            }
            self = .ufixed(bits: bits, dividerExponent: dividerExponent)
        } else if type.hasPrefix("bytes") {
            guard let count = UInt8(String(type.dropFirst("bytes".count))), count > 0, count <= 32 else {
                throw Error.unknownType
            }
            self = .bytes(count: count)
        } else {
            throw Error.unknownType
        }
    }

    public var string: String {
        switch self {
        case .uint(let bits):
            return "uint\(bits)"
        case .int(let bits):
            return "int\(bits)"
        case .address:
            return "address"
        case .bool:
            return "bool"
        case .fixed(let bits, let dividerExponent):
            return "fixed\(bits)x\(dividerExponent)"
        case .ufixed(let bits, let dividerExponent):
            return "ufixed\(bits)x\(dividerExponent)"
        case .bytes(let count):
            return "bytes\(count)"
        case .array(let type, let count):
            return "\(type.string)[\(count)]"
        case .dynamicBytes:
            return "bytes"
        case .dynamicString:
            return "string"
        case .dynamicArray(let type):
            return "\(type.string)[]"
        case .tuple:
            return "tuple"
        }
    }
}

// MARK: - Equatable

extension ContractABIType: Equatable {

    public static func ==(_ lhs: ContractABIType, _ rhs: ContractABIType) -> Bool {
        switch lhs {
        case .uint(let bits):
            if case .uint(let rBits) = rhs {
                return bits == rBits
            }
            return false
        case .int(let bits):
            if case .int(let rBits) = rhs {
                return bits == rBits
            }
            return false
        case .address:
            if case .address = rhs {
                return true
            }
            return false
        case .bool:
            if case .bool = rhs {
                return true
            }
            return false
        case .fixed(let bits, let dividerExponent):
            if case .fixed(let rBits, let rDividerExponent) = rhs {
                return bits == rBits && dividerExponent == rDividerExponent
            }
            return false
        case .ufixed(let bits, let dividerExponent):
            if case .ufixed(let rBits, let rDividerExponent) = rhs {
                return bits == rBits && dividerExponent == rDividerExponent
            }
            return false
        case .bytes(let count):
            if case .bytes(let rCount) = rhs {
                return count == rCount
            }
            return false
        case .array(let type, let count):
            if case .array(let rType, let rCount) = rhs {
                return type == rType && count == rCount
            }
            return false
        case .dynamicBytes:
            if case .dynamicBytes = rhs {
                return true
            }
            return false
        case .dynamicString:
            if case .dynamicString = rhs {
                return true
            }
            return false
        case .dynamicArray(let type):
            if case .dynamicArray(let rType) = rhs {
                return type == rType
            }
            return false
        case .tuple:
            if case .tuple = rhs {
                return true
            }
            return false
        }
    }
}
