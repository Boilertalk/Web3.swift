//
//  EthereumTransactionObject.swift
//  Alamofire
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation

public struct EthereumTransactionObject: Codable {

    /// 32 Bytes - hash of the transaction.
    public let hash: EthereumData

    /// The number of transactions made by the sender prior to this one.
    public let nonce: EthereumQuantity

    /// 32 Bytes - hash of the block where this transaction was in. null when its pending.
    public let blockHash: EthereumData?

    /// Block number where this transaction was in. null when its pending.
    public let blockNumber: EthereumQuantity?

    /// Integer of the transactions index position in the block. nil when its pending.
    public let transactionIndex: EthereumQuantity?

    /// 20 Bytes - address of the sender.
    public let from: EthereumAddress

    /// 20 Bytes - address of the receiver. nil when its a contract creation transaction.
    public let to: EthereumAddress?

    /// Value transferred in Wei.
    public let value: EthereumQuantity

    /// Gas price provided by the sender in Wei.
    public let gasPrice: EthereumQuantity

    /// Gas provided by the sender.
    public let gas: EthereumQuantity

    /// The data send along with the transaction.
    public let input: EthereumData
}
