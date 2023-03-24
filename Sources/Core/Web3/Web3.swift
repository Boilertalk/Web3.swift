//
//  Web3.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation

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

    /// The struct holding all `net` requests
    public let net: Net

    /// The struct holding all `eth` requests
    public let eth: Eth

    // MARK: - Initialization

    /**
     * Initializes a new instance of `Web3` with the given custom provider.
     *
     * - parameter provider: The provider which handles all requests and responses.
     * - parameter rpcId: The rpc id to be used in all requests. Defaults to 1.
     */
    public init(provider: Web3Provider, rpcId: Int = 1) {
        let properties = Properties(provider: provider, rpcId: rpcId)
        self.properties = properties
        self.net = Net(properties: properties)
        self.eth = Eth(properties: properties)
    }

    // MARK: - Web3 methods

    /**
     * Returns the current client version.
     *
     * e.g.: "Mist/v0.9.3/darwin/go1.4.1"
     *
     * - parameter response: The response handler. (Returns `String` - The current client version)
     */
    public func clientVersion(response: @escaping Web3ResponseCompletion<String>) {
        let req = BasicRPCRequest(id: rpcId, jsonrpc: type(of: self).jsonrpc, method: "web3_clientVersion", params: [])

        provider.send(request: req, response: response)
    }

    // MARK: - Net methods

    public struct Net {

        public let properties: Properties

        /**
         * Returns the current network id (chain id).
         *
         * e.g.: "1" - Ethereum Mainnet, "2" - Morden testnet, "3" - Ropsten Testnet
         *
         * - parameter response: The response handler. (Returns `String` - The current network id)
         */
        public func version(response: @escaping Web3ResponseCompletion<String>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "net_version", params: [])

            properties.provider.send(request: req, response: response)
        }

        /**
         * Returns number of peers currently connected to the client.
         *
         * e.g.: 0x2 - 2
         *
         * - parameter response: The response handler. (Returns `EthereumQuantity` - Integer of the number of connected peers)
         */
        public func peerCount(response: @escaping Web3ResponseCompletion<EthereumQuantity>) {
            let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Web3.jsonrpc, method: "net_peerCount", params: [])

            properties.provider.send(request: req, response: response)
        }
    }

    // MARK: - Eth methods

    public struct Eth {

        public enum Error: Swift.Error {
            case providerDoesNotSupportSubscriptions
        }

        public let properties: Properties

        // MARK: - Methods

        public func protocolVersion(response: @escaping Web3ResponseCompletion<String>) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_protocolVersion",
                params: []
            )

            properties.provider.send(request: req, response: response)
        }

        public func syncing(response: @escaping Web3ResponseCompletion<EthereumSyncStatusObject>) {
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

        public func sendTransaction(
            transaction: EthereumTransaction,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            guard transaction.from != nil else {
                let error = Web3Response<EthereumData>(error: .requestFailed(nil))
                response(error)
                return
            }
            let req = RPCRequest<[EthereumTransaction]>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_sendTransaction",
                params: [transaction]
            )
            properties.provider.send(request: req, response: response)
        }

        public func sendRawTransaction(
            transaction: EthereumSignedTransaction,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) throws {
            let req = try BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_sendRawTransaction",
                params: [transaction.rawTransaction()]
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
            response: @escaping Web3ResponseCompletion<EthereumBlockObject?>
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
            response: @escaping Web3ResponseCompletion<EthereumBlockObject?>
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
            response: @escaping Web3ResponseCompletion<EthereumTransactionObject?>
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
            response: @escaping Web3ResponseCompletion<EthereumTransactionObject?>
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
            response: @escaping Web3ResponseCompletion<EthereumTransactionObject?>
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
            response: @escaping Web3ResponseCompletion<EthereumTransactionReceiptObject?>
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
            response: @escaping Web3ResponseCompletion<EthereumBlockObject?>
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
            response: @escaping Web3ResponseCompletion<EthereumBlockObject?>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getUncleByBlockNumberAndIndex",
                params: [block, uncleIndex]
            )

            properties.provider.send(request: req, response: response)
        }

        public func getLogs(
            addresses: [EthereumAddress]?,
            topics: [[EthereumData]]?,
            fromBlock: EthereumQuantityTag,
            toBlock: EthereumQuantityTag,
            response: @escaping Web3ResponseCompletion<[EthereumLogObject]>
        ) {
            struct LogsParam: Codable {
                let address: [EthereumAddress]?
                let topics: [[EthereumData]]?

                let fromBlock: EthereumQuantityTag
                let toBlock: EthereumQuantityTag
            }

            let req = RPCRequest<[LogsParam]>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getLogs",
                params: [LogsParam(address: addresses, topics: topics, fromBlock: fromBlock, toBlock: toBlock)]
            )

            properties.provider.send(request: req, response: response)
        }

        // MARK: - Events

        public func subscribeToNewHeads(
            subscribed: @escaping Web3ResponseCompletion<String>,
            onEvent: @escaping Web3ResponseCompletion<EthereumBlockObject>
        ) throws {
            guard let provider = properties.provider as? Web3BidirectionalProvider else {
                throw Error.providerDoesNotSupportSubscriptions
            }

            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_subscribe",
                params: ["newHeads"]
            )

            provider.subscribe(request: req, response: subscribed, onEvent: onEvent)
        }

        public func subscribeToNewPendingTransactions(
            subscribed: @escaping Web3ResponseCompletion<String>,
            onEvent: @escaping Web3ResponseCompletion<EthereumData>
        ) throws {
            guard let provider = properties.provider as? Web3BidirectionalProvider else {
                throw Error.providerDoesNotSupportSubscriptions
            }

            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_subscribe",
                params: ["newPendingTransactions"]
            )

            provider.subscribe(request: req, response: subscribed, onEvent: onEvent)
        }

        public func subscribeToLogs(
            addresses: [EthereumAddress]? = nil,
            topics: [[EthereumData]]? = nil,
            subscribed: @escaping Web3ResponseCompletion<String>,
            onEvent: @escaping Web3ResponseCompletion<EthereumLogObject>
        ) throws {
            guard let provider = properties.provider as? Web3BidirectionalProvider else {
                throw Error.providerDoesNotSupportSubscriptions
            }

            struct LogsParam: Codable {
                var eventName = "logs"

                let params: Params?

                struct Params: Codable {
                    enum CodingKeys: String, CodingKey {
                        case address = "address"

                        case topics = "topics"
                    }

                    let address: [EthereumAddress]?

                    let topics: [[EthereumData]]?
                }

                func encode(to encoder: Encoder) throws {
                    if let params = params {
                        var container = encoder.container(keyedBy: LogsParam.Params.CodingKeys.self)

                        try container.encodeIfPresent(params.address, forKey: LogsParam.Params.CodingKeys.address)
                        try container.encodeIfPresent(params.topics, forKey: LogsParam.Params.CodingKeys.topics)
                    } else {
                        // Just encode "logs" aka the event name
                        var container = encoder.singleValueContainer()
                        try container.encode(eventName)
                    }
                }
            }

            let req = RPCRequest<[LogsParam]>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_subscribe",
                params: [LogsParam(params: nil), LogsParam(params: LogsParam.Params(address: addresses, topics: topics))]
            )

            provider.subscribe(request: req, response: subscribed, onEvent: onEvent)
        }

        public func unsubscribe(subscriptionId: String, completion: @escaping (Bool) -> Void) throws {
            guard let provider = properties.provider as? Web3BidirectionalProvider else {
                throw Error.providerDoesNotSupportSubscriptions
            }

            provider.unsubscribe(subscriptionId: subscriptionId, completion: completion)
        }
    }
}
