//
//  Values+GeneralHashable.swift
//  Web3
//
//  Created by Koray Koska on 27.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import CryptoSwift

func hashValues(_ values: [BytesRepresentable?]) -> Int {
    var raw = Bytes()

    for v in values {
        // Is throwing deterministic? If not this could cause issues...
        if let elems = try? v?.makeBytes(), let arr = elems {
            raw.append(contentsOf: arr)
        }
    }

    let hash = SHA3(variant: .keccak256).calculate(for: raw)

    return hash.biggestInt()
}

func hashValues(_ values: BytesRepresentable?...) -> Int {
    return hashValues(values)
}

private extension Array where Element == UInt8 {

    func biggestInt() -> Int {
        let size = MemoryLayout<Int>.size

        var int = 0

        for i in 0..<(size - 1) {
            if i >= self.count {
                break
            }
            int = int | (Int(self[i]) << (i * 8))
        }

        return int
    }
}
