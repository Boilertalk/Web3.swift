//
//  BytesExtensions.swift
//  Web3_Tests
//
//  Created by Koray Koska on 18.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

extension Array where Element == UInt8 {

    func trimLeadingZeros() -> [UInt8] {
        var oldBytes = self
        var bytes = [UInt8]()

        var leading = true
        for i in 0 ..< oldBytes.count {
            if leading && oldBytes[i] == 0x00 {
                continue
            }
            leading = false
            bytes.append(oldBytes[i])
        }

        return bytes
    }
}

extension Array where Element == UInt8 {

    func hexString(prefix: Bool) -> String {
        var str = prefix ? "0x" : ""

        for b in self {
            str += String(format: "%02x", b)
        }

        return str
    }

    func quantityHexString(prefix: Bool) -> String {
        var str = prefix ? "0x" : ""

        // Remove leading zero bytes
        var bytes = self.trimLeadingZeros()

        if bytes.count > 0 {
            // If there is one leading zero (4 bit) left, this one removes it
            str += String(bytes[0], radix: 16)

            for i in 1..<bytes.count {
                str += String(format: "%02x", bytes[i])
            }
        } else {
            str += "0"
        }

        return str
    }
}
