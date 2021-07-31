//
//  Web3+PromiseKit.swift
//  Web3
//
//  Created by Koray Koska on 08.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//
import PromiseKit

public extension Blockchain {

    func clientVersion() -> Promise<String> {
        return Promise { seal in
            self.clientVersion { response in
                response.sealPromise(seal: seal)
            }
        }
    }
}

public extension Blockchain.Network {

    func version() -> Promise<String> {
        return Promise { seal in
            self.version { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func peerCount() -> Promise<Quantity> {
        return Promise { seal in
            self.peerCount { response in
                response.sealPromise(seal: seal)
            }
        }
    }
}

public extension Blockchain.Node {

    func protocolVersion() -> Promise<String> {
        return Promise { seal in
            self.protocolVersion { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func syncing() -> Promise<SyncStatusObject> {
        return Promise { seal in
            self.syncing { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func mining() -> Promise<Bool> {
        return Promise { seal in
            self.mining { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func hashrate() -> Promise<Quantity> {
        return Promise { seal in
            self.hashrate { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func gasPrice() -> Promise<Quantity> {
        return Promise { seal in
            self.gasPrice { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func accounts() -> Promise<[Address]> {
        return Promise { seal in
            self.accounts { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func blockNumber() -> Promise<Quantity> {
        return Promise { seal in
            self.blockNumber { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getBalance(address: Address, block: QuantityTag) -> Promise<Quantity> {
        return Promise { seal in
            self.getBalance(address: address, block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getStorageAt(
        address: Address,
        position: Quantity,
        block: QuantityTag
    ) -> Promise<DataObject> {
        return Promise { seal in
            self.getStorageAt(address: address, position: position, block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getTransactionCount(address: Address, block: QuantityTag) -> Promise<Quantity> {
        return Promise { seal in
            self.getTransactionCount(address: address, block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getBlockTransactionCountByHash(blockHash: DataObject) -> Promise<Quantity> {
        return Promise { seal in
            self.getBlockTransactionCountByHash(blockHash: blockHash) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getBlockTransactionCountByNumber(block: QuantityTag) -> Promise<Quantity> {
        return Promise { seal in
            self.getBlockTransactionCountByNumber(block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getUncleCountByBlockHash(blockHash: DataObject) -> Promise<Quantity> {
        return Promise { seal in
            self.getUncleCountByBlockHash(blockHash: blockHash) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getUncleCountByBlockNumber(block: QuantityTag) -> Promise<Quantity> {
        return Promise { seal in
            self.getUncleCountByBlockNumber(block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getCode(address: Address, block: QuantityTag) -> Promise<DataObject> {
        return Promise { seal in
            self.getCode(address: address, block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func sendRawTransaction(transaction: SignedTransaction) -> Promise<DataObject> {
        return Promise { seal in
            self.sendRawTransaction(transaction: transaction) { response in
                response.sealPromise(seal: seal)
            }
        }
    }
    
    func sendTransaction(transaction: Transaction) -> Promise<DataObject> {
        return Promise { seal in
            self.sendTransaction(transaction: transaction) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func call(call: Call, block: QuantityTag) -> Promise<DataObject> {
        return Promise { seal in
            self.call(call: call, block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func estimateGas(call: Call) -> Promise<Quantity> {
        return Promise { seal in
            self.estimateGas(call: call) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getBlockByHash(blockHash: DataObject, fullTransactionObjects: Bool) -> Promise<BlockObject?> {
        return Promise { seal in
            self.getBlockByHash(blockHash: blockHash, fullTransactionObjects: fullTransactionObjects) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getBlockByNumber(
        block: QuantityTag,
        fullTransactionObjects: Bool
    ) -> Promise<BlockObject?> {
        return Promise { seal in
            self.getBlockByNumber(block: block, fullTransactionObjects: fullTransactionObjects) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getTransactionByHash(blockHash: DataObject) -> Promise<TransactionObject?> {
        return Promise { seal in
            self.getTransactionByHash(blockHash: blockHash) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getTransactionByBlockHashAndIndex(
        blockHash: DataObject,
        transactionIndex: Quantity
    ) -> Promise<TransactionObject?> {
        return Promise { seal in
            self.getTransactionByBlockHashAndIndex(blockHash: blockHash, transactionIndex: transactionIndex) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getTransactionByBlockNumberAndIndex(
        block: QuantityTag,
        transactionIndex: Quantity
    ) -> Promise<TransactionObject?> {
        return Promise { seal in
            self.getTransactionByBlockNumberAndIndex(block: block, transactionIndex: transactionIndex) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getTransactionReceipt(transactionHash: DataObject) -> Promise<TransactionReceiptObject?> {
        return Promise { seal in
            self.getTransactionReceipt(transactionHash: transactionHash) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getUncleByBlockHashAndIndex(
        blockHash: DataObject,
        uncleIndex: Quantity
    ) -> Promise<BlockObject?> {
        return Promise { seal in
            self.getUncleByBlockHashAndIndex(blockHash: blockHash, uncleIndex: uncleIndex) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getUncleByBlockNumberAndIndex(
        block: QuantityTag,
        uncleIndex: Quantity
    ) -> Promise<BlockObject?> {
        return Promise { seal in
            self.getUncleByBlockNumberAndIndex(block: block, uncleIndex: uncleIndex) { response in
                response.sealPromise(seal: seal)
            }
        }
    }
}

fileprivate extension NetworkResponse {

    func sealPromise(seal: Resolver<Result>) {
        seal.resolve(result, error)
    }
}
