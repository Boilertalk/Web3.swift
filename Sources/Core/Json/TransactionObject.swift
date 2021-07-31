//
//  EthereumTransactionObject.swift
//  Alamofire
//
//  Created by Koray Koska on 30.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public struct TransactionObject: Codable {

    /// 32 Bytes - hash of the transaction.
    public let hash: DataObject

    /// The number of transactions made by the sender prior to this one.
    public let nonce: Quantity

    /// 32 Bytes - hash of the block where this transaction was in. null when its pending.
    public let blockHash: DataObject?

    /// Block number where this transaction was in. null when its pending.
    public let blockNumber: Quantity?

    /// Integer of the transactions index position in the block. nil when its pending.
    public let transactionIndex: Quantity?

    /// 20 Bytes - address of the sender.
    public let from: Address

    /// 20 Bytes - address of the receiver. nil when its a contract creation transaction.
    public let to: Address?

    /// Value transferred in Wei.
    public let value: Quantity

    /// Gas price provided by the sender in Wei.
    public let gasPrice: Quantity

    /// Gas provided by the sender.
    public let gas: Quantity

    /// The data send along with the transaction.
    public let input: DataObject
}

// MARK: - Equatable

extension TransactionObject: Equatable {

    public static func ==(_ lhs: TransactionObject, _ rhs: TransactionObject) -> Bool {
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

extension TransactionObject: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(hash)
        hasher.combine(nonce)
        hasher.combine(blockHash)
        hasher.combine(blockNumber)
        hasher.combine(transactionIndex)
        hasher.combine(from)
        hasher.combine(to)
        hasher.combine(value)
        hasher.combine(gasPrice)
        hasher.combine(gas)
        hasher.combine(input)
    }
}
