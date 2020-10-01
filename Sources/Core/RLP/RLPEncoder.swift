//
//  RLPEncoder.swift
//  Web3
//
//  Created by Koray Koska on 31.01.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

/**
 * The default RLP Encoder which takes `RLPItem`'s and rlp encodes them as documented on Github:
 *
 * https://github.com/ethereum/wiki/wiki/RLP
 */
open class RLPEncoder {

    // MARK: - Initialization

    /**
     * Initializes a new instance of `RLPEncoder`. Currently there are no options you can pass
     * to the initializer. This may change in future releases.
     */
    public init() {
    }

    // MARK: - Encoding

    /**
     * Encodes the given `RLPItem` and returns a byte array which is the rlp encoded
     * representation of it.
     *
     * - parameter value: The RLPItem to encode.
     *
     * - returns: The rlp encoded `value` as a byte array.
     */
    open func encode(_ value: RLPItem) throws -> Bytes {
        switch value.valueType {
        case .array(let elements):
            return try encodeArray(elements)
        case .bytes(let bytes):
            return try encodeBytes(bytes)
        }
    }

    // MARK: - Errors

    public enum Error: Swift.Error {

        case inputTooLong
    }

    // MARK: - Helper methods

    private func encodeArray(_ elements: [RLPItem]) throws -> Bytes {
        var bytes = Bytes()
        for item in elements {
            try bytes.append(contentsOf: encode(item))
        }
        let combinedCount = bytes.count

        if combinedCount <= 55 {
            let sign: Byte = 0xc0 + UInt8(combinedCount)

            // If the total payload of a list (i.e. the combined length of all its items being RLP encoded)
            // is 0-55 bytes long, the RLP encoding consists of a single byte with value 0xc0 plus
            // the length of the list followed by the concatenation of the RLP encodings of the items.
            bytes.insert(sign, at: 0)
            return bytes
        } else {
            // If the total payload of a list is more than 55 bytes long, the RLP encoding consists of
            // a single byte with value 0xf7 plus the length in bytes of the length of the payload
            // in binary form, followed by the length of the payload, followed by the concatenation of
            // the RLP encodings of the items.
            let length = UInt(bytes.count).makeBytes().trimLeadingZeros()

            let lengthCount = length.count
            guard lengthCount <= 0xff - 0xf7 else {
                throw Error.inputTooLong
            }

            let sign: Byte = 0xf7 + UInt8(lengthCount)

            for i in (0 ..< length.count).reversed() {
                bytes.insert(length[i], at: 0)
            }

            bytes.insert(sign, at: 0)

            return bytes
        }
    }

    private func encodeBytes(_ bytes: Bytes) throws -> Bytes {
        var bytes = bytes
        if bytes.count == 1 && bytes[0] >= 0x00 && bytes[0] <= 0x7f {
            // For a single byte whose value is in the [0x00, 0x7f] range, that byte is its own RLP encoding.
            return bytes
        } else if bytes.count <= 55 {
            // bytes.count is less than or equal 55 so casting is safe
            let sign: Byte = 0x80 + UInt8(bytes.count)

            // If a string is 0-55 bytes long, the RLP encoding consists of a single byte
            // with value 0x80 plus the length of the string followed by the string.
            bytes.insert(sign, at: 0)
            return bytes
        } else {
            // If a string is more than 55 bytes long, the RLP encoding consists of a single byte
            // with value 0xb7 plus the length in bytes of the length of the string in binary form,
            // followed by the length of the string, followed by the string.
            let length = UInt(bytes.count).makeBytes().trimLeadingZeros()

            let lengthCount = length.count
            guard lengthCount <= 0xbf - 0xb7 else {
                // This only really happens if the byte count of the length of the bytes array is
                // greater than or equal 0xbf - 0xb7. This is because 0xbf is the maximum allowed
                // signature byte for this type if rlp encoding.
                throw Error.inputTooLong
            }

            let sign: Byte = 0xb7 + UInt8(lengthCount)

            for i in (0 ..< length.count).reversed() {
                bytes.insert(length[i], at: 0)
            }

            bytes.insert(sign, at: 0)

            return bytes
        }
    }
}
