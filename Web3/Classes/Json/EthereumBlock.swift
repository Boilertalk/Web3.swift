//
//  EthereumBlock.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation

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

    /// Array of uncle hashes.
    let uncles: [String]
}
