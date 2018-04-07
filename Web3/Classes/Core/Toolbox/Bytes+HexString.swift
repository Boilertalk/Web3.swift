//
//  Bytes+HexString.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

extension Array where Element == Byte {

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
