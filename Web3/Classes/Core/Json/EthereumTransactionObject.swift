//
//  EthereumTransactionObject.swift
//  Alamofire
//
//  Created by Koray Koska on 30.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
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

// MARK: - Equatable

extension EthereumTransactionObject: Equatable {

    public static func ==(_ lhs: EthereumTransactionObject, _ rhs: EthereumTransactionObject) -> Bool {
        return lhs.hash == rhs.hash
            && lhs.nonce == rhs.nonce
            && lhs.blockHash == rhs.blockHash
            && lhs.blockNumber == rhs.blockNumber
            && lhs.transactionIndex == rhs.transactionIndex
            && lhs.from == rhs.from
            && lhs.to == rhs.to
            && lhs.value == rhs.value
            && lhs.gasPrice == rhs.gasPrice
            && lhs.gas == rhs.gas
            && lhs.input == rhs.input
    }
}

// MARK: - Hashable

extension EthereumTransactionObject: Hashable {

    public var hashValue: Int {
        return hashValues(
            hash, nonce, blockHash, blockNumber, transactionIndex, from, to, value, gasPrice, gas, input
        )
    }
}
