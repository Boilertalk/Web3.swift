//
//  RLPEncoder.swift
//  Web3
//
//  Created by Koray Koska on 31.01.18.
//

import Foundation
import VaporBytes

open class RLPEncoder {

    public init() {
    }

    open func encode(_ value: RLPItem) throws -> Bytes {
        switch value.valueType {
        case .array(let elements):
            break
        case .bytes(let bytes):
            var bytes = bytes
            if bytes.count == 1 && bytes[0] >= 0x00 && bytes[0] <= 0x7f {
                // For a single byte whose value is in the [0x00, 0x7f] range, that byte is its own RLP encoding.
                return bytes
            } else if bytes.count <= 55 {
                // bytes.count is less than or equal 55 so casting is safe
                let sign: Byte = 0x80 + UInt8(bytes.count)

                // Otherwise, if a string is 0-55 bytes long, the RLP encoding consists of a single byte
                // with value 0x80 plus the length of the string followed by the string.
                bytes.insert(sign, at: 0)
                return bytes
            } else {
                // If a string is more than 55 bytes long, the RLP encoding consists of a single byte
                // with value 0xb7 plus the length in bytes of the length of the string in binary form,
                // followed by the length of the string, followed by the string.
                let length = (try bytes.count.makeBytes()).trimLeadingZeros()

                let lengthCount = length.count
                guard lengthCount <= 0xbf - 0xb7 else {
                    // This only really happens if the byte count of the length of the bytes array is
                    // greater than or equal 0xbf - 0xb7. This is because 0xbf is the maximum allowed
                    // signature byte for this type if rlp encoding.
                    throw Error.singleBytesItemTooLong
                }

                let sign: Byte = 0xb7 + UInt8(lengthCount)

                for i in (0 ..< length.count).reversed() {
                    bytes.insert(length[i], at: 0)
                }

                bytes.insert(sign, at: 0)

                return bytes
            }
        }

        // TODO: Remove
        return Bytes()
    }

    // MARK: - Errors

    enum Error: Swift.Error {

        case singleBytesItemTooLong
    }
}
