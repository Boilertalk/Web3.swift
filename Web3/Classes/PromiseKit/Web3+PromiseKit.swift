//
//  Web3+PromiseKit.swift
//  Web3
//
//  Created by Koray Koska on 08.03.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import PromiseKit
#if !Web3CocoaPods
    import Web3
#endif

public extension Web3 {

    func clientVersion() -> Promise<String> {
        return Promise { seal in
            self.clientVersion { response in
                response.sealPromise(seal: seal)
            }
        }
    }
    
}

public extension Web3.Net {

    func version() -> Promise<String> {
        return Promise { seal in
            self.version { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func peerCount() -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.peerCount { response in
                response.sealPromise(seal: seal)
            }
        }
    }
}

public extension Web3.Eth {

    func protocolVersion() -> Promise<String> {
        return Promise { seal in
            self.protocolVersion { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func syncing() -> Promise<EthereumSyncStatusObject> {
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

    func hashrate() -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.hashrate { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func gasPrice() -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.gasPrice { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func accounts() -> Promise<[EthereumAddress]> {
        return Promise { seal in
            self.accounts { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func blockNumber() -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.blockNumber { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getBalance(address: EthereumAddress, block: EthereumQuantityTag) -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.getBalance(address: address, block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getStorageAt(
        address: EthereumAddress,
        position: EthereumQuantity,
        block: EthereumQuantityTag
    ) -> Promise<EthereumData> {
        return Promise { seal in
            self.getStorageAt(address: address, position: position, block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getTransactionCount(address: EthereumAddress, block: EthereumQuantityTag) -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.getTransactionCount(address: address, block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getBlockTransactionCountByHash(blockHash: EthereumData) -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.getBlockTransactionCountByHash(blockHash: blockHash) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getBlockTransactionCountByNumber(block: EthereumQuantityTag) -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.getBlockTransactionCountByNumber(block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getUncleCountByBlockHash(blockHash: EthereumData) -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.getUncleCountByBlockHash(blockHash: blockHash) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getUncleCountByBlockNumber(block: EthereumQuantityTag) -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.getUncleCountByBlockNumber(block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getCode(address: EthereumAddress, block: EthereumQuantityTag) -> Promise<EthereumData> {
        return Promise { seal in
            self.getCode(address: address, block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func sendRawTransaction(transaction: EthereumSignedTransaction) -> Promise<EthereumData> {
        return Promise { seal in
            self.sendRawTransaction(transaction: transaction) { response in
                response.sealPromise(seal: seal)
            }
        }
    }
    
    func sendTransaction(transaction: EthereumTransaction) -> Promise<EthereumData> {
        return Promise { seal in
            self.sendTransaction(transaction: transaction) { response in
                response.sealPromise(seal: seal)
            }
        }
    }
    
    func sign(account: EthereumAddress, message: EthereumData) -> Promise<EthereumData> {
        return Promise { seal in
            self.sign(account: account, message: message) { response in
                response.sealPromise(seal: seal)
            }
        }
    }
    
    func signTypedData(
        account: EthereumAddress, data: EthereumTypedData
    ) -> Promise<EthereumData> {
        return Promise { seal in
            self.signTypedData(account: account, data: data) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func call(call: EthereumCall, block: EthereumQuantityTag) -> Promise<EthereumData> {
        return Promise { seal in
            self.call(call: call, block: block) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func estimateGas(call: EthereumCall) -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.estimateGas(call: call) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getBlockByHash(blockHash: EthereumData, fullTransactionObjects: Bool) -> Promise<EthereumBlockObject?> {
        return Promise { seal in
            self.getBlockByHash(blockHash: blockHash, fullTransactionObjects: fullTransactionObjects) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getBlockByNumber(
        block: EthereumQuantityTag,
        fullTransactionObjects: Bool
    ) -> Promise<EthereumBlockObject?> {
        return Promise { seal in
            self.getBlockByNumber(block: block, fullTransactionObjects: fullTransactionObjects) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getTransactionByHash(blockHash: EthereumData) -> Promise<EthereumTransactionObject?> {
        return Promise { seal in
            self.getTransactionByHash(blockHash: blockHash) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getTransactionByBlockHashAndIndex(
        blockHash: EthereumData,
        transactionIndex: EthereumQuantity
    ) -> Promise<EthereumTransactionObject?> {
        return Promise { seal in
            self.getTransactionByBlockHashAndIndex(blockHash: blockHash, transactionIndex: transactionIndex) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getTransactionByBlockNumberAndIndex(
        block: EthereumQuantityTag,
        transactionIndex: EthereumQuantity
    ) -> Promise<EthereumTransactionObject?> {
        return Promise { seal in
            self.getTransactionByBlockNumberAndIndex(block: block, transactionIndex: transactionIndex) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getTransactionReceipt(transactionHash: EthereumData) -> Promise<EthereumTransactionReceiptObject?> {
        return Promise { seal in
            self.getTransactionReceipt(transactionHash: transactionHash) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getUncleByBlockHashAndIndex(
        blockHash: EthereumData,
        uncleIndex: EthereumQuantity
    ) -> Promise<EthereumBlockObject?> {
        return Promise { seal in
            self.getUncleByBlockHashAndIndex(blockHash: blockHash, uncleIndex: uncleIndex) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func getUncleByBlockNumberAndIndex(
        block: EthereumQuantityTag,
        uncleIndex: EthereumQuantity
    ) -> Promise<EthereumBlockObject?> {
        return Promise { seal in
            self.getUncleByBlockNumberAndIndex(block: block, uncleIndex: uncleIndex) { response in
                response.sealPromise(seal: seal)
            }
        }
    }
    
    func newFilter(
        fromBlock: EthereumQuantityTag? = nil,
        toBlock: EthereumQuantityTag? = nil,
        address: EthereumAddress? = nil,
        topics: [EthereumTopic]? = nil
    ) -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.newFilter(
                fromBlock: fromBlock, toBlock: toBlock,
                address: address, topics: topics
            ) { response in
                response.sealPromise(seal: seal)
            }
        }
    }
    
    func newBlockFilter() -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.newBlockFilter() { response in
                response.sealPromise(seal: seal)
            }
        }
    }
    
    func newPendingTransactionFilter() -> Promise<EthereumQuantity> {
        return Promise { seal in
            self.newPendingTransactionFilter() { response in
                response.sealPromise(seal: seal)
            }
        }
    }
    
    func uninstallFilter(id: EthereumQuantity) -> Promise<Bool> {
        return Promise { seal in
            self.uninstallFilter(id: id) { response in
                response.sealPromise(seal: seal)
            }
        }
    }
    
    func getFilterChanges(id: EthereumQuantity) -> Promise<EthereumFilterChangesObject> {
        return Promise { seal in
            self.getFilterChanges(id: id) { response in
                response.sealPromise(seal: seal)
            }
        }
    }
    
    func getFilterLogs(id: EthereumQuantity) -> Promise<[EthereumLogObject]> {
        return Promise { seal in
            self.getFilterLogs(id: id) { response in
                response.sealPromise(seal: seal)
            }
        }
    }
    
    func getLogs(
        fromBlock: EthereumQuantityTag? = nil,
        toBlock: EthereumQuantityTag? = nil,
        address: EthereumAddress? = nil,
        topics: [EthereumTopic]? = nil,
        blockhash: EthereumData? = nil
    ) -> Promise<[EthereumLogObject]> {
        return Promise { seal in
            self.getLogs(
                fromBlock: fromBlock, toBlock: toBlock, address: address,
                topics: topics, blockhash: blockhash
            ) { response in
                response.sealPromise(seal: seal)
            }
        }
    }
}

public extension Web3.Personal {

    func importRawKey(
        privateKey: EthereumData,
        password: String
    ) -> Promise<EthereumAddress> {
        return Promise { seal in
            self.importRawKey(privateKey: privateKey, password: password) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func listAccounts() -> Promise<[EthereumAddress]> {
        return Promise { seal in
            self.listAccounts() { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func newAccount(password: String) -> Promise<EthereumAddress> {
        return Promise { seal in
            self.newAccount(password: password) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func lockAccount(account: EthereumAddress) -> Promise<Bool> {
        return Promise { seal in
            self.lockAccount(account: account) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func unlockAccount(
            account: EthereumAddress,
            password: String,
            duration: Int? = nil
    ) -> Promise<Bool> {
        return Promise { seal in
            self.unlockAccount(account: account, password: password, duration: duration) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func sendTransaction(
            transaction: EthereumTransaction,
            password: String
    ) -> Promise<EthereumData> {
        return Promise { seal in
            self.sendTransaction(transaction: transaction, password: password) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func sign(
            message: EthereumData,
            account: EthereumAddress,
            password: String
    ) -> Promise<EthereumData> {
        return Promise { seal in
            self.sign(message: message, account: account, password: password) { response in
                response.sealPromise(seal: seal)
            }
        }
    }
    
    func signTypedData(
        account: EthereumAddress, data: EthereumTypedData, password: String
    ) -> Promise<EthereumData> {
        return Promise { seal in
            self.signTypedData(account: account, data: data, password: password) { response in
                response.sealPromise(seal: seal)
            }
        }
    }

    func ecRecover(
            message: EthereumData,
            signature: EthereumData
    ) -> Promise<EthereumAddress> {
        return Promise { seal in
            self.ecRecover(message: message, signature: signature) { response in
                response.sealPromise(seal: seal)
            }
        }
    }
}

fileprivate extension Web3Response {

    func sealPromise(seal: Resolver<Result>) {
        seal.resolve(result, error)
    }
}
