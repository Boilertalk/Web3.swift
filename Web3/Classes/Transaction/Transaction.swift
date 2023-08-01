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

    /**
     * Initializes a new instance of `Transaction` with the given values.
     *
     * - parameter nonce: The nonce of this transaction.
     * - parameter gasPrice: The gas price for this transaction.
     * - parameter gasLimit: The gas limit for this transaction.
     * - parameter to: The address of the receiver.
     * - parameter value: The value to be sent by this transaction.
     * - parameter data: Input data for this transaction. Defaults to [].
     * - parameter v: EC signature parameter v. Defaults to 0.
     * - parameter r: EC signature parameter r. Defaults to 0.
     * - parameter s: EC recovery ID. Defaults to 0.
     * - parameter chainId: The chainId as described in EIP155. Mainnent: 1
     */
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
