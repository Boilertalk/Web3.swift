//
//  ABIRepresentable.swift
//  AppAuth
//
//  Created by Josh Pyles on 5/22/18.
//

import Foundation
import BigInt
#if !Web3CocoaPods
    import Web3
#endif

/// A type that is always represented as a single SolidityType
public protocol SolidityTypeRepresentable {
    static var solidityType: SolidityType { get }
}

/// A type that can be converted to and from Solidity ABI bytes
public protocol ABIConvertible: ABIEncodable & ABIDecodable {}

/// A type that can be converted to a Solidity value
public protocol ABIEncodable {
    /// Encode to hex string
    ///
    /// - Parameter dynamic: Hopefully temporary workaround until dynamic conditional conformance works
    /// - Returns: Solidity ABI encoded hex string
    func abiEncode(dynamic: Bool) -> String?
}

/// A type that can be initialized from a Solidity value
public protocol ABIDecodable {
    /// Initialize with a hex string from Solidity
    ///
    /// - Parameter hexString: Solidity ABI encoded hex string containing this type
    init?(hexString: String)
}

// MARK: - Encoding

extension FixedWidthInteger where Self: UnsignedInteger {
    
    public init?(hexString: String) {
        self.init(hexString, radix: 16)
    }
    
    public func abiEncode(dynamic: Bool) -> String? {
        return String(self, radix: 16).paddingLeft(toLength: 64, withPad: "0")
    }
    
    public static var solidityType: SolidityType {
        return SolidityType.type(.uint(bits: UInt16(bitWidth)))
    }
}

extension FixedWidthInteger where Self: SignedInteger {
    
    public init?(hexString: String) {
        // convert to binary
        var binaryString = hexString.hexToBinary()
        // trim left padding to right amount of bits (abi segments are always padded to 256 bit)
        if binaryString.count > Self.bitWidth {
            binaryString = String(binaryString.dropFirst(binaryString.count - Self.bitWidth))
        }
        // initialize with twos complement binary value
        self.init(twosComplementString: binaryString)
    }
    
    /// Convert twos-complement binary String to Int value ('00000001' = 1, '11111111' = -1)
    public init?(twosComplementString binaryString: String) {
        let signBit = binaryString.substr(0, 1)
        let valueBits = binaryString.dropFirst()
        // determine if positive (0) or negative (1)
        switch signBit {
        case "0":
            // Positive number
            self.init(valueBits, radix: 2)
        default:
            // Ignore sign bit
            if let twosRepresentation = Self(valueBits, radix: 2) {
                self = twosRepresentation + Self.min
            } else {
                return nil
            }
        }
    }
    
    /// Get positive value that would represent this number in twos-complement encoded binary
    public var twosComplementRepresentation: Self {
        if self < 0 {
            return abs(Self.min - self)
        }
        return self
    }
    
    public func abiEncode(dynamic: Bool) -> String? {
        // for negative signed integers
        if self < 0 {
            // get twos representation
            let twosSelf = twosComplementRepresentation
            // encode value bits
            let binaryString = String(twosSelf, radix: 2)
            // add sign bit
            let paddedBinaryString = "1" + binaryString
            // encode to hex
            let hexValue = paddedBinaryString.binaryToHex()
            // pad with 'f' for negative numbers
            return hexValue.paddingLeft(toLength: 64, withPad: "f")
        }
        // can encode to hex directly if positive
        return String(self, radix: 16).paddingLeft(toLength: 64, withPad: "0")
    }
    
    public static var solidityType: SolidityType {
        return SolidityType.type(.int(bits: UInt16(bitWidth)))
    }
}

extension BigInt: ABIConvertible {
    
    public init?(hexString: String) {
        let binaryString = hexString.hexToBinary()
        self.init(twosComplementString: binaryString)
    }
    
    public init?(twosComplementString binaryString: String) {
        let signBit = binaryString.substr(0, 1)
        let valueBits = binaryString.dropFirst()
        switch signBit {
        case "0":
            // Positive number
            self.init(valueBits, radix: 2)
        default:
            // Negative number
            guard let twosRepresentation = BigInt(valueBits, radix: 2) else { return nil }
            let max = BigInt(2).power(255)
            self = twosRepresentation - max
        }
    }
    
    public func abiEncode(dynamic: Bool) -> String? {
        if self < 0 {
            // BigInt doesn't have a 'max' or 'min', assume 256-bit.
            let twosSelf = (BigInt(2).power(255)) - abs(self)
            let binaryString = String(twosSelf, radix: 2)
            let paddedBinaryString = "1" + binaryString
            let hexValue = paddedBinaryString.binaryToHex()
            return hexValue.paddingLeft(toLength: 64, withPad: "f")
        }
        return String(self, radix: 16).paddingLeft(toLength: 64, withPad: "0")
    }
}

extension BigInt: SolidityTypeRepresentable {
    public static var solidityType: SolidityType {
        return .int256
    }
}

extension BigUInt: ABIConvertible {
    
    public init?(hexString: String) {
        self.init(hexString, radix: 16)
    }
    
    public func abiEncode(dynamic: Bool) -> String? {
        return String(self, radix: 16).paddingLeft(toLength: 64, withPad: "0")
    }
}

extension BigUInt: SolidityTypeRepresentable {
    public static var solidityType: SolidityType {
        return .uint256
    }
}

// Boolean

extension Bool: ABIConvertible {
    
    public init?(hexString: String) {
        if let numberValue = UInt(hexString, radix: 16) {
            self = (numberValue == 1)
        } else {
            return nil
        }
    }
    
    public func abiEncode(dynamic: Bool) -> String? {
        if self {
            return "1".paddingLeft(toLength: 64, withPad: "0")
        }
        return "0".paddingLeft(toLength: 64, withPad: "0")
    }
}

extension Bool: SolidityTypeRepresentable {
    public static var solidityType: SolidityType {
        return .bool
    }
}

// String

extension String: ABIConvertible {
    
    public init?(hexString: String) {
        if let data = Data(hexString: hexString) {
            self.init(data: data, encoding: .utf8)
        } else {
            return nil
        }
    }
    
    public func abiEncode(dynamic: Bool) -> String? {
        // UTF-8 encoded bytes, padded right to multiple of 32 bytes
        return Data(self.utf8).abiEncodeDynamic()
    }
}

extension String: SolidityTypeRepresentable {
    public static var solidityType: SolidityType {
        return .string
    }
}

// Array

extension Array: ABIEncodable where Element: ABIEncodable {
    
    public func abiEncode(dynamic: Bool) -> String? {
        if dynamic {
            return abiEncodeDynamic()
        }
        // values encoded, joined with no separator
        return self.compactMap { $0.abiEncode(dynamic: false) }.joined()
    }
    
    public func abiEncodeDynamic() -> String? {
        // get values
        let values = self.compactMap { value -> String? in
            return value.abiEncode(dynamic: true)
        }
        // number of elements in the array, padded left
        let length = String(values.count, radix: 16).paddingLeft(toLength: 64, withPad: "0")
        // values, joined with no separator
        return length + values.joined()
    }
}

extension Array: ABIDecodable where Element: ABIDecodable {
    
    public init?(hexString: String) {
        let lengthString = hexString.substr(0, 64)
        let valueString = String(hexString.dropFirst(64))
        guard let string = lengthString, let length = Int(string, radix: 16), length > 0 else { return nil }
        self.init(hexString: valueString, length: length)
    }
    
    public init?(hexString: String, length: Int) {
        let itemLength = hexString.count / length
        let values = (0..<length).compactMap { i -> Element? in
            if let elementString = hexString.substr(i * itemLength, itemLength) {
                return Element.init(hexString: elementString)
            }
            return nil
        }
        if values.count == length {
            self = values
        } else {
            return nil
        }
    }
    
}

extension Array: ABIConvertible where Element: ABIConvertible {}

// Bytes

extension Data: ABIConvertible {
    
    public init?(hexString: String) {
        //split segments
        let lengthString = hexString.substr(0, 64)
        let valueString = String(hexString.dropFirst(64))
        //calculate length
        guard let string = lengthString, let length = Int(string, radix: 16), length > 0 else { return nil }
        //convert to bytes
        let bytes = valueString.hexToBytes()
        //trim bytes to length
        let trimmedBytes = bytes.prefix(length)
        self.init(trimmedBytes)
    }
    
    public init?(hexString: String, length: UInt) {
        //convert to bytes
        let bytes = hexString.hexToBytes()
        //trim bytes to length
        let trimmedBytes = bytes.prefix(Int(length))
        self.init(trimmedBytes)
    }
    
    public func abiEncode(dynamic: Bool) -> String? {
        if dynamic {
            return abiEncodeDynamic()
        }
        // each byte, padded right
        return map { String(format: "%02x", $0) }.joined().padding(toMultipleOf: 64, withPad: "0")
    }
    
    public func abiEncodeDynamic() -> String? {
        // number of bytes
        let length = String(self.count, radix: 16).paddingLeft(toLength: 64, withPad: "0")
        // each bytes, padded right
        let value = map { String(format: "%02x", $0) }.joined().padding(toMultipleOf: 64, withPad: "0")
        return length + value
    }
}

// Address

extension EthereumAddress: ABIConvertible {
    
    public init?(hexString: String) {
        // trim whitespace to 160 bytes
        let trimmedString = String(hexString.dropFirst(hexString.count - 40))
        // initialize address
        if let address = try? EthereumAddress(hex: trimmedString, eip55: false) {
            self = address
        } else {
            return nil
        }
    }
    
    public func abiEncode(dynamic: Bool) -> String? {
        let hexString = hex(eip55: false).replacingOccurrences(of: "0x", with: "")
        return hexString.paddingLeft(toLength: 64, withPad: "0")
    }
}

extension EthereumAddress: SolidityTypeRepresentable {
    public static var solidityType: SolidityType {
        return .address
    }
}


// MARK: - Explicit protocol conformance

extension Int: ABIConvertible, SolidityTypeRepresentable {}
extension Int8: ABIConvertible, SolidityTypeRepresentable {}
extension Int16: ABIConvertible, SolidityTypeRepresentable {}
extension Int32: ABIConvertible, SolidityTypeRepresentable {}
extension Int64: ABIConvertible, SolidityTypeRepresentable {}

extension UInt: ABIConvertible, SolidityTypeRepresentable {}
extension UInt8: ABIConvertible, SolidityTypeRepresentable {}
extension UInt16: ABIConvertible, SolidityTypeRepresentable {}
extension UInt32: ABIConvertible, SolidityTypeRepresentable {}
extension UInt64: ABIConvertible, SolidityTypeRepresentable {}
