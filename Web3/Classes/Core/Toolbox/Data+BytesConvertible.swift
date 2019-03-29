//
//  Data+BytesConvertible.swift
//  Web3
//
//  Created by Koray Koska on 06.04.18.
//

import Foundation

extension Data: BytesConvertible {

    /**
     * Returns self represented as a byte array.
     *
     * - returns: The newly created byte array.
     *
     */
    public func makeBytes() -> Bytes {
        var array = Bytes(repeating: 0, count: count)
        let buffer = UnsafeMutableBufferPointer(start: &array, count: count)
        _ = copyBytes(to: buffer)
        return array
    }
}
