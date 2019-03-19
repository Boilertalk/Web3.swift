//
//  JSONValue.swift
//  Web3
//
//  Created by Yehor Popovych on 3/19/19.
//

import Foundation

public enum JSONValue: Equatable {
    case null
    case bool(Bool)
    case number(Double)
    case string(String)
    case array(Array<JSONValue>)
    case object(Dictionary<String, JSONValue>)
}

extension JSONValue: Codable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .array(array):
            try container.encode(array)
        case let .object(object):
            try container.encode(object)
        case let .string(string):
            try container.encode(string)
        case let .number(number):
            try container.encode(number)
        case let .bool(bool):
            try container.encode(bool)
        case .null:
            try container.encodeNil()
        }
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let object = try? container.decode([String: JSONValue].self) {
            self = .object(object)
        } else if let array = try? container.decode([JSONValue].self) {
            self = .array(array)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let number = try? container.decode(Double.self) {
            self = .number(number)
        } else if container.decodeNil() {
            self = .null
        } else {
            throw DecodingError.dataCorrupted(
                .init(codingPath: decoder.codingPath, debugDescription: "Invalid JSON value.")
            )
        }
    }
}

extension JSONValue: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .string(let str):
            return str.debugDescription
        case .number(let num):
            return num.debugDescription
        case .bool(let bool):
            return bool.description
        case .null:
            return "null"
        default:
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted]
            return try! String(data: encoder.encode(self), encoding: .utf8)!
        }
    }
}

public extension JSONValue {
    /// Return the string value if this is a `.string`, otherwise `nil`
    public var string: String? {
        if case .string(let value) = self {
            return value
        }
        return nil
    }
    
    /// Return the double value if this is a `.number`, otherwise `nil`
    public var number: Double? {
        if case .number(let value) = self {
            return value
        }
        return nil
    }
    
    /// Return the bool value if this is a `.bool`, otherwise `nil`
    public var bool: Bool? {
        if case .bool(let value) = self {
            return value
        }
        return nil
    }
    
    /// Return the object value if this is an `.object`, otherwise `nil`
    public var object: Dictionary<String, JSONValue>? {
        if case .object(let value) = self {
            return value
        }
        return nil
    }
    
    /// Return the array value if this is an `.array`, otherwise `nil`
    public var array: Array<JSONValue>? {
        if case .array(let value) = self {
            return value
        }
        return nil
    }
    
    /// Return `true` if this is `.null`
    public var isNull: Bool {
        if case .null = self {
            return true
        }
        return false
    }
    
    /// If this is an `.array`, return item at index
    ///
    /// If this is not an `.array` or the index is out of bounds, returns `nil`.
    public subscript(index: Int) -> JSONValue? {
        if case .array(let arr) = self, arr.indices.contains(index) {
            return arr[index]
        }
        return nil
    }
    
    /// If this is an `.object`, return item at key
    public subscript(key: String) -> JSONValue? {
        if case .object(let dict) = self {
            return dict[key]
        }
        return nil
    }
}
