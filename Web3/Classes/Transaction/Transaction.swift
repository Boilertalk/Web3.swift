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

    public let nonce: Int

    public let gasPrice: Int

    public let gasLimit: Int

    public let to: EthereumAddress

    public let value: BigUInt

    public let data: Bytes

    // public let v
}
