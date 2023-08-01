//
//  EthereumBlockObject.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

/**
 * A block as returned by an Ethereum node.
 */
public struct EthereumBlockObject: Codable {

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
        public let object: EthereumTransactionObject?

        /// The transaction as an hash
        public let hash: EthereumData?

        /**
         * Initialize this Transaction as an object.
         *
         * - parameter object: The Transaction as an object.
         */
        public init(object: EthereumTransactionObject) {
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

            if let tx = try? container.decode(EthereumTransactionObject.self) {
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
            } else {
                // This will never happen, but to be consistent...
                try container.encodeNil()
            }
        }

        /// Encoding and Decoding errors specific to EthereumValue
        public enum Error: Swift.Error {

            /// The type set is not convertible to EthereumValue
            case unsupportedType
        }
    }
}

// MARK: - Equatable

extension EthereumBlockObject.Transaction: Equatable {

    public static func ==(_ lhs: EthereumBlockObject.Transaction, _ rhs: EthereumBlockObject.Transaction) -> Bool {
        return lhs.object == rhs.object && lhs.hash == rhs.hash
    }
}

extension EthereumBlockObject: Equatable {

    public static func ==(_ lhs: EthereumBlockObject, _ rhs: EthereumBlockObject) -> Bool {

        return lhs.number == rhs.number
            && lhs.hash == rhs.hash
            && lhs.parentHash == rhs.parentHash
            && lhs.nonce == rhs.nonce
            && lhs.sha3Uncles == rhs.sha3Uncles
            && lhs.logsBloom == rhs.logsBloom
            && lhs.transactionsRoot == rhs.transactionsRoot
            && lhs.stateRoot == rhs.stateRoot
            && lhs.receiptsRoot == rhs.receiptsRoot
            && lhs.miner == rhs.miner
            && lhs.difficulty == rhs.difficulty
            && lhs.totalDifficulty == rhs.totalDifficulty
            && lhs.extraData == rhs.extraData
            && lhs.size == rhs.size
            && lhs.gasLimit == rhs.gasLimit
            && lhs.gasUsed == rhs.gasUsed
            && lhs.timestamp == rhs.timestamp
            && lhs.transactions == rhs.transactions
            && lhs.uncles == rhs.uncles
    }
}

// MARK: - Hashable

extension EthereumBlockObject.Transaction: Hashable {

    public var hashValue: Int {
        return hashValues(hash) ^ (object?.hashValue ?? 0)
    }
}

extension EthereumBlockObject: Hashable {

    public var hashValue: Int {
        // As of now we don't include transactions and uncles into the hashValue. This should be sufficiently fast for
        // the average case, which is enough for now. (Normally there are no block objects which have exact same values
        // but different transactions and uncles unless they were requested to include only tx hashes/complete objects.
        // We should test those cases and change this function if it makes a huge difference)
        return hashValues(
            number, hash, parentHash, nonce, sha3Uncles, logsBloom, transactionsRoot, stateRoot, receiptsRoot, miner,
            difficulty, totalDifficulty, extraData, size, gasLimit, gasUsed, timestamp
        )
    }
}
