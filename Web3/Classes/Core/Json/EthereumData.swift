//
//  EthereumData.swift
//  Web3
//
//  Created by Koray Koska on 11.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public struct EthereumData: BytesConvertible {

    public let bytes: Bytes

    public init(_ bytes: Bytes) {
        self.bytes = bytes
    }

    public func makeBytes() -> Bytes {
        return bytes
    }

    public func hex() -> String {
        return bytes.hexString(prefix: true)
    }
}

extension EthereumData: EthereumValueConvertible {

    public static func string(_ string: String) throws -> EthereumData {
        return try self.init(ethereumValue: .string(string))
    }

    public init(ethereumValue: EthereumValue) throws {
        guard let str = ethereumValue.string else {
            throw EthereumValueInitializableError.notInitializable
        }

        try self.init(str.hexBytes())
    }

    public func ethereumValue() -> EthereumValue {
        return EthereumValue(stringLiteral: bytes.hexString(prefix: true))
    }
}

public extension EthereumValue {

    var ethereumData: EthereumData? {
        return try? EthereumData(ethereumValue: self)
    }
}

// MARK: - Equatable

extension EthereumData: Equatable {

    public static func ==(_ lhs: EthereumData, _ rhs: EthereumData) -> Bool {
        return lhs.bytes == rhs.bytes
    }
}

// MARK: - Hashable

extension EthereumData: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bytes)
    }
}
