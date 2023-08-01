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

    // MARK: - Properties

    /// The number of transactions made prior to this one
    public let nonce: UInt

    /// Gas price provided Wei
    public let gasPrice: BigUInt

    /// Gas limit provided
    public let gasLimit: UInt

    /// Address of the receiver
    public let to: EthereumAddress

    /// Value to transfer provided in Wei
    public let value: BigUInt

    /// Input data for this transaction
    public let data: Bytes

    /// EC signature parameter v
    public let v: UInt

    /// EC signature parameter r
    public let r: BigUInt

    /// EC recovery ID
    public let s: BigUInt

    /// EIP 155 chainId. Mainnet: 1
    public let chainId: UInt

    // MARK: - Initialization

    /**
     * Initializes a new instance of `Transaction` with the given values.
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
        nonce: UInt,
        gasPrice: BigUInt,
        gasLimit: UInt,
        to: EthereumAddress,
        value: BigUInt,
        data: Bytes = [],
        v: UInt = 0,
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

        if chainId == 0 && v >= 37 {
            if v % 2 == 0 {
                self.chainId = (v - 36) / 2
            } else {
                self.chainId = (v - 35) / 2
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
    public mutating func sign(with privateKey: EthereumPrivateKey) throws -> Transaction {
        let rawRlp = try RLPEncoder().encode(rlp(forSigning: true))
        let signature = try privateKey.sign(message: rawRlp)

        let v: UInt
        if self.chainId == 0 {
            v = signature.v + 27
        } else {
            v = signature.v + 27 + (chainId * 2 + 8)
        }

        let r = BigUInt(bytes: signature.r)
        let s = BigUInt(bytes: signature.s)

        self = Transaction(
            nonce: self.nonce,
            gasPrice: self.gasPrice,
            gasLimit: self.gasLimit,
            to: self.to,
            value: self.value,
            data: self.data,
            v: v,
            r: r,
            s: s,
            chainId: self.chainId
        )

        return self
    }

    public func verifySignature() -> Bool {
        if let _ = try? EthereumPublicKey(message: RLPEncoder().encode(rlp(forSigning: true)), v: v, r: r, s: s) {
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

extension Transaction: RLPItemConvertible {

    public init(rlp: RLPItem) throws {
        guard let array = rlp.array, array.count == 9 else {
            throw Error.rlpItemInvalid
        }
        guard let nonce = array[0].uint, let gasPrice = array[1].bigUInt, let gasLimit = array[2].uint,
            let toBytes = array[3].bytes, let to = try? EthereumAddress(rawAddress: toBytes),
            let value = array[4].bigUInt, let data = array[5].bytes, let v = array[6].uint,
            let r = array[7].bigUInt, let s = array[8].bigUInt else {
                throw Error.rlpItemInvalid
        }

        self.init(
            nonce: nonce,
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            to: to,
            value: value,
            data: data,
            v: v,
            r: r,
            s: s,
            chainId: 0
        )
    }

    public func rlp() -> RLPItem {
        return rlp(forSigning: false)
    }

    public func rlp(forSigning: Bool) -> RLPItem {
        let item: RLPItem
        if forSigning {
            if chainId == 0 {
                item = [
                    .uint(nonce),
                    .bigUInt(gasPrice),
                    .uint(gasLimit),
                    .bytes(to.rawAddress),
                    .bigUInt(value),
                    .bytes(data)
                ]
            } else {
                item = [
                    .uint(nonce),
                    .bigUInt(gasPrice),
                    .uint(gasLimit),
                    .bytes(to.rawAddress),
                    .bigUInt(value),
                    .bytes(data),

                    // EIP 155: For signing and recovering: replace v with chainId and r and s with 0
                    .uint(chainId),
                    .bigUInt(0),
                    .bigUInt(0)
                ]
            }
        } else {
            item = [
                .uint(nonce),
                .bigUInt(gasPrice),
                .uint(gasLimit),
                .bytes(to.rawAddress),
                .bigUInt(value),
                .bytes(data),
                .uint(v),
                .bigUInt(r),
                .bigUInt(s)
            ]
        }

        return item
    }
}
