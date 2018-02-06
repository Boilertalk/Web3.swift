//
//  EthereumAddress.swift
//  Web3
//
//  Created by Koray Koska on 05.02.18.
//

import Foundation
import CryptoSwift
import VaporBytes

public struct EthereumAddress {

    public let rawAddress: Bytes

    public init(hex: String, eip55: Bool) throws {
        // Check length
        guard hex.count == 40 || hex.count == 42 else {
            throw Error.addressMalformed
        }

        var hex = hex

        // Check prefix
        if hex.count == 42 {
            let s = hex.index(hex.startIndex, offsetBy: 0)
            let e = hex.index(hex.startIndex, offsetBy: 2)

            guard String(hex[s..<e]) == "0x" else {
                throw Error.addressMalformed
            }

            // Remove prefix
            let hexStart = hex.index(hex.startIndex, offsetBy: 2)
            hex = String(hex[hexStart...])
        }

        // Check hex
        guard hex.rangeOfCharacter(from: CharacterSet.hexadecimals.inverted) == nil else {
            throw Error.addressMalformed
        }

        // Create address bytes
        var addressBytes = Bytes()
        for i in stride(from: 0, to: hex.count, by: 2) {
            let s = hex.index(hex.startIndex, offsetBy: i)
            let e = hex.index(hex.startIndex, offsetBy: i + 2)

            guard let b = Byte(String(hex[s..<e]), radix: 16) else {
                throw Error.addressMalformed
            }
            addressBytes.append(b)
        }
        self.rawAddress = addressBytes

        // EIP 55 checksum
        // See: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-55.md
        if eip55 {
            let hash = SHA3(variant: .keccak256).calculate(for: Array(hex.lowercased().utf8))

            for i in 0..<hex.count {
                let charString = String(hex[hex.index(hex.startIndex, offsetBy: i)])
                if charString.rangeOfCharacter(from: CharacterSet.hexadecimalNumbers) != nil {
                    continue
                }

                let bytePos = (4 * i) / 8
                let bitPos = (4 * i) % 8
                guard bytePos < hash.count && bitPos < 8 else {
                    throw Error.addressMalformed
                }
                let bit = (hash[bytePos] >> (7 - UInt8(bitPos))) & 0x01

                if charString.lowercased() == charString && bit == 1 {
                    throw Error.checksumWrong
                } else if charString.uppercased() == charString && bit == 0 {
                    throw Error.checksumWrong
                }
            }
        }
    }

    public func stringAddress(eip55: Bool) -> String {
        var hex = "0x"
        if !eip55 {
            for b in rawAddress {
                hex += String(format: "%02x", b)
            }
        } else {
            var address = ""
            for b in rawAddress {
                address += String(format: "%02x", b)
            }
            let hash = SHA3(variant: .keccak256).calculate(for: Array(address.utf8))

            for i in 0..<address.count {
                let charString = String(address[address.index(address.startIndex, offsetBy: i)])

                if charString.rangeOfCharacter(from: CharacterSet.hexadecimalNumbers) != nil {
                    hex += charString
                    continue
                }

                let bytePos = (4 * i) / 8
                let bitPos = (4 * i) % 8
                let bit = (hash[bytePos] >> (7 - UInt8(bitPos))) & 0x01

                if bit == 1 {
                    hex += charString.uppercased()
                } else {
                    hex += charString.lowercased()
                }
            }
        }

        return hex
    }

    public enum Error: Swift.Error {

        case addressMalformed
        case checksumWrong
    }
}
