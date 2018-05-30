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

        try self.init(functionSelector: str)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        try container.encode(functionSelector)
    }

    public enum Error: Swift.Error {

        case unknownType
    }

    // MARK: - String conversion

    public init(functionSelector selector: String) throws {
        if selector.hasSuffix("[]") {
            self = .dynamicArray(type: try ContractABIType(functionSelector: String(selector.dropLast("[]".count))))
        } else if selector.hasSuffix("]") {
            guard let lastOpen = selector.range(of: "[", options: .backwards) else {
                throw Error.unknownType
            }
            let typeStr = String(selector[selector.startIndex..<lastOpen.lowerBound])
            let countStr = String(selector[lastOpen.lowerBound..<selector.endIndex].dropFirst("[".count).dropLast("]".count))

            guard let count = UInt(countStr) else {
                throw Error.unknownType
            }
            let type = try ContractABIType(functionSelector: typeStr)

            self = .array(type: type, count: count)
        } else if selector == "uint" {
            self = .uint(bits: 256)
        } else if selector == "int" {
            self = .int(bits: 256)
        } else if selector == "address" {
            self = .address
        } else if selector == "bool" {
            self = .bool
        } else if selector == "fixed" {
            self = .fixed(bits: 128, dividerExponent: 18)
        } else if selector == "ufixed" {
            self = .ufixed(bits: 128, dividerExponent: 18)
        } else if selector == "bytes" {
            self = .dynamicBytes
        } else if selector == "string" {
            self = .dynamicString
        } else if selector == "function" {
            self = .bytes(count: 24)
        } else if selector == "tuple" {
            self = .tuple
        } else if selector.hasPrefix("uint") {
            guard let bits = UInt16(String(selector.dropFirst("uint".count))), bits > 0, bits <= 256, bits % 8 == 0 else {
                throw Error.unknownType
            }
            self = .uint(bits: bits)
        } else if selector.hasPrefix("int") {
            guard let bits = UInt16(String(selector.dropFirst("int".count))), bits > 0, bits <= 256, bits % 8 == 0 else {
                throw Error.unknownType
            }
            self = .int(bits: bits)
        } else if selector.hasPrefix("fixed") {
            let numbers = String(selector.dropFirst("fixed".count)).split(separator: "x")
            guard numbers.count == 2, let bits = UInt16(numbers[0]), let dividerExponent = UInt8(numbers[1]),
                bits >= 8, bits <= 256, bits % 8 == 0, dividerExponent > 0, dividerExponent <= 80 else {
                    throw Error.unknownType
            }
            self = .fixed(bits: bits, dividerExponent: dividerExponent)
        } else if selector.hasPrefix("ufixed") {
            let numbers = String(selector.dropFirst("ufixed".count)).split(separator: "x")
            guard numbers.count == 2, let bits = UInt16(numbers[0]), let dividerExponent = UInt8(numbers[1]),
                bits >= 8, bits <= 256, bits % 8 == 0, dividerExponent > 0, dividerExponent <= 80 else {
                    throw Error.unknownType
            }
            self = .ufixed(bits: bits, dividerExponent: dividerExponent)
        } else if selector.hasPrefix("bytes") {
            guard let count = UInt8(String(selector.dropFirst("bytes".count))), count > 0, count <= 32 else {
                throw Error.unknownType
            }
            self = .bytes(count: count)
        } else {
            throw Error.unknownType
        }
    }

    public var functionSelector: String {
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
            return "\(type.functionSelector)[\(count)]"
        case .dynamicBytes:
            return "bytes"
        case .dynamicString:
            return "string"
        case .dynamicArray(let type):
            return "\(type.functionSelector)[]"
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
