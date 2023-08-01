//
//  EthereumAddress.swift
//  Web3
//
//  Created by Koray Koska on 05.02.18.
//

import Foundation
import BigInt
import CryptoSwift

public struct EthereumAddress {

    public let rawAddress: BigUInt

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

        // Create address int
        guard let a = BigUInt(hex, radix: 16) else {
            throw Error.addressMalformed
        }
        rawAddress = a

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

    public enum Error: Swift.Error {

        case addressMalformed
        case checksumWrong
    }
}
