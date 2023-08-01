//
//  Types+EthereumValueConvertible.swift
//  Web3
//
//  Created by Koray Koska on 11.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

extension Bool: EthereumValueConvertible {

    public init(ethereumValue: EthereumValue) throws {
        guard let bool = ethereumValue.bool else {
            throw EthereumValueInitializableError.notInitializable
        }

        self = bool
    }

    public func ethereumValue() -> EthereumValue {
        return .bool(self)
    }
}

extension String: EthereumValueConvertible {

    public init(ethereumValue: EthereumValue) throws {
        guard let str = ethereumValue.string else {
            throw EthereumValueInitializableError.notInitializable
        }

        self = str
    }

    public func ethereumValue() -> EthereumValue {
        return .string(self)
    }
}

extension Int: EthereumValueConvertible {

    public init(ethereumValue: EthereumValue) throws {
        guard let int = ethereumValue.int else {
            throw EthereumValueInitializableError.notInitializable
        }

        self = int
    }

    public func ethereumValue() -> EthereumValue {
        return .int(self)
    }
}
