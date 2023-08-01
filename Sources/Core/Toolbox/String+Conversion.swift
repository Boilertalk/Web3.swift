//
//  String+Conversion.swift
//  Web3
//
//  Created by Josh Pyles on 5/31/18.
//

import Foundation

public extension String {
    
    /// Converts a binary string to a hex string
    ///
    /// - Returns: String in hex format
    func binaryToHex() -> String {
        var binaryString = self
        if binaryString.count % 8 > 0 {
            binaryString = "0" + binaryString
        }
        let bytesCount = binaryString.count / 8
        return (0..<bytesCount).compactMap({ i in
            let offset = i * 8
            if let str = binaryString.substr(offset, 8), let int = UInt8(str, radix: 2) {
                return String(format: "%02x", int)
            }
            return nil
        }).joined()
    }
    
    /// Converts a hex string to a binary string
    ///
    /// - Returns: String in binary format
    func hexToBinary() -> String {
        return self.hexToBytes().map({ byte in
            return String(byte, radix: 2).paddingLeft(toLength: 8, withPad: "0")
        }).joined()
    }
    
    /// Converts a hex string into an array of bytes
    ///
    /// - Returns: Array of 8 bit bytes
    func hexToBytes() -> [UInt8] {
        var value = self
        if self.count % 2 > 0 {
            value = "0" + value
        }
        let bytesCount = value.count / 2
        return (0..<bytesCount).compactMap({ i in
            let offset = i * 2
            if let str = value.substr(offset, 2) {
                return UInt8(str, radix: 16)
            }
            return nil
        })
    }
    
    /// Conveniently create a substring to more easily match JavaScript APIs
    ///
    /// - Parameters:
    ///   - offset: Starting index fo substring
    ///   - length: Length of desired substring
    /// - Returns: String representing the substring if passed indexes are in bounds
    func substr(_ offset: Int,  _ length: Int) -> String? {
        guard offset + length <= self.count else { return nil }
        let start = index(startIndex, offsetBy: offset)
        let end = index(start, offsetBy: length)
        return String(self[start..<end])
    }
    
    /// Add padding to the left end of string
    ///
    /// - Parameters:
    ///   - length: Desired length of string
    ///   - character: Character to pad with
    /// - Returns: String of requested length, padded on left if necessary
    func paddingLeft(toLength length: Int, withPad character: Character) -> String {
        if self.count < length {
            return String(repeatElement(character, count: length - self.count)) + self
        } else {
            return String(self.prefix(length))
        }
    }
    
    /// Add padding to the left end of a string
    ///
    /// - Parameters:
    ///   - base: Desired multiple of String's length
    ///   - character: Character to pad with
    /// - Returns: String padded on left to nearest multiple of passed base
    func paddingLeft(toMultipleOf base: Int, withPad character: Character) -> String {
        // round up to the nearest multiple of base
        let newLength = Int(ceil(Double(count) / Double(base))) * base
        return self.paddingLeft(toLength: newLength, withPad: character)
    }
    
    /// Add padding to the right end of a string
    ///
    /// - Parameters:
    ///   - base: Desired multiple of String's length
    ///   - character: Character to pad with
    /// - Returns: String padded to nearest multiple of passed base
    func padding(toMultipleOf base: Int, withPad character: Character) -> String {
        // round up to the nearest multiple of base
        let newLength = Int(ceil(Double(count) / Double(base))) * base
        return self.padding(toLength: newLength, withPad: String(character), startingAt: 0)
    }
}
