//
//  ContractPromiseExtensions.swift
//  BigInt
//
//  Created by Koray Koska on 23.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

#if canImport(PromiseKit)

import PromiseKit

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

    func send(nonce: EthereumQuantity? = nil, from: EthereumAddress, value: EthereumQuantity?, gas: EthereumQuantity, gasPrice: EthereumQuantity?) -> Promise<EthereumData> {
        return Promise { seal in
            self.send(nonce: nonce, from: from, value: value, gas: gas, gasPrice: gasPrice, completion: seal.resolve)
        }
    }

    func estimateGas(from: EthereumAddress? = nil, gas: EthereumQuantity? = nil, value: EthereumQuantity? = nil) -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.estimateGas(from: from, gas: gas, value: value, completion: seal.resolve)
        }
    }
}

public extension SolidityConstructorInvocation {

    func send(nonce: EthereumQuantity? = nil, from: EthereumAddress, value: EthereumQuantity = 0, gas: EthereumQuantity, gasPrice: EthereumQuantity?) -> Promise<EthereumData> {
        return Promise { seal in
            self.send(nonce: nonce, from: from, value: value, gas: gas, gasPrice: gasPrice, completion: seal.resolve)
        }
    }
}

#if canImport(Web3PromiseKit)
import Web3PromiseKit

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

#endif
