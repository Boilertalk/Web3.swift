//
//  valueConvertible.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

/**
 * Objects which can be converted to `value` can implement this.
 */
public protocol ValueRepresentable: Encodable {

    /**
     * Converts `self` to `value`.
     *
     * - returns: The generated `value`.
     */
    func value() -> Value
}

/**
 * Objects which can be initialized with `value`'s can implement this.
 */
public protocol ValueInitializable: Decodable {

    /**
     * Initializes `self` with the given `value` if possible. Throws otherwise.
     *
     * - parameter value: The `value` to be converted to `self`.
     */
    init(value: Value) throws
}

/**
 * Objects which are both representable and initializable by and with `value`'s.
 */
public typealias ValueConvertible = ValueRepresentable & ValueInitializable

extension ValueInitializable {

    public init(value: ValueRepresentable) throws {
        let e = value.value()
        try self.init(value: e)
    }
}

// MARK: - Default Codable

extension ValueRepresentable {

    public func encode(to encoder: Encoder) throws {
        try value().encode(to: encoder)
    }
}

extension ValueInitializable {

    public init(from decoder: Decoder) throws {
        try self.init(value: Value(from: decoder))
    }
}

// MARK: - Errors

public enum ValueRepresentableError: Swift.Error {

    case notRepresentable
}

public enum ValueInitializableError: Swift.Error {

    case notInitializable
}
