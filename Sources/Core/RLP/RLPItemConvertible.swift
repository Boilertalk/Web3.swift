//
//  RLPItemConvertible.swift
//  Web3
//
//  Created by Koray Koska on 06.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

/**
 * Objects which can be converted to rlp items can implement this.
 */
public protocol RLPItemRepresentable {

    /**
     * Converts `self` to an rlp item.
     *
     * - returns: The generated `RLPItem`.
     */
    func rlp() throws -> RLPItem
}

/**
 * Objects which can be initialized with `RLPItem`'s can implement this.
 */
public protocol RLPItemInitializable {

    /**
     * Initializes `self` with the given rlp item if possible. Throws otherwise.
     *
     * - parameter rlp: The rlp item to be converted into `self`.
     */
    init(rlp: RLPItem) throws
}

/**
 * Objects which are both representable and initializable by and with `RLPItem`'s.
 */
public typealias RLPItemConvertible = RLPItemRepresentable & RLPItemInitializable

extension RLPItemInitializable {

    public init(rlp: RLPItemRepresentable) throws {
        let r = try rlp.rlp()
        try self.init(rlp: r)
    }
}

public enum RLPItemRepresentableError: Swift.Error {

    case notRepresentable
}

public enum RLPItemInitializableError: Swift.Error {

    case notInitializable
}
