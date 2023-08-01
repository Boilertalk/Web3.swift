//
//  EthereumQuantityTag.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
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

    static var latest: EthereumQuantityTag {
        return self.init(tagType: .latest)
    }

    static var earliest: EthereumQuantityTag {
        return self.init(tagType: .earliest)
    }

    static var pending: EthereumQuantityTag {
        return self.init(tagType: .pending)
    }

    static func block(_ bigUInt: BigUInt) -> EthereumQuantityTag {
        return self.init(tagType: .block(bigUInt))
    }
}

extension EthereumQuantityTag: EthereumValueConvertible {

    public static func string(_ string: String) throws -> EthereumQuantityTag {
        return try self.init(ethereumValue: .string(string))
    }

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
            guard let hex = try? BigUInt(str.quantityHexBytes()) else {
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

// MARK: - Equatable

extension EthereumQuantityTag.TagType: Equatable {

    public static func ==(lhs: EthereumQuantityTag.TagType, rhs: EthereumQuantityTag.TagType) -> Bool {
        switch lhs {
        case .block(let bigLeft):
            if case .block(let bigRight) = rhs {
                return bigLeft == bigRight
            }
            return false
        case .latest:
            if case .latest = rhs {
                return true
            }
            return false
        case .earliest:
            if case .earliest = rhs {
                return true
            }
            return false
        case .pending:
            if case .pending = rhs {
                return true
            }
            return false
        }
    }
}

extension EthereumQuantityTag: Equatable {

    public static func ==(_ lhs: EthereumQuantityTag, _ rhs: EthereumQuantityTag) -> Bool {
        return lhs.tagType == rhs.tagType
    }
}

// MARK: - Hashable

extension EthereumQuantityTag.TagType: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .block(let bigInt):
            hasher.combine(0x00)
            hasher.combine(bigInt)
        case .latest:
            hasher.combine(0x01)
        case .earliest:
            hasher.combine(0x02)
        case .pending:
            hasher.combine(0x03)
        }
    }
}

extension EthereumQuantityTag: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(tagType)
    }
}
