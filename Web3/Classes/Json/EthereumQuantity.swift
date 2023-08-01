//
//  EthereumQuantity.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//

import Foundation
import BigInt
import VaporBytes

public struct EthereumQuantity {

    public let quantity: BigUInt

    public static func bytes(_ bytes: Bytes) -> EthereumQuantity {
        return self.init(quantity: BigUInt(bytes: bytes))
    }

    public init(quantity: BigUInt) {
        self.quantity = quantity
    }
}

extension EthereumQuantity: ExpressibleByIntegerLiteral {

    public typealias IntegerLiteralType = UInt64

    public init(integerLiteral value: UInt64) {
        self.init(quantity: BigUInt(value))
    }
}

extension EthereumQuantity: EthereumValueConvertible {

    public init(ethereumValue: EthereumValue) throws {
        guard let str = ethereumValue.string else {
            throw EthereumValueInitializableError.notInitializable
        }

        try self.init(quantity: BigUInt(bytes: str.hexBytes()))
    }

    public func ethereumValue() -> EthereumValue {
        return .init(stringLiteral: quantity.makeBytes().quantityHexString(prefix: true))
    }
}
