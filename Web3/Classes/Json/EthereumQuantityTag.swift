//
//  EthereumQuantityTag.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//

import Foundation
import VaporBytes
import CryptoSwift

public struct EthereumQuantityTag {

    public enum TagType {

        case block(UInt)
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

    public static func block(_ uint: UInt) -> EthereumQuantityTag {
        return self.init(tagType: .block(uint))
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
            guard let h = try? str.hexBytes().bigEndianUInt, let hex = h else {
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
        case .block(let uint):
            return EthereumValue(stringLiteral: uint.makeBytes().quantityHexString(prefix: true))
        }
    }
}
