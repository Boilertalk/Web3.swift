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

    public var hashValue: Int {
        switch self {
        case .block(let bigInt):
            return hashValues(bigInt)
        case .latest:
            return hashValues(Byte(0x01))
        case .earliest:
            return hashValues(Byte(0x02))
        case .pending:
            return hashValues(Byte(0x03))
        }
    }
}

extension EthereumQuantityTag: Hashable {

    public var hashValue: Int {
        return tagType.hashValue
    }
}
