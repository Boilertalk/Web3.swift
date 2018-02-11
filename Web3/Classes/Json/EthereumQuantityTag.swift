//
//  EthereumQuantityTag.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//

import Foundation
import VaporBytes
import CryptoSwift
import BigInt

public struct EthereumQuantityTag {

    public enum TagType {

        case block(BigUInt)
        case latest
        case earliest
        case pending
    }

    public let tagType: TagType

    public init(tagType: TagType) {
        self.tagType = tagType
    }
}

public extension EthereumQuantityTag {

    public static var latest: EthereumQuantityTag {
        return self.init(tagType: .latest)
    }

    public static var earliest: EthereumQuantityTag {
        return self.init(tagType: .earliest)
    }

    public static var pending: EthereumQuantityTag {
        return self.init(tagType: .pending)
    }

    public static func block(_ bigUInt: BigUInt) -> EthereumQuantityTag {
        return self.init(tagType: .block(bigUInt))
    }
}

extension EthereumQuantityTag: EthereumValueConvertible {

    public init(ethereumValue: EthereumValue) throws {
        guard let str = ethereumValue.string else {
            throw EthereumValueInitializableError.notInitializable
        }

        if str == "latest" {
            tagType = .latest
        } else if str == "earliest" {
            tagType = .earliest
        } else if str == "pending" {
            tagType = .pending
        } else {
            guard let hex = try? BigUInt(bytes: str.quantityHexBytes()) else {
                throw EthereumValueInitializableError.notInitializable
            }
            tagType = .block(hex)
        }
    }

    public func ethereumValue() -> EthereumValue {
        switch tagType {
        case .latest:
            return "latest"
        case .earliest:
            return "earliest"
        case .pending:
            return "pending"
        case .block(let bigUInt):
            return EthereumValue(stringLiteral: bigUInt.makeBytes().quantityHexString(prefix: true))
        }
    }
}
