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
    let number: String?

    /// 32 Bytes - hash of the block. nil when its a pending block.
    let hash: String?

    /// 32 Bytes - hash of the parent block.
    let parentHash: String

    /// 8 Bytes - hash of the generated proof-of-work. nil when its a pending block.
    let nonce: String?

    /// 32 Bytes - SHA3 of the uncles data in the block.
    let sha3Uncles: String

    /// 256 Bytes - the bloom filter for the logs of the block. null when its a pending block.
    let logsBloom: String?

    /// 32 Bytes - the root of the transaction trie of the block.
    let transactionsRoot: String

    /// 32 Bytes - the root of the final state trie of the block.
    let stateRoot: String

    /// 32 Bytes - the root of the receipts trie of the block.
    let receiptsRoot: String

    /// 20 Bytes - the address of the beneficiary to whom the mining rewards were given.
    let miner: String

    /// Integer of the difficulty for this block.
    let difficulty: String

    /// Integer of the total difficulty of the chain until this block.
    let totalDifficulty: String

    /// The "extra data" field of this block.
    let extraData: String

    /// Integer the size of this block in bytes.
    let size: String

    /// The maximum gas allowed in this block.
    let gasLimit: String

    /// The total used gas by all transactions in this block.
    let gasUsed: String

    /// The unix timestamp for when the block was collated.
    let timestamp: String

    /// Array of transaction objects, or 32 Bytes transaction hashes depending on the last given parameter.
    let transactions: [Transaction]

    /// Array of uncle hashes.
    let uncles: [String]

    /**
     * Represents a transaction as either a hash or an object.
     */
    public struct Transaction: Codable {

        /// The transaction as an object
        let object: EthereumTransaction?

        /// The transaction as an hash
        let hash: String?

        public init(object: EthereumTransaction) {
            self.object = object
            self.hash = nil
        }

        public init(hash: String) {
            self.hash = hash
            self.object = nil
        }

        public init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()

            if let tx = try? container.decode(EthereumTransaction.self) {
                self.init(object: tx)
            } else if let tx = try? container.decode(String.self) {
                self.init(hash: tx)
            }

            throw Error.unsupportedType
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
