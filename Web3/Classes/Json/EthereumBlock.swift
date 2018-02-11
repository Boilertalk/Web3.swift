//
//  EthereumBlock.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation

/**
 * A block as returned by an Ethereum node.
 */
public struct EthereumBlock: Codable {

    /// The block number. nil when its a pending block.
    public let number: EthereumQuantity?

    /// 32 Bytes - hash of the block. nil when its a pending block.
    public let hash: EthereumData?

    /// 32 Bytes - hash of the parent block.
    public let parentHash: EthereumData

    /// 8 Bytes - hash of the generated proof-of-work. nil when its a pending block.
    public let nonce: EthereumData?

    /// 32 Bytes - SHA3 of the uncles data in the block.
    public let sha3Uncles: EthereumData

    /// 256 Bytes - the bloom filter for the logs of the block. null when its a pending block.
    public let logsBloom: EthereumData?

    /// 32 Bytes - the root of the transaction trie of the block.
    public let transactionsRoot: EthereumData

    /// 32 Bytes - the root of the final state trie of the block.
    public let stateRoot: EthereumData

    /// 32 Bytes - the root of the receipts trie of the block.
    public let receiptsRoot: EthereumData

    /// 20 Bytes - the address of the beneficiary to whom the mining rewards were given.
    public let miner: EthereumAddress

    /// Integer of the difficulty for this block.
    public let difficulty: EthereumQuantity

    /// Integer of the total difficulty of the chain until this block.
    public let totalDifficulty: EthereumQuantity

    /// The "extra data" field of this block.
    public let extraData: EthereumData

    /// Integer the size of this block in bytes.
    public let size: EthereumQuantity

    /// The maximum gas allowed in this block.
    public let gasLimit: EthereumQuantity

    /// The total used gas by all transactions in this block.
    public let gasUsed: EthereumQuantity

    /// The unix timestamp for when the block was collated.
    public let timestamp: EthereumQuantity

    /// Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter.
    public let transactions: [Transaction]

    /// Array of uncle hashes.
    public let uncles: [EthereumData]

    /**
     * Represents a transaction as either a hash or an object.
     */
    public struct Transaction: Codable {

        /// The transaction as an object
        public let object: EthereumTransaction?

        /// The transaction as an hash
        public let hash: EthereumData?

        /**
         * Initialize this Transaction as an object.
         *
         * - parameter object: The Transaction as an object.
         */
        public init(object: EthereumTransaction) {
            self.object = object
            self.hash = nil
        }

        /**
         * Initialize this Transaction as an hash.
         *
         * - parameter hash: The transaction hash.
         */
        public init(hash: EthereumData) {
            self.hash = hash
            self.object = nil
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let tx = try? container.decode(EthereumTransaction.self) {
                self.init(object: tx)
            } else if let tx = try? container.decode(EthereumData.self) {
                self.init(hash: tx)
            } else {
                throw Error.unsupportedType
            }
        }

        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()

            if let object = object {
                try container.encode(object)
            } else if let hash = hash {
                try container.encode(hash)
            }

            // This will never happen, but to be consistent...
            try container.encodeNil()
        }

        /// Encoding and Decoding errors specific to EthereumValue
        public enum Error: Swift.Error {

            /// The type set is not convertible to EthereumValue
            case unsupportedType
        }
    }
}
