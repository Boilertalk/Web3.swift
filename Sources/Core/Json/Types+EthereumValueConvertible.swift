//
//  Types+valueConvertible.swift
//  Web3
//
//  Created by Koray Koska on 11.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

extension Bool: ValueConvertible {

    public init(value: Value) throws {
        guard let bool = value.bool else {
            throw ValueInitializableError.notInitializable
        }

        self = bool
    }

    public func value() -> Value {
        return .bool(self)
    }
}

extension String: ValueConvertible {

    public init(value: Value) throws {
        guard let str = value.string else {
            throw ValueInitializableError.notInitializable
        }

        self = str
    }

    public func value() -> Value {
        return .string(self)
    }
}

extension Int: ValueConvertible {

    public init(value: Value) throws {
        guard let int = value.int else {
            throw ValueInitializableError.notInitializable
        }

        self = int
    }

    public func value() -> Value {
        return .int(self)
    }
}
