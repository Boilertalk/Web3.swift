//
//  Transaction.swift
//  Web3
//
//  Created by Koray Koska on 05.02.18.
//

import Foundation
import BigInt
import VaporBytes

public struct Transaction {

    /// The number of transactions made prior to this one
    public let nonce: UInt

    /// Gas price provided Wei
    public let gasPrice: UInt

    /// Gas limit provided
    public let gasLimit: UInt

    /// Address of the receiver
    public let to: EthereumAddress

    /// Value to transfer provided in Wei
    public let value: BigUInt

    /// Input data for this transaction
    public let data: Bytes

    /// EC signature parameter v
    public let v: BigUInt

    /// EC signature parameter r
    public let r: BigUInt

    /// EC recovery ID
    public let s: BigUInt

    /// EIP 155 chainId. Mainnet: 1
    public let chainId: UInt

    public init(
        nonce: UInt,
        gasPrice: UInt,
        gasLimit: UInt,
        to: EthereumAddress,
        value: BigUInt,
        data: Bytes = [],
        v: BigUInt = 0,
        r: BigUInt = 0,
        s: BigUInt = 0,
        chainId: UInt
    ) {
        var v = v
        if v == 0 {
            v = BigUInt(integerLiteral: UInt64(chainId))
        }

        self.nonce = nonce
        self.gasPrice = gasPrice
        self.gasLimit = gasLimit
        self.to = to
        self.value = value
        self.data = data
        self.v = v
        self.r = r
        self.s = s
        self.chainId = chainId
    }
}
