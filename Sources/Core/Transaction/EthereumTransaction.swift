//
//  EthereumTransaction.swift
//  Web3
//
//  Created by Koray Koska on 05.02.18.
//

import Foundation
import BigInt
import Collections

public struct EthereumTransaction: Codable {
    public enum TransactionType: String, Codable {
        case legacy
        case eip1559
    }

    /// The number of transactions made prior to this one
    public var nonce: EthereumQuantity?

    /// Gas price provided Wei
    public var gasPrice: EthereumQuantity?

    /// Max Fee per Gas as defined in EIP1559. Only required for EIP1559 transactions.
    public var maxFeePerGas: EthereumQuantity?

    /// Max Priority Fee per Gas as defined in EIP1559. Only required for EIP1559 transactions.
    public var maxPriorityFeePerGas: EthereumQuantity?

    /// Gas limit provided
    public var gasLimit: EthereumQuantity?

    /// Address of the sender
    public var from: EthereumAddress?

    /// Address of the receiver
    public var to: EthereumAddress?

    /// Value to transfer provided in Wei
    public var value: EthereumQuantity?

    /// Input data for this transaction
    public var data: EthereumData

    /// `accessList` as defined in EIP2930. Needs to be in the correct format to be a valid tx.
    public var accessList: OrderedDictionary<EthereumAddress, [EthereumData]>

    /// The type of this transaction - changes the generated signature. Default: `.legacy`
    public var transactionType: TransactionType

    // MARK: - Initialization

    /**
     * Initializes a new instance of `EthereumTransaction` with the given values.
     *
     * - parameter nonce: The nonce of this transaction.
     * - parameter gasPrice: The gas price for this transaction in wei.
     * - parameter maxFeePerGas: Max fee per gas as described in EIP1559. Only required for EIP1559 transactions.
     * - parameter maxPriorityFeePerGas: Max Priority Fee per Gas as defined in EIP1559. Only required for EIP1559 transactions.
     * - parameter gasLimit: The gas limit for this transaction.
     * - parameter from: The address to send from, required to send a transaction using sendTransaction()
     * - parameter to: The address of the receiver.
     * - parameter value: The value to be sent by this transaction in wei.
     * - parameter data: Input data for this transaction. Defaults to [].
     * - parameter accessList: accessList as defined in EIP2930. Needs to have the correct format to be considered a valid tx.
     * - parameter transactionType: Type of this transaction. Defaults to `.legacy`.
     */
    public init(
        nonce: EthereumQuantity? = nil,
        gasPrice: EthereumQuantity? = nil,
        maxFeePerGas: EthereumQuantity? = nil,
        maxPriorityFeePerGas: EthereumQuantity? = nil,
        gasLimit: EthereumQuantity? = nil,
        from: EthereumAddress? = nil,
        to: EthereumAddress? = nil,
        value: EthereumQuantity? = nil,
        data: EthereumData = EthereumData([]),
        accessList: OrderedDictionary<EthereumAddress, [EthereumData]> = [:],
        transactionType: TransactionType = .legacy
    ) {
        self.nonce = nonce
        self.gasPrice = gasPrice
        self.maxFeePerGas = maxFeePerGas
        self.maxPriorityFeePerGas = maxPriorityFeePerGas
        self.gasLimit = gasLimit
        self.from = from
        self.to = to
        self.value = value
        self.data = data
        self.accessList = accessList
        self.transactionType = transactionType
    }


    // MARK: - Convenient functions

    /**
     * Signs this transaction with the given private key and returns an instance of `EthereumSignedTransaction`
     *
     * The `transactionType` property of this `EthereumTransaction` defines the type of signature that will be generated.
     *
     * - parameter privateKey: The private key for the new signature.
     * - parameter chainId: Optional chainId as described in EIP155.
     */
    public func sign(with privateKey: EthereumPrivateKey, chainId: EthereumQuantity = 0) throws -> EthereumSignedTransaction {
        switch transactionType {
        case .legacy:
            return try signLegacy(with: privateKey, chainId: chainId)
        case .eip1559:
            return try signEip1559(with: privateKey, chainId: chainId)
        }
    }

    /**
     * Signs this transaction with the given private key and returns an instance of `EthereumSignedTransaction`
     *
     * This function uses the legacy transaction type (or EIP155 if chainId is specified).
     *
     * - parameter privateKey: The private key for the new signature.
     * - parameter chainId: Optional chainId as described in EIP155.
     */
    private func signLegacy(with privateKey: EthereumPrivateKey, chainId: EthereumQuantity = 0) throws -> EthereumSignedTransaction {
        // These values are required for signing
        guard let nonce = nonce, let gasPrice = gasPrice, let gasLimit = gasLimit, let value = value else {
            throw EthereumSignedTransaction.Error.transactionInvalid
        }
        let messageToSign = try self.messageToSign(chainId: chainId)
        let signature = try privateKey.sign(message: messageToSign)

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
            chainId: chainId
        )
    }

    /**
     * Signs this transaction with the given private key and returns an instance of `EthereumSignedTransaction`
     *
     * This function uses the EIP1559 spec to sign the transaction. Assumes required variables for EIP1559 to be set.
     *
     * - parameter privateKey: The private key for the new signature.
     * - parameter chainId: chainId as described in EIP155. Not optional. Throws on 0.
     */
    private func signEip1559(with privateKey: EthereumPrivateKey, chainId: EthereumQuantity) throws -> EthereumSignedTransaction {
        // These values are required for signing
        guard let nonce = nonce, let maxFeePerGas = maxFeePerGas, let maxPriorityFeePerGas = maxPriorityFeePerGas,
              let gasLimit = gasLimit, let value = value else {
            throw EthereumSignedTransaction.Error.transactionInvalid
        }

        // If gasPrice is set, make sure it matches the EIP1559 fees. Otherwise the usage results in unexpected behaviour.
        if let gasPrice = gasPrice {
            if gasPrice.quantity != maxFeePerGas.quantity {
                throw EthereumSignedTransaction.Error.gasPriceMismatch(msg: "EIP1559 - gasPrice != maxFeePerGas")
            }
        }

        if chainId.quantity == BigUInt(0) {
            throw EthereumSignedTransaction.Error.chainIdNotSet(msg: "EIP1559 transactions need a chainId")
        }
        
        var messageToSign = try self.messageToSign(chainId: chainId)
        let signature = try privateKey.sign(message: messageToSign)

        let v = BigUInt(signature.v)
        let r = BigUInt(signature.r)
        let s = BigUInt(signature.s)

        return EthereumSignedTransaction(
            nonce: nonce,
            gasPrice: gasPrice ?? EthereumQuantity(integerLiteral: 0),
            maxFeePerGas: maxFeePerGas,
            maxPriorityFeePerGas: maxPriorityFeePerGas,
            gasLimit: gasLimit,
            to: to,
            value: value,
            data: data,
            v: EthereumQuantity(quantity: v),
            r: EthereumQuantity(quantity: r),
            s: EthereumQuantity(quantity: s),
            chainId: chainId,
            accessList: accessList,
            transactionType: transactionType
        )
    }
}

public extension EthereumTransaction {
    
    fileprivate func messageToSign(chainId: EthereumQuantity) throws -> Bytes {
        let rlpEncoder = RLPEncoder()
        
        if self.transactionType == .legacy {
            guard let nonce = nonce, let gasPrice = gasPrice, let gasLimit = gasLimit, let value = value else {
                throw EthereumSignedTransaction.Error.transactionInvalid
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
            return rawRlp
        } else if self.transactionType == .eip1559 {
            guard let nonce = nonce, let maxFeePerGas = maxFeePerGas, let maxPriorityFeePerGas = maxPriorityFeePerGas,
                  let gasLimit = gasLimit, let value = value else {
                throw EthereumSignedTransaction.Error.transactionInvalid
            }
            let rlp = RLPItem(
                nonce: nonce,
                gasPrice: gasPrice ?? EthereumQuantity(integerLiteral: 0),
                maxFeePerGas: maxFeePerGas,
                maxPriorityFeePerGas: maxPriorityFeePerGas,
                gasLimit: gasLimit,
                to: to,
                value: value,
                data: data,
                chainId: chainId,
                accessList: accessList,
                transactionType: transactionType
            )
            let rawRlp = try rlpEncoder.encode(rlp)
            var messageToSign = Bytes()
            messageToSign.append(0x02)
            messageToSign.append(contentsOf: rawRlp)
            
            return messageToSign
        } else {
            throw EthereumSignedTransaction.Error.transactionInvalid
        }
    }
}

public struct EthereumSignedTransaction {

    // MARK: - Properties

    /// The number of transactions made prior to this one
    public let nonce: EthereumQuantity

    /// Gas price provided Wei
    public let gasPrice: EthereumQuantity

    /// Max Fee per Gas as defined in EIP1559. Only required for EIP1559 transactions.
    public var maxFeePerGas: EthereumQuantity?

    /// Max Priority Fee per Gas as defined in EIP1559. Only required for EIP1559 transactions.
    public var maxPriorityFeePerGas: EthereumQuantity?

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

    /// EIP 155 chainId. Mainnet: 1
    public let chainId: EthereumQuantity

    /// `accessList` as defined in EIP2930. Needs to be in the correct format to be a valid tx.
    public var accessList: OrderedDictionary<EthereumAddress, [EthereumData]>

    /// The type of this transaction - changes the generated signature. Default: `.legacy`
    public var transactionType: EthereumTransaction.TransactionType

    // MARK: - Initialization

    /**
     * Initializes a new instance of `EthereumSignedTransaction` with the given values.
     *
     * - parameter nonce: The nonce of this transaction.
     * - parameter gasPrice: The gas price for this transaction in wei.
     * - parameter maxFeePerGas: Max fee per gas as described in EIP1559. Only required for EIP1559 transactions.
     * - parameter maxPriorityFeePerGas: Max Priority Fee per Gas as defined in EIP1559. Only required for EIP1559 transactions.
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
     * - parameter accessList: accessList as defined in EIP2930. Needs to have the correct format to be considered a valid tx.
     * - parameter transactionType: Type of this transaction. Defaults to `.legacy`.
     */
    public init(
        nonce: EthereumQuantity,
        gasPrice: EthereumQuantity,
        maxFeePerGas: EthereumQuantity? = nil,
        maxPriorityFeePerGas: EthereumQuantity? = nil,
        gasLimit: EthereumQuantity,
        to: EthereumAddress?,
        value: EthereumQuantity,
        data: EthereumData,
        v: EthereumQuantity,
        r: EthereumQuantity,
        s: EthereumQuantity,
        chainId: EthereumQuantity,
        accessList: OrderedDictionary<EthereumAddress, [EthereumData]> = [:],
        transactionType: EthereumTransaction.TransactionType = .legacy
    ) {
        self.nonce = nonce
        self.gasPrice = gasPrice
        self.maxFeePerGas = maxFeePerGas
        self.maxPriorityFeePerGas = maxPriorityFeePerGas
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

        self.accessList = accessList
        self.transactionType = transactionType
    }

    // MARK: - Convenient functions

    public func verifySignature() -> Bool {
        switch transactionType {
        case .legacy:
            return verifyLegacySignature()
        case .eip1559:
            return verifyEip1559Signature()
        }
    }

    private func verifyLegacySignature() -> Bool {
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
        do {
            let messageToSign = try self.unsignedTransaction().messageToSign(chainId: self.chainId)
            if let _ = try? EthereumPublicKey(message: messageToSign, v: EthereumQuantity(quantity: recId), r: r, s: s) {
                return true
            }
        } catch {
            return false
        }

        return false
    }

    private func verifyEip1559Signature() -> Bool {
        do {
            let messageToSign = try self.unsignedTransaction().messageToSign(chainId: self.chainId)
            
            if let _ = try? EthereumPublicKey(message: messageToSign, v: v, r: r, s: s) {
                return true
            }

            return false
        } catch {
            return false
        }
    }

    // MARK: - Errors

    public enum Error: Swift.Error {
        case transactionInvalid
        case rlpItemInvalid
        case signatureMalformed
        case gasPriceMismatch(msg: String)
        case chainIdNotSet(msg: String)
        case rawTransactionInvalid
    }
}

extension EthereumSignedTransaction {
    
    public init(
        rawTx: EthereumData
    ) throws {
        var rawTxBytes = rawTx.makeBytes()
        if (rawTxBytes.starts(with: [0x02])) {
            rawTxBytes.removeFirst()
        }
        do {
            let rlp = try RLPDecoder().decode(rawTxBytes)
            
            try self.init(rlp: rlp)
        } catch {
            throw Error.rawTransactionInvalid
        }
    }
}

extension RLPItem {
    /**
     * Create an RLPItem representing a transaction. The RLPItem must be an array of 9 items in the proper order.
     *
     * - parameter nonce: The nonce of this transaction.
     * - parameter gasPrice: The gas price for this transaction in wei.
     * - parameter maxFeePerGas: Max fee per gas as described in EIP1559. Only required for EIP1559 transactions.
     * - parameter maxPriorityFeePerGas: Max Priority Fee per Gas as defined in EIP1559. Only required for EIP1559 transactions.
     * - parameter gasLimit: The gas limit for this transaction.
     * - parameter to: The address of the receiver.
     * - parameter value: The value to be sent by this transaction in wei.
     * - parameter data: Input data for this transaction.
     * - parameter v: EC signature parameter v, or a EIP155 chain id for an unsigned transaction.
     * - parameter r: EC signature parameter r.
     * - parameter s: EC recovery ID.
     * - parameter chainId: The RLPItem only needs chainId for non-legacy txs as EIP155 encodes chainId in `v` for legacy txs.
     * - parameter accessList: accessList as defined in EIP2930. Needs to have the correct format to be considered a valid tx.
     * - parameter transactionType: Type of this transaction. Defaults to `.legacy`.
     */
    init(
        nonce: EthereumQuantity,
        gasPrice: EthereumQuantity,
        maxFeePerGas: EthereumQuantity? = nil,
        maxPriorityFeePerGas: EthereumQuantity? = nil,
        gasLimit: EthereumQuantity,
        to: EthereumAddress?,
        value: EthereumQuantity,
        data: EthereumData,
        v: EthereumQuantity? = nil,
        r: EthereumQuantity? = nil,
        s: EthereumQuantity? = nil,
        chainId: EthereumQuantity? = nil,
        accessList: OrderedDictionary<EthereumAddress, [EthereumData]> = [:],
        transactionType: EthereumTransaction.TransactionType = .legacy
    ) {
        switch transactionType {
        case .legacy:
            self = .array(
                .bigUInt(nonce.quantity),
                .bigUInt(gasPrice.quantity),
                .bigUInt(gasLimit.quantity),
                .bytes(to?.rawAddress ?? Bytes()),
                .bigUInt(value.quantity),
                .bytes(data.bytes),
                .bigUInt(v?.quantity ?? BigUInt(0)),
                .bigUInt(r?.quantity ?? BigUInt(0)),
                .bigUInt(s?.quantity ?? BigUInt(0))
            )
        case .eip1559:
            var accessListRLP: [RLPItem] = []
            for (key, value) in accessList {
                accessListRLP.append(.array([
                    .bytes(key.rawAddress),
                    .array(value.map({ return .bytes($0.bytes) }))
                ]))
            }

            var rlpToEncode: [RLPItem] = [
                .bigUInt(chainId?.quantity ?? EthereumQuantity(integerLiteral: 0).quantity),
                .bigUInt(nonce.quantity),
                .bigUInt(maxPriorityFeePerGas?.quantity ?? EthereumQuantity(integerLiteral: 0).quantity),
                .bigUInt(maxFeePerGas?.quantity ?? EthereumQuantity(integerLiteral: 0).quantity),
                .bigUInt(gasLimit.quantity),
                .bytes(to?.rawAddress ?? Bytes()),
                .bigUInt(value.quantity),
                .bytes(data.bytes),
                .array(accessListRLP),
            ]
            if let v = v, let r = r, let s = s {
                rlpToEncode.append(contentsOf: [
                    .bigUInt(v.quantity),
                    .bigUInt(r.quantity),
                    .bigUInt(s.quantity)
                ])
            }

            self = .array(
                rlpToEncode
            )
        }
    }
}

extension EthereumSignedTransaction: RLPItemConvertible {

    public init(rlp: RLPItem) throws {
        guard let array = rlp.array else {
            throw Error.rlpItemInvalid
        }

        if array.count == 9 {
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
                data: EthereumData(data),
                v: EthereumQuantity(quantity: v),
                r: EthereumQuantity(quantity: r),
                s: EthereumQuantity(quantity: s),
                chainId: 0
            )
        } else if array.count == 12 {
            // TODO: - See below
            // We assume EIP1559 as we don't support any other tx type.
            // It is impossible to detect the tx type solely from the RLPItem
            // So finding a better solution in the future might be necessary.

            guard let chainId = array[0].bigUInt, let nonce = array[1].bigUInt,
                  let maxPriorityFeePerGas = array[2].bigUInt, let maxFeePerGas = array[3].bigUInt,
                  let gasLimit = array[4].bigUInt, let toBytes = array[5].bytes,
                  let to = try? EthereumAddress(rawAddress: toBytes), let value = array[6].bigUInt,
                  let data = array[7].bytes, let accessListRLP = array[8].array, let v = array[9].bigUInt,
                  let r = array[10].bigUInt, let s = array[11].bigUInt else {
                throw Error.rlpItemInvalid
            }

            var accessList: OrderedDictionary<EthereumAddress, [EthereumData]> = [:]
            for item in accessListRLP {
                guard let arr = item.array, arr.count == 2, let keyBytes = arr[0].bytes,
                      let key = try? EthereumAddress(rawAddress: keyBytes), let valuesRLP = arr[1].array else {
                    continue
                }

                accessList[key] = valuesRLP.map({ return EthereumData($0.bytes ?? Bytes()) })
            }

            self.init(
                nonce: EthereumQuantity(quantity: nonce),
                gasPrice: EthereumQuantity(quantity: maxFeePerGas),
                maxFeePerGas: EthereumQuantity(quantity: maxFeePerGas),
                maxPriorityFeePerGas: EthereumQuantity(quantity: maxPriorityFeePerGas),
                gasLimit: EthereumQuantity(quantity: gasLimit),
                to: to,
                value: EthereumQuantity(quantity: value),
                data: EthereumData(data),
                v: EthereumQuantity(quantity: v),
                r: EthereumQuantity(quantity: r),
                s: EthereumQuantity(quantity: s),
                chainId: EthereumQuantity(quantity: chainId),
                accessList: accessList,
                transactionType: .eip1559
            )
        } else {
            // Unsupported transaction types
            throw Error.rlpItemInvalid
        }
    }

    public func rlp() -> RLPItem {
        return RLPItem(
            nonce: nonce,
            gasPrice: gasPrice,
            maxFeePerGas: maxFeePerGas,
            maxPriorityFeePerGas: maxPriorityFeePerGas,
            gasLimit: gasLimit,
            to: to,
            value: value,
            data: data,
            v: v,
            r: r,
            s: s,
            chainId: chainId,
            accessList: accessList,
            transactionType: transactionType
        )
    }

    public func rawTransaction() throws -> EthereumData {
        switch transactionType {
        case .legacy:
            return try EthereumData(RLPEncoder().encode(rlp()))
        case .eip1559:
            var tx = Bytes()
            tx.append(0x02)
            try tx.append(contentsOf: RLPEncoder().encode(rlp()))

            return EthereumData(tx)
        }
    }
}

// MARK: - Equatable

extension EthereumTransaction: Equatable {
    public static func ==(_ lhs: EthereumTransaction, _ rhs: EthereumTransaction) -> Bool {
        return lhs.nonce == rhs.nonce
            && lhs.gasPrice == rhs.gasPrice
            && lhs.maxFeePerGas == rhs.maxFeePerGas
            && lhs.maxPriorityFeePerGas == rhs.maxPriorityFeePerGas
            && lhs.gasLimit == rhs.gasLimit
            && lhs.from == rhs.from
            && lhs.to == rhs.to
            && lhs.value == rhs.value
            && lhs.data == rhs.data
            && lhs.accessList == rhs.accessList
            && lhs.transactionType == rhs.transactionType
    }
}

extension EthereumSignedTransaction: Equatable {

    public static func ==(_ lhs: EthereumSignedTransaction, _ rhs: EthereumSignedTransaction) -> Bool {
        return lhs.nonce == rhs.nonce
            && lhs.gasPrice == rhs.gasPrice
            && lhs.maxFeePerGas == rhs.maxFeePerGas
            && lhs.maxPriorityFeePerGas == rhs.maxPriorityFeePerGas
            && lhs.gasLimit == rhs.gasLimit
            && lhs.to == rhs.to
            && lhs.value == rhs.value
            && lhs.data == rhs.data
            && lhs.v == rhs.v
            && lhs.r == rhs.r
            && lhs.s == rhs.s
            && lhs.chainId == rhs.chainId
            && lhs.accessList == rhs.accessList
            && lhs.transactionType == rhs.transactionType
    }
}

// MARK: - Hashable

extension EthereumTransaction: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(nonce)
        hasher.combine(gasPrice)
        hasher.combine(maxFeePerGas)
        hasher.combine(maxPriorityFeePerGas)
        hasher.combine(gasLimit)
        hasher.combine(from)
        hasher.combine(to)
        hasher.combine(value)
        hasher.combine(data)
        hasher.combine(accessList)
        hasher.combine(transactionType)
    }
}

extension EthereumSignedTransaction: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(nonce)
        hasher.combine(gasPrice)
        hasher.combine(maxFeePerGas)
        hasher.combine(maxPriorityFeePerGas)
        hasher.combine(gasLimit)
        hasher.combine(to)
        hasher.combine(value)
        hasher.combine(data)
        hasher.combine(v)
        hasher.combine(r)
        hasher.combine(s)
        hasher.combine(chainId)
        hasher.combine(accessList)
        hasher.combine(transactionType)
    }
}

extension EthereumSignedTransaction {
    
    public func from() throws -> EthereumAddress {
        return try publicKey().address
    }
    
    public func publicKey() throws -> EthereumPublicKey {
        let messageToSign = try self.unsignedTransaction().messageToSign(chainId: self.chainId)
        var recId: BigUInt
        if v.quantity >= BigUInt(35) + (BigUInt(2) * chainId.quantity) {
            recId = v.quantity - BigUInt(35) - (BigUInt(2) * chainId.quantity)
        } else {
            if v.quantity >= 27 {
                recId = v.quantity - 27
            } else {
                recId = v.quantity
            }
        }
        return try EthereumPublicKey(message: messageToSign, v: EthereumQuantity(quantity: recId), r: self.r, s: self.s)
    }
    
    public func unsignedTransaction() throws -> EthereumTransaction {
        return EthereumTransaction(
            nonce: self.nonce,
            gasPrice: self.gasPrice,
            maxFeePerGas: self.maxFeePerGas,
            maxPriorityFeePerGas: self.maxPriorityFeePerGas,
            gasLimit: self.gasLimit,
            to: self.to,
            value: self.value,
            data: self.data,
            accessList: self.accessList,
            transactionType: self.transactionType
        )
    }
    
}
