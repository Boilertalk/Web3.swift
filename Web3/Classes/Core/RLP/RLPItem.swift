//
//  RLPItem.swift
//  Web3
//
//  Created by Koray Koska on 01.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import BigInt

/**
 * An RLP encodable item. Either a byte array or a list of RLP items.
 *
 * More formally:
 *
 * ```
 * G = Bytes | L
 * L = [] | [G]
 * ```
 *
 * Be careful. The maximum safe size of the bytes array is 2GiB (2^31/2^30)
 * as the max allowed elements in an array is 2^31 (for 32 bit systems).
 */
public struct RLPItem {

    /// The internal type of this value
    public let valueType: ValueType

    public enum ValueType {

        /// A bytes value
        case bytes(Bytes)

        /// An array value
        case array([RLPItem])
    }

    public init(valueType: ValueType) {
        self.valueType = valueType
    }
}

// MARK: - Convenient Initializers

public extension RLPItem {

    static func bytes(_ bytes: Bytes) -> RLPItem {
        return RLPItem(bytes: bytes)
    }

    static func bytes(_ bytes: Byte...) -> RLPItem {
        return RLPItem(bytes: bytes)
    }

    init(bytes: Bytes) {
        self.init(valueType: .bytes(bytes))
    }
}

extension RLPItem: ExpressibleByStringLiteral {

    public static func string(_ string: String) -> RLPItem {
        return RLPItem(stringLiteral: string)
    }

    public typealias StringLiteralType = String

    public init(stringLiteral value: String) {
        self.init(valueType: .bytes(value.makeBytes()))
    }
}

extension RLPItem: ExpressibleByIntegerLiteral {

    public static func bigUInt(_ uint: BigUInt) -> RLPItem {
        return self.init(valueType: .bytes(uint.makeBytes().trimLeadingZeros()))
    }

    public static func uint(_ uint: UInt) -> RLPItem {
        return RLPItem(integerLiteral: uint)
    }

    public typealias IntegerLiteralType = UInt

    public init(integerLiteral value: UInt) {
        self.init(valueType: .bytes(value.makeBytes().trimLeadingZeros()))
    }
}

extension RLPItem: ExpressibleByArrayLiteral {

    public static func array(_ array: [RLPItem]) -> RLPItem {
        return self.init(valueType: .array(array))
    }

    public static func array(_ array: RLPItem...) -> RLPItem {
        return self.init(valueType: .array(array))
    }

    public typealias ArrayLiteralElement = RLPItem

    public init(arrayLiteral elements: RLPItem...) {
        self.init(valueType: .array(elements))
    }
}

// MARK: - Convenient Getters

public extension RLPItem {

    /**
     * Returns an array of bytes iff `self.valueType` is .bytes. Returns nil otherwise.
     */
    var bytes: Bytes? {
        guard case .bytes(let value) = valueType else {
            return nil
        }
        return value
    }

    /**
     * Returns the string representation of this item iff `self.valueType` is .bytes. Returns nil otherwise.
     */
    var string: String? {
        guard case .bytes(let value) = valueType else {
            return nil
        }
        return value.makeString()
    }

    /**
     * Returns the uint representation of this item (big endian represented) iff `self.valueType` is .bytes.
     * Returns nil otherwise.
     */
    var uint: UInt? {
        guard case .bytes(let value) = valueType else {
            return nil
        }
        return value.bigEndianUInt
    }

    /**
     * Returns the `BigUInt` representation of this item (big endian represented) iff `self.valueType` is .bytes.
     * Returns nil otherwise.
     */
    var bigUInt: BigUInt? {
        guard case .bytes(let value) = valueType else {
            return nil
        }
        return BigUInt(value)
    }

    /**
     * Returns an array of `RLPItem`'s iff `self.valueType` is .array. Returns nil otherwise.
     */
    var array: [RLPItem]? {
        guard case .array(let elements) = valueType else {
            return nil
        }
        return elements
    }
}

// MARK: - EthereumValueConvertible

extension RLPItem: EthereumValueConvertible {

    public init(ethereumValue: EthereumValue) throws {
        let data = try EthereumData(ethereumValue: ethereumValue)
        self.init(bytes: data.makeBytes())
    }

    public func ethereumValue() -> EthereumValue {
        let encoder = RLPEncoder()
        let string = try? encoder.encode(self).hexString(prefix: true)
        return .string(string ?? "0x")
    }
}

// MARK: - CustomStringConvertible

extension RLPItem: CustomStringConvertible {

    public var description: String {
        var str = ""
        switch valueType {
        case .bytes(let bytes):
            str = bytes.map({ "0x\(String($0, radix: 16))" }).description
        case .array(let array):
            /*
             str = "["
             for el in array {
             str += "\n"
             str += el.description
             str += ", "
             }
             if array.count > 0 {
             str += "\n"
             }
             str += "]"
             */
            str = array.description
        }

        return str
    }
}

// MARK: - Equatable

extension RLPItem.ValueType: Equatable {

    public static func ==(_ lhs: RLPItem.ValueType, _ rhs: RLPItem.ValueType) -> Bool {
        switch lhs {
        case .array(let arr):
            if case .array(let rArr) = rhs {
                return arr == rArr
            }
        case .bytes(let bytes):
            if case .bytes(let rBytes) = rhs {
                return bytes == rBytes
            }
        }

        return false
    }
}

extension RLPItem: Equatable {

    public static func ==(_ lhs: RLPItem, _ rhs: RLPItem) -> Bool {
        return lhs.valueType == rhs.valueType
    }
}

// MARK: - Hashable

extension RLPItem.ValueType: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .array(let arr):
            hasher.combine(arr)
        case .bytes(let bytes):
            hasher.combine(bytes)
        }
    }
}

extension RLPItem: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(valueType)
    }
}
