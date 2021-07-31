//
//  EthereumQuantity.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import BigInt

public struct Quantity {

    public let quantity: BigUInt

    public static func bytes(_ bytes: Bytes) -> Quantity {
        return self.init(quantity: BigUInt(bytes))
    }

    public init(quantity: BigUInt) {
        self.quantity = quantity
    }

    public func hex() -> String {
        return quantity.makeBytes().quantityHexString(prefix: true)
    }
}

extension Quantity: ExpressibleByIntegerLiteral {

    public typealias IntegerLiteralType = UInt64

    public init(integerLiteral value: UInt64) {
        self.init(quantity: BigUInt.init(integerLiteral: value))
    }
}

extension Quantity: ValueConvertible {

    public static func string(_ string: String) throws -> Quantity {
        return try self.init(value: .string(string))
    }

    public init(value: Value) throws {
        guard let str = value.string else {
            throw ValueInitializableError.notInitializable
        }

        try self.init(quantity: BigUInt(str.quantityHexBytes()))
    }

    public func value() -> Value {
        return .init(stringLiteral: quantity.makeBytes().quantityHexString(prefix: true))
    }
}

public extension Value {

    var ethereumQuantity: Quantity? {
        return try? Quantity(value: self)
    }
}

// MARK: - BytesConvertible

extension Quantity: BytesConvertible {

    public init(_ bytes: Bytes) {
        self = Quantity.bytes(bytes)
    }

    public func makeBytes() -> Bytes {
        return quantity.makeBytes()
    }
}

// MARK: - Equatable

extension Quantity: Equatable {

    public static func ==(_ lhs: Quantity, _ rhs: Quantity) -> Bool {
        return lhs.quantity == rhs.quantity
    }
}

// MARK: - Hashable

extension Quantity: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(quantity)
    }
}
