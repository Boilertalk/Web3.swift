//
//  Types+RLPItemConvertible.swift
//  Web3
//
//  Created by Koray Koska on 06.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import BigInt

extension String: RLPItemConvertible {

    public init(rlp: RLPItem) throws {
        guard let str = rlp.string else {
            throw RLPItemInitializableError.notInitializable
        }
        self = str
    }

    public func rlp() -> RLPItem {
        return .string(self)
    }
}

extension UInt: RLPItemConvertible {

    public init(rlp: RLPItem) throws {
        guard let uint = rlp.uint else {
            throw RLPItemInitializableError.notInitializable
        }
        self = uint
    }

    public func rlp() -> RLPItem {
        return .uint(self)
    }
}

extension BigUInt: RLPItemConvertible {

    public init(rlp: RLPItem) throws {
        guard let bigUInt = rlp.bigUInt else {
            throw RLPItemInitializableError.notInitializable
        }
        self = bigUInt
    }

    public func rlp() -> RLPItem {
        return .bigUInt(self)
    }
}
