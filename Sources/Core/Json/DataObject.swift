//
//  EthereumData.swift
//  Web3
//
//  Created by Koray Koska on 11.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public struct DataObject: BytesConvertible {

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

extension DataObject: ValueConvertible {

    public static func string(_ string: String) throws -> DataObject {
        return try self.init(value: .string(string))
    }

    public init(value: Value) throws {
        guard let str = value.string else {
            throw ValueInitializableError.notInitializable
        }

        try self.init(str.hexBytes())
    }

    public func value() -> Value {
        return Value(stringLiteral: bytes.hexString(prefix: true))
    }
}

public extension Value {

    var ethereumData: DataObject? {
        return try? DataObject(value: self)
    }
}

// MARK: - Equatable

extension DataObject: Equatable {

    public static func ==(_ lhs: DataObject, _ rhs: DataObject) -> Bool {
        return lhs.bytes == rhs.bytes
    }
}

// MARK: - Hashable

extension DataObject: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(bytes)
    }
}
