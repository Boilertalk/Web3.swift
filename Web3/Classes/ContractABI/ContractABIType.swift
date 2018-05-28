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

    indirect case tuple(types: [ContractABIType])

    // MARK: Codable

    public init(from decoder: Decoder) throws {
        let str = try decoder.singleValueContainer().decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
    }

    public enum Error: Swift.Error {

        case unknownType
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
        case .tuple(let types):
            var tupleSelector = "("
            var first = true
            for t in types {
                if !first {
                    tupleSelector += ","
                } else {
                    first = false
                }
                tupleSelector += "\(t.functionSelector)"
            }
            return tupleSelector
        }
    }
}
