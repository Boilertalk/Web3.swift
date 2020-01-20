//
//  Bytes+TrimLeadingZeros.swift
//  Web3
//
//  Created by Koray Koska on 02.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

extension Array where Element == Byte {

    func trimLeadingZeros() -> Bytes {
        let oldBytes = self
        var bytes = Bytes()

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
