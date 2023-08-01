//
//  EthereumValueConvertible.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//

import Foundation

/**
 * Objects which can be converted to `EthereumValue` can implement this.
 */
public protocol EthereumValueRepresentable {

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
public protocol EthereumValueInitializable {

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

public enum EthereumValueRepresentableError: Swift.Error {

    case notRepresentable
}

public enum EthereumValueInitializableError: Swift.Error {

    case notInitializable
}
