//
//  Promisable.swift
//  BigInt.swift
//
//  Created by Koray Koska on 22.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import PromiseKit

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

extension BlockObject: Guaranteeable {}
extension BlockObject.Transaction: Guaranteeable {}
extension Call: Guaranteeable {}
extension EthereumCallParams: Guaranteeable {}
extension DataObject: Guaranteeable {}
extension LogObject: Guaranteeable {}
extension Quantity: Guaranteeable {}
extension QuantityTag: Guaranteeable {}
extension SyncStatusObject: Guaranteeable {}
extension TransactionObject: Guaranteeable {}
extension TransactionReceiptObject: Guaranteeable {}
extension Value: Guaranteeable {}
extension RPCRequest: Guaranteeable {}
extension RPCResponse: Guaranteeable {}

// MARK: - Transaction

extension Address: Guaranteeable {}
extension PrivateKey: Guaranteeable {}
extension PublicKey: Guaranteeable {}
extension Transaction: Guaranteeable {}
extension SignedTransaction: Guaranteeable {}
