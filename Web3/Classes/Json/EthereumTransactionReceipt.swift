//
//  EthereumTransactionReceipt.swift
//  Web3
//
//  Created by Koray Koska on 31.12.17.
//

import Foundation

public struct EthereumTransactionReceipt: Codable {

    /// 32 Bytes - hash of the transaction.
    public let transactionHash: String

    /// Integer of the transactions index position in the block.
    public let transactionIndex: String

    /// 32 Bytes - hash of the block where this transaction was in.
    public let blockHash: String

    /// Block number where this transaction was in.
    public let blockNumber: String

    /// The total amount of gas used when this transaction was executed in the block.
    public let cumulativeGasUsed: String

    /// The amount of gas used by this specific transaction alone.
    public let gasUsed: String

    /// 20 Bytes - The contract address created, if the transaction was a contract creation, otherwise nil.
    public let contractAddress: String?

    /// Array of log objects, which this transaction generated.
    public let logs: [EthereumLog]

    /// 256 Bytes - Bloom filter for light clients to quickly retrieve related logs.
    public let logsBloom: String

    /// 32 bytes of post-transaction stateroot (pre Byzantium)
    public let root: String?

    /// Either 1 (success) or 0 (failure)
    public let status: String?
}
