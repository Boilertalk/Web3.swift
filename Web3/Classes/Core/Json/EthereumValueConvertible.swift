//
//  EthereumValueConvertible.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

/**
 * Objects which can be converted to `EthereumValue` can implement this.
 */
public protocol EthereumValueRepresentable: Encodable {

    /**
     * Converts `self` to `EthereumValue`.
     *
     * - returns: The generated `EthereumValue`.
     */
    func ethereumValue() -> EthereumValue
}

/**
 * Objects which can be initialized with `EthereumValue`'s can implement this.
 */
public protocol EthereumValueInitializable: Decodable {

    /**
     * Initializes `self` with the given `EthereumValue` if possible. Throws otherwise.
     *
     * - parameter ethereumValue: The `EthereumValue` to be converted to `self`.
     */
    init(ethereumValue: EthereumValue) throws
}

/**
 * Objects which are both representable and initializable by and with `EthereumValue`'s.
 */
public typealias EthereumValueConvertible = EthereumValueRepresentable & EthereumValueInitializable

extension EthereumValueInitializable {

    public init(ethereumValue: EthereumValueRepresentable) throws {
        let e = ethereumValue.ethereumValue()
        try self.init(ethereumValue: e)
    }
}

// MARK: - Default Codable

extension EthereumValueRepresentable {

    public func encode(to encoder: Encoder) throws {
        try ethereumValue().encode(to: encoder)
    }
}

extension EthereumValueInitializable {

    public init(from decoder: Decoder) throws {
        try self.init(ethereumValue: EthereumValue(from: decoder))
    }
}

// MARK: - Errors

public enum EthereumValueRepresentableError: Swift.Error {

    case notRepresentable
}

public enum EthereumValueInitializableError: Swift.Error {

    case notInitializable
}
