//
//  ContractPromiseExtensions.swift
//  BigInt
//
//  Created by Koray Koska on 23.06.18.
//

#if canImport(Web3ContractABI)

import Web3ContractABI
import PromiseKit
import Collections

#if !Web3CocoaPods
    import Web3
#endif

// MARK: - Extensions

public extension SolidityInvocation {

    func call(block: EthereumQuantityTag = .latest) -> Promise<[String: Any]> {
        return Promise { seal in
            self.call(block: block, completion: seal.resolve)
        }
    }

    func send(
        nonce: EthereumQuantity? = nil,
        gasPrice: EthereumQuantity? = nil,
        maxFeePerGas: EthereumQuantity? = nil,
        maxPriorityFeePerGas: EthereumQuantity? = nil,
        gasLimit: EthereumQuantity? = nil,
        from: EthereumAddress,
        value: EthereumQuantity? = nil,
        accessList: OrderedDictionary<EthereumAddress, [EthereumData]> = [:],
        transactionType: EthereumTransaction.TransactionType = .legacy
    ) -> Promise<EthereumData> {
        return Promise { seal in
            self.send(
                nonce: nonce,
                gasPrice: gasPrice,
                maxFeePerGas: maxFeePerGas,
                maxPriorityFeePerGas: maxPriorityFeePerGas,
                gasLimit: gasLimit,
                from: from,
                value: value,
                accessList: accessList,
                transactionType: transactionType,
                completion: seal.resolve
            )
        }
    }

    func estimateGas(from: EthereumAddress? = nil, gas: EthereumQuantity? = nil, value: EthereumQuantity? = nil) -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.estimateGas(from: from, gas: gas, value: value, completion: seal.resolve)
        }
    }
}

public extension SolidityConstructorInvocation {

    func send(
        nonce: EthereumQuantity? = nil,
        gasPrice: EthereumQuantity? = nil,
        maxFeePerGas: EthereumQuantity? = nil,
        maxPriorityFeePerGas: EthereumQuantity? = nil,
        gasLimit: EthereumQuantity? = nil,
        from: EthereumAddress,
        value: EthereumQuantity? = nil,
        accessList: OrderedDictionary<EthereumAddress, [EthereumData]> = [:],
        transactionType: EthereumTransaction.TransactionType = .legacy
    ) -> Promise<EthereumData> {
        return Promise { seal in
            self.send(
                nonce: nonce,
                gasPrice: gasPrice,
                maxFeePerGas: maxFeePerGas,
                maxPriorityFeePerGas: maxPriorityFeePerGas,
                gasLimit: gasLimit,
                from: from,
                value: value,
                accessList: accessList,
                transactionType: transactionType,
                completion: seal.resolve
            )
        }
    }
}

// MARK: - Promisable and Guaranteeable

extension SolidityTuple: Guaranteeable {}
extension SolidityWrappedValue: Guaranteeable {}
extension ABIObject: Guaranteeable {}
extension SolidityEmittedEvent: Guaranteeable {}
extension SolidityEvent: Guaranteeable {}
extension SolidityFunctionParameter: Guaranteeable {}
extension SolidityReadInvocation: Guaranteeable {}
extension SolidityPayableInvocation: Guaranteeable {}
extension SolidityNonPayableInvocation: Guaranteeable {}
extension SolidityConstructorInvocation: Guaranteeable {}

#endif
