//
//  EthereumTransaction.swift
//  Web3
//
//  Created by Koray Koska on 05.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import BigInt

public struct EthereumTransaction {

    // MARK: - Properties

    /// The number of transactions made prior to this one
    public let nonce: EthereumQuantity

    /// Gas price provided Wei
    public let gasPrice: EthereumQuantity

    /// Gas limit provided
    public let gasLimit: EthereumQuantity

    /// Address of the receiver
    public let to: EthereumAddress

    /// Value to transfer provided in Wei
    public let value: EthereumQuantity

    /// Input data for this transaction
    public let data: EthereumData

    /// EC signature parameter v
    public let v: EthereumQuantity

    /// EC signature parameter r
    public let r: EthereumQuantity

    /// EC recovery ID
    public let s: EthereumQuantity

    /// EIP 155 chainId. Mainnet: 1
    public let chainId: EthereumQuantity

    // MARK: - Initialization

    /**
     * Initializes a new instance of `EthereumTransaction` with the given values.
     *
     * - parameter nonce: The nonce of this transaction.
     * - parameter gasPrice: The gas price for this transaction in wei.
     * - parameter gasLimit: The gas limit for this transaction.
     * - parameter to: The address of the receiver.
     * - parameter value: The value to be sent by this transaction in wei.
     * - parameter data: Input data for this transaction. Defaults to [].
     * - parameter v: EC signature parameter v. Defaults to 0.
     * - parameter r: EC signature parameter r. Defaults to 0.
     * - parameter s: EC recovery ID. Defaults to 0.
     * - parameter chainId: The chainId as described in EIP155. Mainnent: 1.
     *                      If set to 0 and v doesn't contain a chainId,
     *                      old style transactions are assumed.
     */
    public init(
        nonce: EthereumQuantity,
        gasPrice: EthereumQuantity,
        gasLimit: EthereumQuantity,
        to: EthereumAddress,
        value: EthereumQuantity,
        data: EthereumData = EthereumData(bytes: []),
        v: EthereumQuantity = 0,
        r: EthereumQuantity = 0,
        s: EthereumQuantity = 0,
        chainId: EthereumQuantity
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

        if chainId.quantity == 0 && v.quantity >= 37 {
            if v.quantity % 2 == 0 {
                self.chainId = EthereumQuantity(quantity: (v.quantity - 36) / 2)
            } else {
                self.chainId = EthereumQuantity(quantity: (v.quantity - 35) / 2)
            }
        } else {
            self.chainId = chainId
        }
    }

    // MARK: - Convenient functions

    /**
     * Signs this transaction with the given private key and discards old signatures if present.
     *
     * - parameter privateKey: The private key for the new signature.
     */
    @discardableResult
    public mutating func sign(with privateKey: EthereumPrivateKey) throws -> EthereumTransaction {
        let rawRlp = try RLPEncoder().encode(rlp(forSigning: true))
        let signature = try privateKey.sign(message: rawRlp)

        let v: BigUInt
        if self.chainId.quantity == 0 {
            v = BigUInt(signature.v) + BigUInt(27)
        } else {
            let sigV = BigUInt(signature.v)
            let big27 = BigUInt(27)
            let chainIdCalc = (chainId.quantity * BigUInt(2) + BigUInt(8))
            v = sigV + big27 + chainIdCalc
        }

        let r = BigUInt(bytes: signature.r)
        let s = BigUInt(bytes: signature.s)

        self = EthereumTransaction(
            nonce: self.nonce,
            gasPrice: self.gasPrice,
            gasLimit: self.gasLimit,
            to: self.to,
            value: self.value,
            data: self.data,
            v: EthereumQuantity(quantity: v),
            r: EthereumQuantity(quantity: r),
            s: EthereumQuantity(quantity: s),
            chainId: self.chainId
        )

        return self
    }

    public func verifySignature() -> Bool {
        let recId: BigUInt
        if v.quantity >= BigUInt(35) + (BigUInt(2) * chainId.quantity) {
            recId = v.quantity - BigUInt(35) - (BigUInt(2) * chainId.quantity)
        } else {
            if v.quantity >= 27 {
                recId = v.quantity - 27
            } else {
                recId = v.quantity
            }
        }

        if let _ = try? EthereumPublicKey(message: RLPEncoder().encode(rlp(forSigning: true)), v: EthereumQuantity(quantity: recId), r: r, s: s) {
            return true
        }

        return false
    }

    // MARK: - Errors

    public enum Error: Swift.Error {

        case transactionInvalid
        case rlpItemInvalid
        case signatureMalformed
    }
}

extension EthereumTransaction: RLPItemConvertible {

    public init(rlp: RLPItem) throws {
        guard let array = rlp.array, array.count == 9 else {
            throw Error.rlpItemInvalid
        }
        guard let nonce = array[0].bigUInt, let gasPrice = array[1].bigUInt, let gasLimit = array[2].bigUInt,
            let toBytes = array[3].bytes, let to = try? EthereumAddress(rawAddress: toBytes),
            let value = array[4].bigUInt, let data = array[5].bytes, let v = array[6].bigUInt,
            let r = array[7].bigUInt, let s = array[8].bigUInt else {
                throw Error.rlpItemInvalid
        }

        self.init(
            nonce: EthereumQuantity(quantity: nonce),
            gasPrice: EthereumQuantity(quantity: gasPrice),
            gasLimit: EthereumQuantity(quantity: gasLimit),
            to: to,
            value: EthereumQuantity(quantity: value),
            data: EthereumData(bytes: data),
            v: EthereumQuantity(quantity: v),
            r: EthereumQuantity(quantity: r),
            s: EthereumQuantity(quantity: s),
            chainId: 0
        )
    }

    public func rlp() -> RLPItem {
        return rlp(forSigning: false)
    }

    public func rlp(forSigning: Bool) -> RLPItem {
        let item: RLPItem
        if forSigning {
            if chainId.quantity == 0 {
                item = [
                    .bigUInt(nonce.quantity),
                    .bigUInt(gasPrice.quantity),
                    .bigUInt(gasLimit.quantity),
                    .bytes(to.rawAddress),
                    .bigUInt(value.quantity),
                    .bytes(data.bytes)
                ]
            } else {
                item = [
                    .bigUInt(nonce.quantity),
                    .bigUInt(gasPrice.quantity),
                    .bigUInt(gasLimit.quantity),
                    .bytes(to.rawAddress),
                    .bigUInt(value.quantity),
                    .bytes(data.bytes),

                    // EIP 155: For signing and recovering: replace v with chainId and r and s with 0
                    .bigUInt(chainId.quantity),
                    .bigUInt(0),
                    .bigUInt(0)
                ]
            }
        } else {
            item = [
                .bigUInt(nonce.quantity),
                .bigUInt(gasPrice.quantity),
                .bigUInt(gasLimit.quantity),
                .bytes(to.rawAddress),
                .bigUInt(value.quantity),
                .bytes(data.bytes),
                .bigUInt(v.quantity),
                .bigUInt(r.quantity),
                .bigUInt(s.quantity)
            ]
        }

        return item
    }
}

// MARK: - Equatable

extension EthereumTransaction: Equatable {

    public static func ==(_ lhs: EthereumTransaction, _ rhs: EthereumTransaction) -> Bool {
        return lhs.nonce == rhs.nonce
            && lhs.gasPrice == rhs.gasPrice
            && lhs.gasLimit == rhs.gasLimit
            && lhs.to == rhs.to
            && lhs.value == rhs.value
            && lhs.data == rhs.data
            && lhs.v == rhs.v
            && lhs.r == rhs.r
            && lhs.s == rhs.s
            && lhs.chainId == rhs.chainId
    }
}

// MARK: - Hashable

extension EthereumTransaction: Hashable {

    public var hashValue: Int {
        return hashValues(
            nonce, gasPrice, gasLimit, to, value, data, v, r, s, chainId
        )
    }
}
