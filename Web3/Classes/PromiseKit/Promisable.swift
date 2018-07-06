//
//  Promisable.swift
//  BigInt.swift
//
//  Created by Koray Koska on 22.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import PromiseKit
#if !Web3CocoaPods
    import Web3
#endif

public protocol Promisable {

    var promise: Promise<Self> { get }
}

public protocol Guaranteeable: Promisable {

    var guarantee: Guarantee<Self> { get }
}

extension Guaranteeable {

    public var guarantee: Guarantee<Self> {
        return Guarantee { seal in
            seal(self)
        }
    }

    public var promise: Promise<Self> {
        return Promise { seal in
            guarantee.done { obj in
                seal.fulfill(obj)
            }
        }
    }
}

// MARK: - Json

extension EthereumBlockObject: Guaranteeable {}
extension EthereumBlockObject.Transaction: Guaranteeable {}
extension EthereumCall: Guaranteeable {}
extension EthereumCallParams: Guaranteeable {}
extension EthereumData: Guaranteeable {}
extension EthereumLogObject: Guaranteeable {}
extension EthereumQuantity: Guaranteeable {}
extension EthereumQuantityTag: Guaranteeable {}
extension EthereumSyncStatusObject: Guaranteeable {}
extension EthereumTransactionObject: Guaranteeable {}
extension EthereumTransactionReceiptObject: Guaranteeable {}
extension EthereumValue: Guaranteeable {}
extension RPCRequest: Guaranteeable {}
extension RPCResponse: Guaranteeable {}

// MARK: - Transaction

extension EthereumAddress: Guaranteeable {}
extension EthereumPrivateKey: Guaranteeable {}
extension EthereumPublicKey: Guaranteeable {}
extension EthereumTransaction: Guaranteeable {}
extension EthereumSignedTransaction: Guaranteeable {}
