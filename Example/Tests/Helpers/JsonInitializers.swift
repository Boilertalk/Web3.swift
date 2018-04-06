//
//  JsonInitializers.swift
//  Web3_Tests
//
//  Created by Koray Koska on 06.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import Web3

extension EthereumTransactionObject {

    init(
        hash: EthereumData,
        nonce: EthereumQuantity,
        blockHash: EthereumData?,
        blockNumber: EthereumQuantity?,
        transactionIndex: EthereumQuantity?,
        from: EthereumAddress,
        to: EthereumAddress?,
        value: EthereumQuantity,
        gasPrice: EthereumQuantity,
        gas: EthereumQuantity,
        input: EthereumData
        ) {
        self.hash = hash
        self.nonce = nonce
        self.blockHash = blockHash
        self.blockNumber = blockNumber
        self.transactionIndex = transactionIndex
        self.from = from
        self.to = to
        self.value = value
        self.gasPrice = gasPrice
        self.gas = gas
        self.input = input
    }
}
