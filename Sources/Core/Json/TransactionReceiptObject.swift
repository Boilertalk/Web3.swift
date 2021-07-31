//
//  EthereumTransactionReceiptObject.swift
//  Web3
//
//  Created by Koray Koska on 31.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public struct TransactionReceiptObject: Codable {

    /// 32 Bytes - hash of the transaction.
    public let transactionHash: DataObject

    /// Integer of the transactions index position in the block.
    public let transactionIndex: Quantity

    /// 32 Bytes - hash of the block where this transaction was in.
    public let blockHash: DataObject

    /// Block number where this transaction was in.
    public let blockNumber: Quantity

    /// The total amount of gas used when this transaction was executed in the block.
    public let cumulativeGasUsed: Quantity

    /// The amount of gas used by this specific transaction alone.
    public let gasUsed: Quantity

    /// 20 Bytes - The contract address created, if the transaction was a contract creation, otherwise nil.
    public let contractAddress: DataObject?

    /// Array of log objects, which this transaction generated.
    public let logs: [LogObject]

    /// 256 Bytes - Bloom filter for light clients to quickly retrieve related logs.
    public let logsBloom: DataObject

    /// 32 bytes of post-transaction stateroot (pre Byzantium)
    public let root: DataObject?

    /// Either 1 (success) or 0 (failure)
    public let status: Quantity?
}

// MARK: - Equatable

extension TransactionReceiptObject: Equatable {

    public static func ==(_ lhs: TransactionReceiptObject, _ rhs: TransactionReceiptObject) -> Bool {
        return lhs.transactionHash == rhs.transactionHash
            && lhs.transactionIndex == rhs.transactionIndex
            && lhs.blockHash == rhs.blockHash
            && lhs.blockNumber == rhs.blockNumber
            && lhs.cumulativeGasUsed == rhs.cumulativeGasUsed
            && lhs.gasUsed == rhs.gasUsed
            && lhs.contractAddress == rhs.contractAddress
            && lhs.logs == rhs.logs
            && lhs.logsBloom == rhs.logsBloom
            && lhs.root == rhs.root
            && lhs.status == rhs.status
    }
}

// MARK: - Hashable

extension TransactionReceiptObject: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(transactionHash)
        hasher.combine(transactionIndex)
        hasher.combine(blockHash)
        hasher.combine(cumulativeGasUsed)
        hasher.combine(gasUsed)
        hasher.combine(contractAddress)
        hasher.combine(logsBloom)
        hasher.combine(root)
        hasher.combine(status)
    }
}
