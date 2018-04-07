//
//  EthereumQuantity.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import BigInt

public struct EthereumQuantity {

    public let quantity: BigUInt

    public static func bytes(_ bytes: Bytes) -> EthereumQuantity {
        return self.init(quantity: BigUInt(bytes: bytes))
    }

    public init(quantity: BigUInt) {
        self.quantity = quantity
    }

    public func hex() -> String {
        return quantity.makeBytes().quantityHexString(prefix: true)
    }
}

extension EthereumQuantity: ExpressibleByIntegerLiteral {

    public typealias IntegerLiteralType = UInt64

    public init(integerLiteral value: UInt64) {
        self.init(quantity: BigUInt(value))
    }
}

extension EthereumQuantity: EthereumValueConvertible {

    public static func string(_ string: String) throws -> EthereumQuantity {
        return try self.init(ethereumValue: .string(string))
    }

    public init(ethereumValue: EthereumValue) throws {
        guard let str = ethereumValue.string else {
            throw EthereumValueInitializableError.notInitializable
        }

        try self.init(quantity: BigUInt(bytes: str.quantityHexBytes()))
    }

    public func ethereumValue() -> EthereumValue {
        return .init(stringLiteral: quantity.makeBytes().quantityHexString(prefix: true))
    }
}

public extension EthereumValue {

    public var ethereumQuantity: EthereumQuantity? {
        return try? EthereumQuantity(ethereumValue: self)
    }
}

// MARK: - BytesConvertible

extension EthereumQuantity: BytesConvertible {

    public init(bytes: Bytes) {
        self = EthereumQuantity.bytes(bytes)
    }

    public func makeBytes() -> Bytes {
        return quantity.makeBytes()
    }
}

// MARK: - Equatable

extension EthereumQuantity: Equatable {

    public static func ==(_ lhs: EthereumQuantity, _ rhs: EthereumQuantity) -> Bool {
        return lhs.quantity == rhs.quantity
    }
}

// MARK: - Hashable

extension EthereumQuantity: Hashable {

    public var hashValue: Int {
        return hashValues(quantity)
    }
}
