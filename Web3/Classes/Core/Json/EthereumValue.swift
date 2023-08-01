//
//  EthereumValue.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
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

    public static func string(_ string: String) -> EthereumValue {
        return self.init(stringLiteral: string)
    }

    public static func int(_ int: Int) -> EthereumValue {
        return self.init(integerLiteral: int)
    }

    public static func bool(_ bool: Bool) -> EthereumValue {
        return self.init(booleanLiteral: bool)
    }

    public static func array(_ array: [EthereumValueRepresentable]) -> EthereumValue {
        return self.init(array: array)
    }
}

// MARK: - Convenient Getters

public extension EthereumValue {

    public var string: String? {
        if case .string(let string) = valueType {
            return string
        }

        return nil
    }

    public var int: Int? {
        if case .int(let int) = valueType {
            return int
        }

        return nil
    }

    public var bool: Bool? {
        if case .bool(let bool) = valueType {
            return bool
        }

        return nil
    }

    public var array: [EthereumValue]? {
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
