//
//  SolidityType+Codable.swift
//  Web3
//
//  Created by Josh Pyles on 6/3/18.
//

import Foundation

extension NSRegularExpression {
    
    static let arrayMatch = try! NSRegularExpression(pattern: "^\\w*(?=(\\[\\d*\\])+)", options: [])
    static let numberMatch = try! NSRegularExpression(pattern: "(u?int)(\\d+)?", options: [])
    static let bytesMatch = try! NSRegularExpression(pattern: "bytes(\\d+)", options: [])
    static let arrayTypeMatch = try! NSRegularExpression(pattern: "^(.+)(?:\\[(\\d*)\\]{1})$", options: [])
    
    func matches(_ string: String) -> Bool {
        // Must use length from NSString because length is different in String
        let nsString = NSString(string: string)
        let range = NSRange(location: 0, length: nsString.length)
        return numberOfMatches(in: string, options: [], range: range) > 0
    }
    
    func matches(in string: String) -> [String] {
        // Must use length from NSString because length is different in String
        let nsString = NSString(string: string)
        let range = NSRange(location: 0, length: nsString.length)
        let matches = self.matches(in: string, options: [], range: range)
        return matches.flatMap { match -> [String] in
            return (0..<match.numberOfRanges).map {
                let substring = nsString.substring(with: match.range(at: $0))
                return substring
            }
        }
    }
    
}

extension SolidityType: Codable {
    
    public enum Error: Swift.Error {
        case typeMalformed
    }
    
    /// Initializes a SolidityType from a string
    public init(_ string: String) throws {
        self = try SolidityType.typeFromString(string)
    }
    
    /// Initializes a SolidityType from a given string and optional sub types
    public init?(_ string: String, subTypes: [SolidityType]?) {
        switch (string, subTypes) {
        case ("tuple", let subTypes?):
            self = .tuple(subTypes)
        case ("tuple[]", let subTypes?):
            self = .array(type: .tuple(subTypes), length: nil)
        default:
            if let type = try? SolidityType(string) {
                self = type
            } else  {
                return nil
            }
        }
    }
    
    /// Determines the SolidityType from a given string, from the JSON representation
    static func typeFromString(_ string: String) throws -> SolidityType {
        switch string {
        case "string":
            return .string
        case "address":
            return .address
        case "bool":
            return .bool
        case "int":
            return .int256
        case "uint":
            return .uint256
        case "bytes":
            return .bytes(length: nil)
        default:
            return try parseTypeString(string)
        }
    }
    
    static func parseTypeString(_ string: String) throws -> SolidityType {
        if isArrayType(string) {
            return try arrayType(string)
        }
        if isNumberType(string), let numberType = numberType(string) {
            return numberType
        }
        if isBytesType(string), let bytesType = bytesType(string) {
            return bytesType
        }
        throw Error.typeMalformed
    }
    
    static func isArrayType(_ string: String) -> Bool {
        return NSRegularExpression.arrayMatch.matches(string)
    }
    
    static func arraySizeAndType(_ string: String) -> (String?, UInt?) {
        let capturedStrings = NSRegularExpression.arrayTypeMatch.matches(in: string)
        var strings = capturedStrings.dropFirst().makeIterator()
        let typeValue = strings.next()
        if let sizeValue = strings.next(), let intValue = UInt(sizeValue) {
            return (typeValue, intValue)
        }
        return (typeValue, nil)
    }
    
    static func arrayType(_ string: String) throws -> SolidityType {
        let (innerTypeString, arraySize) = arraySizeAndType(string)
        if let innerTypeString = innerTypeString {
            let innerType = try typeFromString(innerTypeString)
            return .array(type: innerType, length: arraySize)
        }
        throw Error.typeMalformed
    }
    
    static func isNumberType(_ string: String) -> Bool {
        return NSRegularExpression.numberMatch.matches(string)
    }
    
    static func numberType(_ string: String) -> SolidityType? {
        let capturedStrings = NSRegularExpression.numberMatch.matches(in: string)
        var strings = capturedStrings.dropFirst().makeIterator()
        switch (strings.next(), strings.next()) {
        case ("uint", let bits):
            if let bits = bits {
                if let intValue = UInt16(bits) {
                    return .type(.uint(bits: intValue))
                }
                return nil
            }
            return .uint256
        case ("int", let bits):
            if let bits = bits {
                if let intValue = UInt16(bits) {
                    return .type(.int(bits: intValue))
                }
                return nil
            }
            return .int256
        default:
            return nil
        }
    }
    
    static func isBytesType(_ string: String) -> Bool {
        return NSRegularExpression.bytesMatch.matches(string)
    }
    
    static func bytesType(_ string: String) -> SolidityType? {
        let sizeMatches = NSRegularExpression.bytesMatch.matches(in: string).dropFirst()
        if let sizeString = sizeMatches.first, let size = UInt(sizeString) {
            return .bytes(length: size)
        }
        // no size
        return .bytes(length: nil)
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let stringValue = try container.decode(String.self)
        try self.init(stringValue)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(stringValue)
    }
    
}
