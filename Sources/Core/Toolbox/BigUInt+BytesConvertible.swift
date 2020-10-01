//
//  BigUInt+BytesConvertible.swift
//  Web3
//
//  Created by Koray Koska on 06.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import BigInt

extension BigUInt: BytesConvertible {

    public func makeBytes() -> Bytes {
        var bytes: [UInt8] = []
        for w in self.words {
            let wordBytes = w.makeBytes()
            for i in (0..<wordBytes.count).reversed() {
                bytes.insert(wordBytes[i], at: 0)
            }
        }
        return bytes
    }

    public init(_ bytes: Bytes) {
        var bytes = bytes

        var words: [Word] = []

        let wordSize = MemoryLayout<Word>.size
        let paddingNeeded = (wordSize - (bytes.count % wordSize)) % wordSize
        for _ in 0..<paddingNeeded {
            bytes.insert(0x00, at: 0)
        }

        for i in Swift.stride(from: 0, to: bytes.count, by: wordSize) {
            let word = BigUInt.Word(Array(bytes[i..<(i + wordSize)]))
            words.insert(word, at: 0)
        }

        self.init(words: words)
    }
}
