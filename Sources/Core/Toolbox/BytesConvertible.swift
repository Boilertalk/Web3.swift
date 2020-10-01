//
//  BytesConvertible.swift
//  Web3
//
//  Created by Koray Koska on 06.04.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

/// UInt8 typealias
public typealias Byte = UInt8

/// [UInt8] typealias
public typealias Bytes = [Byte]

/**
 * Implementable if the type can be converted to Bytes
 */
public protocol BytesRepresentable {
    func makeBytes() throws -> Bytes
}

/**
 * Implementable if the type can be represented with Bytes
 */
public protocol BytesInitializable {
    init(_ bytes: Bytes) throws
}

/**
 * Implementable if a type is BytesRepresentable and BytesInitializable
 */
public typealias BytesConvertible = BytesRepresentable & BytesInitializable

public extension BytesInitializable {
    init(_ bytes: BytesRepresentable) throws {
        let bytes = try bytes.makeBytes()
        try self.init(bytes)
    }
}
