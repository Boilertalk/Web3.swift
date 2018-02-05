//
//  RLPDecoder.swift
//  Web3
//
//  Created by Koray Koska on 03.02.18.
//

import Foundation
import VaporBytes

/**
 * The default RLP Decoder which takes rlp encoded `Bytes` and creates their representing `RLPItem`
 * as documented on Github:
 *
 * https://github.com/ethereum/wiki/wiki/RLP
 */
open class RLPDecoder {

    // MARK: - Initialization

    /**
     * Initializes a new instance of `RLPDecoder`. Currently there are no options you can pass
     * to the initializer. This may change in future releases.
     */
    public init() {
    }

    // MARK: - Decoding

    /**
     * Decodes the given rlp encoded `Byte` array and returns a new instance of `RLPItem`
     * representing the given rlp.
     *
     * - parameter rlp: The rlp encoded `Byte` array.
     *
     * - returns: A new instance of `RLPItem` which represents the given rlp encoded `Byte` array.
     */
    open func decode(_ rlp: Bytes) throws -> RLPItem {
        guard rlp.count > 0 else {
            throw Error.inputEmpty
        }
        let sign = rlp[0]

        if sign >= 0x00 && sign <= 0x7f {
            guard rlp.count == 1 else {
                throw Error.inputBad
            }
            return .bytes(sign)
        } else if sign >= 0x80 && sign <= 0xb7 {
            let count = sign - 0x80
            guard rlp.count == count + 1 else {
                throw Error.inputBad
            }
            let bytes = Array(rlp[1..<rlp.count])
            return .bytes(bytes)
        } else if sign >= 0xb8 && sign <= 0xbf {
            let byteCount = sign - 0xb7
            guard byteCount <= 8 else {
                throw Error.inputTooLong
            }

            let stringCount = try getCount(rlp: rlp)

            let rlpCount = stringCount + Int(byteCount) + 1
            guard rlp.count == rlpCount else {
                throw Error.inputBad
            }

            let bytes = Array(rlp[(Int(byteCount) + 1) ..< Int(rlpCount)])
            return .bytes(bytes)
        } else if sign >= 0xc0 && sign <= 0xf7 {
            let totalCount = sign - 0xc0
            guard rlp.count == totalCount + 1 else {
                throw Error.inputBad
            }
            if totalCount == 0 {
                return []
            }
            var items = [RLPItem]()

            var pointer = 1
            while pointer < rlp.count {
                let count = try getCount(rlp: Array(rlp[pointer...]))

                guard rlp.count >= (pointer + count + 1) else {
                    throw Error.inputBad
                }

                let itemRLP = Array(rlp[pointer..<(pointer + count + 1)])
                try items.append(decode(itemRLP))

                pointer += (count + 1)
            }

            return .array(items)
        } else if sign >= 0xf8 && sign <= 0xff {
            let byteCount = sign - 0xf7
            guard byteCount <= 8 else {
                throw Error.inputTooLong
            }

            let totalCount = try getCount(rlp: rlp)

            let rlpCount = totalCount + Int(byteCount) + 1
            guard rlp.count == rlpCount else {
                throw Error.inputBad
            }
            var items = [RLPItem]()

            // We start after the length defining bytes (and the first byte)
            var pointer = Int(byteCount) + 1
            while pointer < rlp.count {
                let count = try getCount(rlp: Array(rlp[pointer...]))

                guard rlp.count >= (pointer + count + 1) else {
                    throw Error.inputBad
                }

                let itemRLP = Array(rlp[pointer..<(pointer + count + 1)])
                try items.append(decode(itemRLP))

                pointer += (count + 1)
            }

            return .array(items)
        } else {
            throw Error.lengthPrefixBad
        }
    }

    // MARK: - Errors

    public enum Error: Swift.Error {

        case inputEmpty
        case inputBad
        case inputTooLong

        case lengthPrefixBad
    }

    // MARK: - Helper methods

    private func getCount(rlp: Bytes) throws -> Int {
        guard rlp.count > 0 else {
            throw Error.inputBad
        }
        let sign = rlp[0]
        let count: UInt
        if sign >= 0x00 && sign <= 0x7f {
            count = 1
        } else if sign >= 0x80 && sign <= 0xb7 {
            count = UInt(sign) - UInt(0x80)
        } else if sign >= 0xb8 && sign <= 0xbf {
            let byteCount = sign - 0xb7
            guard rlp.count >= (Int(byteCount) + 1) else {
                throw Error.inputBad
            }
            guard let c = Array(rlp[1..<(Int(byteCount) + 1)]).bigEndianUInt else {
                throw Error.inputTooLong
            }
            count = c
        } else if sign >= 0xc0 && sign <= 0xf7 {
            count = UInt(sign) - UInt(0xc0)
        } else if sign >= 0xf8 && sign <= 0xff {
            let byteCount = sign - 0xf7
            guard rlp.count >= (Int(byteCount) + 1) else {
                throw Error.inputBad
            }
            guard let c = Array(rlp[1..<(Int(byteCount) + 1)]).bigEndianUInt else {
                throw Error.inputTooLong
            }
            count = c
        } else {
            throw Error.lengthPrefixBad
        }

        guard count <= Int.max else {
            throw Error.inputTooLong
        }

        return Int(count)
    }
}
