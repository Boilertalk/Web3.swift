//
//  EthereumQuantityTag.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation



public struct QuantityTag {

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

public extension QuantityTag {

    static var latest: QuantityTag {
        return self.init(tagType: .latest)
    }

    static var earliest: QuantityTag {
        return self.init(tagType: .earliest)
    }

    static var pending: QuantityTag {
        return self.init(tagType: .pending)
    }

    static func block(_ bigUInt: BigUInt) -> QuantityTag {
        return self.init(tagType: .block(bigUInt))
    }
}

extension QuantityTag: ValueConvertible {

    public static func string(_ string: String) throws -> QuantityTag {
        return try self.init(value: .string(string))
    }

    public init(value: Value) throws {
        guard let str = value.string else {
            throw ValueInitializableError.notInitializable
        }

        if str == "latest" {
            tagType = .latest
        } else if str == "earliest" {
            tagType = .earliest
        } else if str == "pending" {
            tagType = .pending
        } else {
            guard let hex = try? BigUInt(str.quantityHexBytes()) else {
                throw ValueInitializableError.notInitializable
            }
            tagType = .block(hex)
        }
    }

    public func value() -> Value {
        switch tagType {
        case .latest:
            return "latest"
        case .earliest:
            return "earliest"
        case .pending:
            return "pending"
        case .block(let bigUInt):
            return Value(stringLiteral: bigUInt.makeBytes().quantityHexString(prefix: true))
        }
    }
}

// MARK: - Equatable

extension QuantityTag.TagType: Equatable {

    public static func ==(lhs: QuantityTag.TagType, rhs: QuantityTag.TagType) -> Bool {
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

extension QuantityTag: Equatable {

    public static func ==(_ lhs: QuantityTag, _ rhs: QuantityTag) -> Bool {
        return lhs.tagType == rhs.tagType
    }
}

// MARK: - Hashable

extension QuantityTag.TagType: Hashable {

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

extension QuantityTag: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(tagType)
    }
}
