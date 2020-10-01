//
//  String+BytesConvertible.swift
//  Web3
//
//  Created by Koray Koska on 06.04.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

extension String: BytesConvertible {

    /**
     * UTF8 Byte Array representation of self
     */
    public func makeBytes() -> Bytes {
        return Bytes(utf8)
    }

    /**
     * Initializes a string with the given UTF8 represented byte array
     */
    public init(_ bytes: Bytes) {
        self = bytes.makeString()
    }
}


extension Sequence where Iterator.Element == Byte {

    /**
     * Converts the bytes (self) to a utf8 string.
     */
    public func makeString() -> String {
        let array = Array(self) + [0]

        return array.withUnsafeBytes { rawBuffer in
            guard let pointer = rawBuffer.baseAddress?.assumingMemoryBound(to: CChar.self) else { return nil }
            return String(validatingUTF8: pointer)
        } ?? ""
    }
}
