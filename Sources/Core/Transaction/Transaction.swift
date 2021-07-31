//
//  EthereumTransaction.swift
//  Web3
//
//  Created by Koray Koska on 05.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation


public struct Transaction: Codable {
    /// The number of transactions made prior to this one
    public var nonce: Quantity?
    
    /// Gas price provided Wei
    public var gasPrice: Quantity?
    
    /// Gas limit provided
    public var gas: Quantity?
    
    /// Address of the sender
    public var from: Address?
    
    /// Address of the receiver
    public var to: Address?
    
    /// Value to transfer provided in Wei
    public var value: Quantity?
    
    /// Input data for this transaction
    public var data: DataObject
    
    // MARK: - Initialization
    
    /**
     * Initializes a new instance of `EthereumTransaction` with the given values.
     *
     * - parameter nonce: The nonce of this transaction.
     * - parameter gasPrice: The gas price for this transaction in wei.
     * - parameter gasLimit: The gas limit for this transaction.
     * - parameter from: The address to send from, required to send a transaction using sendTransaction()
     * - parameter to: The address of the receiver.
     * - parameter value: The value to be sent by this transaction in wei.
     * - parameter data: Input data for this transaction. Defaults to [].
     */
    public init(
        nonce: Quantity? = nil,
        gasPrice: Quantity? = nil,
        gas: Quantity? = nil,
        from: Address? = nil,
        to: Address? = nil,
        value: Quantity? = nil,
        data: DataObject = DataObject([])
    ) {
        self.nonce = nonce
        self.gasPrice = gasPrice
        self.gas = gas
        self.from = from
        self.to = to
        self.value = value
        self.data = data
    }
    
    
    // MARK: - Convenient functions
    
    /**
     * Signs this transaction with the given private key and returns an instance of `EthereumSignedTransaction`
     *
     * - parameter privateKey: The private key for the new signature.
     * - parameter chainId: Optional chainId as described in EIP155.
     */
    public func sign(with privateKey: PrivateKey, chainId: Quantity = 0) throws -> SignedTransaction {
        // These values are required for signing
        guard let nonce = nonce, let gasPrice = gasPrice, let gasLimit = gas, let value = value else {
            throw SignedTransaction.Error.transactionInvalid
        }
        let rlp = RLPItem(
            nonce: nonce,
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            to: to,
            value: value,
            data: data,
            v: chainId,
            r: 0,
            s: 0
        )
        let rawRlp = try RLPEncoder().encode(rlp)
        let signature = try privateKey.sign(message: rawRlp)
        
        let v: BigUInt
        if chainId.quantity == 0 {
            v = BigUInt(signature.v) + BigUInt(27)
        } else {
            let sigV = BigUInt(signature.v)
            let big27 = BigUInt(27)
            let chainIdCalc = (chainId.quantity * BigUInt(2) + BigUInt(8))
            v = sigV + big27 + chainIdCalc
        }
        
        let r = BigUInt(signature.r)
        let s = BigUInt(signature.s)
        
        return SignedTransaction(
            nonce: nonce,
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            to: to,
            value: value,
            data: data,
            v: Quantity(quantity: v),
            r: Quantity(quantity: r),
            s: Quantity(quantity: s),
            chainId: chainId
        )
    }
}

public struct SignedTransaction {

    // MARK: - Properties

    /// The number of transactions made prior to this one
    public let nonce: Quantity

    /// Gas price provided Wei
    public let gasPrice: Quantity

    /// Gas limit provided
    public let gasLimit: Quantity

    /// Address of the receiver
    public let to: Address?

    /// Value to transfer provided in Wei
    public let value: Quantity

    /// Input data for this transaction
    public let data: DataObject

    /// EC signature parameter v
    public let v: Quantity

    /// EC signature parameter r
    public let r: Quantity

    /// EC recovery ID
    public let s: Quantity

    /// EIP 155 chainId. Mainnet: 1
    public let chainId: Quantity

    // MARK: - Initialization

    /**
     * Initializes a new instance of `EthereumSignedTransaction` with the given values.
     *
     * - parameter nonce: The nonce of this transaction.
     * - parameter gasPrice: The gas price for this transaction in wei.
     * - parameter gasLimit: The gas limit for this transaction.
     * - parameter to: The address of the receiver.
     * - parameter value: The value to be sent by this transaction in wei.
     * - parameter data: Input data for this transaction.
     * - parameter v: EC signature parameter v.
     * - parameter r: EC signature parameter r.
     * - parameter s: EC recovery ID.
     * - parameter chainId: The chainId as described in EIP155. Mainnet: 1.
     *                      If set to 0 and v doesn't contain a chainId,
     *                      old style transactions are assumed.
     */
    public init(
        nonce: Quantity,
        gasPrice: Quantity,
        gasLimit: Quantity,
        to: Address?,
        value: Quantity,
        data: DataObject,
        v: Quantity,
        r: Quantity,
        s: Quantity,
        chainId: Quantity
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
                self.chainId = Quantity(quantity: (v.quantity - 36) / 2)
            } else {
                self.chainId = Quantity(quantity: (v.quantity - 35) / 2)
            }
        } else {
            self.chainId = chainId
        }
    }
    
    // MARK: - Convenient functions

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
        let rlp = RLPItem(
            nonce: nonce,
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            to: to,
            value: value,
            data: data,
            v: chainId,
            r: 0,
            s: 0
        )
        if let _ = try? PublicKey(message: RLPEncoder().encode(rlp), v: Quantity(quantity: recId), r: r, s: s) {
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

extension RLPItem {
    /**
     * Create an RLPItem representing a transaction. The RLPItem must be an array of 9 items in the proper order.
     *
     * - parameter nonce: The nonce of this transaction.
     * - parameter gasPrice: The gas price for this transaction in wei.
     * - parameter gasLimit: The gas limit for this transaction.
     * - parameter to: The address of the receiver.
     * - parameter value: The value to be sent by this transaction in wei.
     * - parameter data: Input data for this transaction.
     * - parameter v: EC signature parameter v, or a EIP155 chain id for an unsigned transaction.
     * - parameter r: EC signature parameter r.
     * - parameter s: EC recovery ID.
     */
    init(
        nonce: Quantity,
        gasPrice: Quantity,
        gasLimit: Quantity,
        to: Address?,
        value: Quantity,
        data: DataObject,
        v: Quantity,
        r: Quantity,
        s: Quantity
    ) {
        self = .array(
            .bigUInt(nonce.quantity),
            .bigUInt(gasPrice.quantity),
            .bigUInt(gasLimit.quantity),
            .bytes(to?.rawAddress ?? Bytes()),
            .bigUInt(value.quantity),
            .bytes(data.bytes),
            .bigUInt(v.quantity),
            .bigUInt(r.quantity),
            .bigUInt(s.quantity)
        )
    }
    
}

extension SignedTransaction: RLPItemConvertible {

    public init(rlp: RLPItem) throws {
        guard let array = rlp.array, array.count == 9 else {
            throw Error.rlpItemInvalid
        }
        guard let nonce = array[0].bigUInt, let gasPrice = array[1].bigUInt, let gasLimit = array[2].bigUInt,
            let toBytes = array[3].bytes, let to = try? Address(rawAddress: toBytes),
            let value = array[4].bigUInt, let data = array[5].bytes, let v = array[6].bigUInt,
            let r = array[7].bigUInt, let s = array[8].bigUInt else {
                throw Error.rlpItemInvalid
        }

        self.init(
            nonce: Quantity(quantity: nonce),
            gasPrice: Quantity(quantity: gasPrice),
            gasLimit: Quantity(quantity: gasLimit),
            to: to,
            value: Quantity(quantity: value),
            data: DataObject(data),
            v: Quantity(quantity: v),
            r: Quantity(quantity: r),
            s: Quantity(quantity: s),
            chainId: 0
        )
    }
    
    public func rlp() -> RLPItem {
        return RLPItem(
            nonce: nonce,
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            to: to,
            value: value,
            data: data,
            v: v,
            r: r,
            s: s
        )
    }
}

// MARK: - Equatable

extension Transaction: Equatable {
    public static func ==(_ lhs: Transaction, _ rhs: Transaction) -> Bool {
        return lhs.nonce == rhs.nonce
            && lhs.gasPrice == rhs.gasPrice
            && lhs.gas == rhs.gas
            && lhs.from == rhs.from
            && lhs.to == rhs.to
            && lhs.value == rhs.value
            && lhs.data == rhs.data
    }
}

extension SignedTransaction: Equatable {

    public static func ==(_ lhs: SignedTransaction, _ rhs: SignedTransaction) -> Bool {
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

extension Transaction: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(nonce)
        hasher.combine(gasPrice)
        hasher.combine(gas)
        hasher.combine(from)
        hasher.combine(to)
        hasher.combine(value)
        hasher.combine(data)
    }
}

extension SignedTransaction: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(nonce)
        hasher.combine(gasPrice)
        hasher.combine(gasLimit)
        hasher.combine(to)
        hasher.combine(value)
        hasher.combine(data)
        hasher.combine(v)
        hasher.combine(r)
        hasher.combine(s)
        hasher.combine(chainId)
    }
}
