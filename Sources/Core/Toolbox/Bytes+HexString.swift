//
//  Bytes+HexString.swift
//  Web3
//
//  Created by Koray Koska on 10.02.18.
//

import Foundation

fileprivate let hexMapping = Array("0123456789abcdef")

extension Array where Element == Byte {

    func hexString(prefix: Bool) -> String {
        var charArray: [String.Element] = [String.Element](repeating: "0", count: self.count * 2)

        for i in 0..<self.count {
            charArray[i * 2] = hexMapping[Int(self[i]) / 16]
            charArray[(i * 2) + 1] = hexMapping[Int(self[i]) % 16]
        }

        if prefix {
            return "0x\(String(charArray))"
        } else {
            return String(charArray)
        }
    }

    func quantityHexString(prefix: Bool) -> String {
        // Remove leading zero bytes
        let bytes = self.trimLeadingZeros()

        var hex = ""
        if bytes.count == 0 {
            hex = "0"
        } else {
            hex = bytes.hexString(prefix: false)

            // If there is one leading zero (4 bit) left, this one removes it
            if hex.starts(with: "0") {
                hex = String(hex[hex.index(hex.startIndex, offsetBy: 1)...])
            }
        }

        if prefix {
            return "0x\(hex)"
        } else {
            return hex
        }
    }
}
