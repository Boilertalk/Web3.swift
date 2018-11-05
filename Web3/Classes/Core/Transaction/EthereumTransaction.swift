//
//  EthereumTransaction.swift
//  Web3
//
//  Created by Koray Koska on 05.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import BigInt

public struct EthereumTransaction: Codable {
    /// The number of transactions made prior to this one
    public var nonce: EthereumQuantity?
    
    /// Gas price provided Wei
    public var gasPrice: EthereumQuantity?
    
    /// Gas limit provided
    public var gas: EthereumQuantity?
    
    /// Address of the sender
    public var from: EthereumAddress?
    
    /// Address of the receiver
    public var to: EthereumAddress?
    
    /// Value to transfer provided in Wei
    public var value: EthereumQuantity?
    
    /// Input data for this transaction
    public var data: EthereumData
    
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
        nonce: EthereumQuantity? = nil,
        gasPrice: EthereumQuantity? = nil,
        gas: EthereumQuantity? = nil,
        from: EthereumAddress? = nil,
        to: EthereumAddress? = nil,
        value: EthereumQuantity? = nil,
        data: EthereumData = EthereumData(bytes: [])
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
     * - parameter chain: Wrapper for the chainId, as described in EIP155.
     */
    public func sign(with privateKey: EthereumPrivateKey, chain: EthereumChain) throws -> EthereumSignedTransaction {
        // These values are required for signing
        guard let nonce = nonce, let gasPrice = gasPrice, let gasLimit = gas, let value = value else {
            throw EthereumSignedTransaction.Error.transactionInvalid
        }
        let chainId = EthereumQuantity(quantity: BigUInt(chain.rawValue))
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
        
        let r = BigUInt(bytes: signature.r)
        let s = BigUInt(bytes: signature.s)
        
        return EthereumSignedTransaction(
            nonce: nonce,
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            to: to,
            value: value,
            data: data,
            v: EthereumQuantity(quantity: v),
            r: EthereumQuantity(quantity: r),
            s: EthereumQuantity(quantity: s),
            chain: chain
        )
    }
}

public struct EthereumSignedTransaction {

    // MARK: - Properties

    /// The number of transactions made prior to this one
    public let nonce: EthereumQuantity

    /// Gas price provided Wei
    public let gasPrice: EthereumQuantity

    /// Gas limit provided
    public let gasLimit: EthereumQuantity

    /// Address of the receiver
    public let to: EthereumAddress?

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

    /// EIP 155 chainId. Mainnet: .main, i.e. 1
    public let chainId: EthereumQuantity

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
     * - parameter chain: Wrapper for the chainId, as described in EIP155. Mainnet: .main.
     *                      If set to .legacy (i.e. 0) and v doesn't contain a chainId,
     *                      old style transactions are assumed.
     */
    public init(
        nonce: EthereumQuantity,
        gasPrice: EthereumQuantity,
        gasLimit: EthereumQuantity,
        to: EthereumAddress?,
        value: EthereumQuantity,
        data: EthereumData,
        v: EthereumQuantity,
        r: EthereumQuantity,
        s: EthereumQuantity,
        chain: EthereumChain
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
        let chainId = EthereumQuantity(quantity: BigUInt(chain.rawValue))

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
        if let _ = try? EthereumPublicKey(message: RLPEncoder().encode(rlp), v: EthereumQuantity(quantity: recId), r: r, s: s) {
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

/**
 * Chain ID (also known as the Network ID), used when signing transactions or creating signed transactions.
 */
public enum EthereumChain : RawRepresentable {
    public typealias RawValue = Int

    /// Unsafe to be used as this generates a signature without replay protection. Added for legacy purposes as the name states.
    case legacy
    case main
    case expanse
    case ropsten
    case rinkeby
    case ubiq
    case kovan
    case ethereumClassic
    case sokol
    case core
    case musicoin
    case aquachain
    case custom(Int)

    public init(rawValue: Int) {
        switch rawValue {
        case 0: self = .legacy
        case 1: self = .main
        case 2: self = .expanse
        case 3: self = .ropsten
        case 4: self = .rinkeby
        case 8: self = .ubiq
        case 42: self = .kovan
        case 61: self = .ethereumClassic
        case 77: self = .sokol
        case 99: self = .core
        case 7762959: self = .musicoin
        case 61717561: self = .aquachain
        default: self = .custom(rawValue)
        }
    }

    public var rawValue: Int {
        switch self {
        case .legacy: return 0
        case .main: return 1
        case .expanse: return 2
        case .ropsten: return 3
        case .rinkeby: return 4
        case .ubiq: return 8
        case .kovan: return 42
        case .ethereumClassic: return 61
        case .sokol: return 77
        case .core: return 99
        case .musicoin: return 7762959
        case .aquachain: return 61717561
        case .custom(let value): return value
        }
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
        nonce: EthereumQuantity,
        gasPrice: EthereumQuantity,
        gasLimit: EthereumQuantity,
        to: EthereumAddress?,
        value: EthereumQuantity,
        data: EthereumData,
        v: EthereumQuantity,
        r: EthereumQuantity,
        s: EthereumQuantity
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

extension EthereumSignedTransaction: RLPItemRepresentable {
    
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

extension EthereumTransaction: Equatable {
    public static func ==(_ lhs: EthereumTransaction, _ rhs: EthereumTransaction) -> Bool {
        return lhs.nonce == rhs.nonce
            && lhs.gasPrice == rhs.gasPrice
            && lhs.gas == rhs.gas
            && lhs.from == rhs.from
            && lhs.to == rhs.to
            && lhs.value == rhs.value
            && lhs.data == rhs.data
    }
}

extension EthereumSignedTransaction: Equatable {

    public static func ==(_ lhs: EthereumSignedTransaction, _ rhs: EthereumSignedTransaction) -> Bool {
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
            nonce, gasPrice, gas, from, to, value, data
        )
    }
}

extension EthereumSignedTransaction: Hashable {
    
    public var hashValue: Int {
        return hashValues(
            nonce, gasPrice, gasLimit, to, value, data, v, r, s, chainId
        )
    }
}
