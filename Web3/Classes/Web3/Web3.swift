//
//  Web3.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation
import Alamofire

public struct Web3 {

    public typealias Web3ResponseCompletion<Result: Codable> = (_ resp: Web3Response<Result>) -> Void
    public typealias BasicWeb3ResponseCompletion = Web3ResponseCompletion<EthereumValue>

    public static let jsonrpc = "2.0"

    // MARK: - Properties

    public let properties: Properties

    public struct Properties {

        public let provider: Web3Provider
        public let rpcId: Int
    }

    // MARK: - Convenient properties

    public var provider: Web3Provider {
        return properties.provider
    }

    public var rpcId: Int {
        return properties.rpcId
    }

    public let net: Net

    public let eth: Eth

    // MARK: - Initialization

    public init(rpcURL: URLConvertible, rpcId: Int = 1) {
        self.init(provider: Web3HttpProvider(rpcURL: rpcURL), rpcId: rpcId)
    }

    public init(provider: Web3Provider, rpcId: Int = 1) {
        let properties = Properties(provider: provider, rpcId: rpcId)
        self.properties = properties
        self.net = Net(properties: properties)
        self.eth = Eth(properties: properties)
    }

    // MARK: - Web3 methods

    public func clientVersion(response: @escaping Web3ResponseCompletion<String>) {
        let req = BasicRPCRequest(id: rpcId, jsonrpc: type(of: self).jsonrpc, method: "web3_clientVersion", params: [])

        provider.send(request: req, response: response)
    }

    // MARK: - Net methods

    public struct Net {

        let properties: Properties

        public func version(response: @escaping Web3ResponseCompletion<String>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "net_version", params: [])

            properties.provider.send(request: req, response: response)
        }

        public func peerCount(response: @escaping Web3ResponseCompletion<EthereumQuantity>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "net_peerCount", params: [])

            properties.provider.send(request: req, response: response)
        }
    }

    // MARK: - Eth methods

    public struct Eth {

        let properties: Properties

        public func protocolVersion(response: @escaping Web3ResponseCompletion<String>) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_protocolVersion",
                params: []
            )

            properties.provider.send(request: req, response: response)
        }

        public func syncing(response: @escaping Web3ResponseCompletion<EthereumSyncStatus>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "eth_syncing", params: [])

            properties.provider.send(request: req, response: response)
        }

        public func mining(response: @escaping Web3ResponseCompletion<Bool>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "eth_mining", params: [])

            properties.provider.send(request: req, response: response)
        }

        public func hashrate(response: @escaping Web3ResponseCompletion<EthereumQuantity>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "eth_hashrate", params: [])

            properties.provider.send(request: req, response: response)
        }

        public func gasPrice(response: @escaping Web3ResponseCompletion<EthereumQuantity>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "eth_gasPrice", params: [])

            properties.provider.send(request: req, response: response)
        }

        public func accounts(response: @escaping Web3ResponseCompletion<[EthereumAddress]>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "eth_accounts", params: [])

            properties.provider.send(request: req, response: response)
        }

        public func blockNumber(response: @escaping Web3ResponseCompletion<EthereumQuantity>) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_blockNumber",
                params: []
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBalance(
            address: EthereumAddress,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getBalance",
                params: [address, block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getStorageAt(
            address: EthereumAddress,
            position: EthereumQuantity,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getStorageAt",
                params: [address, position, block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionCount(
            address: EthereumAddress,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
            ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getTransactionCount",
                params: [address, block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBlockTransactionCountByHash(
            blockHash: EthereumData,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getBlockTransactionCountByHash",
                params: [blockHash]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBlockTransactionCountByNumber(
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getBlockTransactionCountByNumber",
                params: [block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getUncleCountByBlockHash(
            blockHash: EthereumData,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getUncleCountByBlockHash",
                params: [blockHash]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getUncleCountByBlockNumber(
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getUncleCountByBlockNumber",
                params: [block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getCode(
            address: EthereumAddress,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getCode",
                params: [address, block]
            )

            properties.provider.send(request: req, response: response)
        }

        public func sendRawTransaction(
            transaction: Transaction,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_sendRawTransaction",
                params: [transaction.rlp(forSigning: false)]
            )

            properties.provider.send(request: req, response: response)
        }

        public func call(
            call: EthereumCall,
            block: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = RPCRequest<EthereumCallParams>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_call",
                params: EthereumCallParams(call: call, block: block)
            )

            properties.provider.send(request: req, response: response)
        }

        public func estimateGas(call: EthereumCall, response: @escaping Web3ResponseCompletion<EthereumQuantity>) {
            let req = RPCRequest<[EthereumCall]>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_estimateGas",
                params: [call]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBlockByHash(
            blockHash: EthereumData,
            fullTransactionObjects: Bool,
            response: @escaping Web3ResponseCompletion<EthereumBlock>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getBlockByHash",
                params: [blockHash, fullTransactionObjects]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getBlockByNumber(
            block: EthereumQuantityTag,
            fullTransactionObjects: Bool,
            response: @escaping Web3ResponseCompletion<EthereumBlock>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getBlockByNumber",
                params: [block, fullTransactionObjects]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionByHash(
            blockHash: EthereumData,
            response: @escaping Web3ResponseCompletion<EthereumTransaction>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getTransactionByHash",
                params: [blockHash]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionByBlockHashAndIndex(
            blockHash: EthereumData,
            transactionIndex: EthereumQuantity,
            response: @escaping Web3ResponseCompletion<EthereumTransaction>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getTransactionByBlockHashAndIndex",
                params: [blockHash, transactionIndex]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionByBlockNumberAndIndex(
            block: EthereumQuantityTag,
            transactionIndex: EthereumQuantity,
            response: @escaping Web3ResponseCompletion<EthereumTransaction>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getTransactionByBlockNumberAndIndex",
                params: [block, transactionIndex]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getTransactionReceipt(
            transactionHash: EthereumData,
            response: @escaping Web3ResponseCompletion<EthereumTransactionReceipt>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getTransactionReceipt",
                params: [transactionHash]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getUncleByBlockHashAndIndex(
            blockHash: EthereumData,
            uncleIndex: EthereumQuantity,
            response: @escaping Web3ResponseCompletion<EthereumBlock>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getUncleByBlockHashAndIndex",
                params: [blockHash, uncleIndex]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getUncleByBlockNumberAndIndex(
            block: EthereumQuantityTag,
            uncleIndex: EthereumQuantity,
            response: @escaping Web3ResponseCompletion<EthereumBlock>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getUncleByBlockNumberAndIndex",
                params: [block, uncleIndex]
            )

            properties.provider.send(request: req, response: response)
        }
    }
}
