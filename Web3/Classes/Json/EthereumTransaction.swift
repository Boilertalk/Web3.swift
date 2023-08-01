//
//  EthereumTransaction.swift
//  Alamofire
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation

public struct EthereumTransaction: Codable {

    /// 32 Bytes - hash of the transaction.
    public let hash: String

    /// The number of transactions made by the sender prior to this one.
    public let nonce: String

    /// 32 Bytes - hash of the block where this transaction was in. null when its pending.
    public let blockHash: String

    /// Block number where this transaction was in. null when its pending.
    public let blockNumber: String

    /// Integer of the transactions index position in the block. nil when its pending.
    public let transactionIndex: String?

    /// 20 Bytes - address of the sender.
    public let from: String

    /// 20 Bytes - address of the receiver. nil when its a contract creation transaction.
    public let to: String?

    /// Value transferred in Wei.
    public let value: String

    /// Gas price provided by the sender in Wei.
    public let gasPrice: String

    /// Gas provided by the sender.
    public let gas: String

    /// The data send along with the transaction.
    public let input: String
}
