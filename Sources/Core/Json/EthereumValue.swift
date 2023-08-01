//
//  EthereumValue.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

/**
 * A `Codable`, Ethereum representable value.
 */
public struct EthereumValue: Codable {

    /// The internal type of this value
    public let valueType: ValueType

    public enum ValueType {

        /// A string value
        case string(String)

        /// An int value
        case int(Int)

        /// A bool value
        case bool(Bool)

        /// An array value
        case array([EthereumValue])

        /// A special case nil value
        case `nil`
    }

    public init(valueType: ValueType) {
        self.valueType = valueType
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let str = try? container.decode(String.self) {
            valueType = .string(str)
        } else if let bool = try? container.decode(Bool.self) {
            valueType = .bool(bool)
        } else if let int = try? container.decode(Int.self) {
            valueType = .int(int)
        } else if let array = try? container.decode([EthereumValue].self) {
            valueType = .array(array)
        } else if container.decodeNil() {
            valueType = .nil
        } else {
            throw Error.unsupportedType
        }
    }

    /// Encoding and Decoding errors specific to EthereumValue
    public enum Error: Swift.Error {

        /// The type set is not convertible to EthereumValue
        case unsupportedType
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch valueType {
        case .string(let string):
            try container.encode(string)
        case .int(let int):
            try container.encode(int)
        case .bool(let bool):
            try container.encode(bool)
        case .array(let array):
            try container.encode(array)
        case .nil:
            try container.encodeNil()
        }
    }
}

// MARK: - Convenient Initializers

extension EthereumValue: ExpressibleByStringLiteral {

    public typealias StringLiteralType = String

    public init(stringLiteral value: StringLiteralType) {
        valueType = .string(value)
    }
}

extension EthereumValue: ExpressibleByIntegerLiteral {

    public typealias IntegerLiteralType = Int

    public init(integerLiteral value: IntegerLiteralType) {
        valueType = .int(value)
    }
}

extension EthereumValue: ExpressibleByBooleanLiteral {

    public typealias BooleanLiteralType = Bool

    public init(booleanLiteral value: BooleanLiteralType) {
        valueType = .bool(value)
    }
}

extension EthereumValue: ExpressibleByArrayLiteral {

    public typealias ArrayLiteralElement = EthereumValueRepresentable

    public init(array: [EthereumValueRepresentable]) {
        let values = array.map({ $0.ethereumValue() })
        valueType = .array(values)
    }

    public init(arrayLiteral elements: ArrayLiteralElement...) {
        self.init(array: elements)
    }
}

// MARK: - Convenient Setters

public extension EthereumValue {

    static func string(_ string: String) -> EthereumValue {
        return self.init(stringLiteral: string)
    }

    static func int(_ int: Int) -> EthereumValue {
        return self.init(integerLiteral: int)
    }

    static func bool(_ bool: Bool) -> EthereumValue {
        return self.init(booleanLiteral: bool)
    }

    static func array(_ array: [EthereumValueRepresentable]) -> EthereumValue {
        return self.init(array: array)
    }
}

// MARK: - Convenient Getters

public extension EthereumValue {

    var string: String? {
        if case .string(let string) = valueType {
            return string
        }

        return nil
    }

    var int: Int? {
        if case .int(let int) = valueType {
            return int
        }

        return nil
    }

    var bool: Bool? {
        if case .bool(let bool) = valueType {
            return bool
        }

        return nil
    }

    var array: [EthereumValue]? {
        if case .array(let array) = valueType {
            return array
        }

        return nil
    }
}

// MARK: - EthereumValueConvertible

extension EthereumValue: EthereumValueConvertible {

    public init(ethereumValue: EthereumValue) {
        self = ethereumValue
    }

    public func ethereumValue() -> EthereumValue {
        return self
    }
}

// MARK: - Equatable

extension EthereumValue.ValueType: Equatable {

    public static func ==(_ lhs: EthereumValue.ValueType, _ rhs: EthereumValue.ValueType) -> Bool {
        switch lhs {
        case .string(let str):
            if case .string(let rStr) = rhs {
                return str == rStr
            }
            return false
        case .int(let int):
            if case .int(let rInt) = rhs {
                return int == rInt
            }
            return false
        case .bool(let bool):
            if case .bool(let rBool) = rhs {
                return bool == rBool
            }
            return false
        case .array(let array):
            if case .array(let rArray) = rhs {
                return array == rArray
            }
            return false
        case .nil:
            if case .nil = rhs {
                return true
            }
            return false
        }
    }
}

extension EthereumValue: Equatable {

    public static func ==(_ lhs: EthereumValue, _ rhs: EthereumValue) -> Bool {
        return lhs.valueType == rhs.valueType
    }
}

// MARK: - Hashable

extension EthereumValue.ValueType: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .string(let str):
            hasher.combine(str)
        case .int(let int):
            hasher.combine(int)
        case .bool(let bool):
            hasher.combine(bool)
        case .array(let array):
            hasher.combine(array)
        case .nil:
            hasher.combine(0x00)
        }
    }
}

extension EthereumValue: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(valueType)
    }
}
