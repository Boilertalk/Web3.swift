//
//  Web3.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
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
        private let _rpcId: AtomicCounter
        
        public init(provider: Web3Provider, counter: AtomicCounter) {
            self.provider = provider
            self._rpcId = counter
        }
        
        var rpcId: Int {
            return Int(_rpcId.next())
        }
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
    
    // The struct holding all `personal` requests
    public let personal: Personal

    // MARK: - Initialization

    /**
     * Initializes a new instance of `Web3` with the given custom provider.
     *
     * - parameter provider: The provider which handles all requests and responses.
     */
    public init(provider: Web3Provider, rpcIdCounter: AtomicCounter? = nil) {
        let properties = Properties(provider: provider, counter: rpcIdCounter ?? AtomicCounter())
        self.properties = properties
        self.net = Net(properties: properties)
        self.eth = Eth(properties: properties)
        self.personal = Personal(properties: properties)
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
        
        public func sign(
            account: EthereumAddress,
            message: EthereumData,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_sign",
                params: [account, message]
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func signTypedData(
            account: EthereumAddress,
            data: EthereumTypedData,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = RPCRequest<EthereumSignTypedDataCallParams>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_signTypedData",
                params: EthereumSignTypedDataCallParams(
                    account: account, data: data
                )
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func sendTransaction(
            transaction: EthereumTransaction,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let id = properties.rpcId
            guard transaction.from != nil else {
                let error = Web3Response<EthereumData>(id: id, error: .requestFailed(nil))
                response(error)
                return
            }
            let req = RPCRequest<[EthereumTransaction]>(
                id: id,
                jsonrpc: Web3.jsonrpc,
                method: "eth_sendTransaction",
                params: [transaction]
            )
            properties.provider.send(request: req, response: response)
        }

        public func sendRawTransaction(
            transaction: EthereumSignedTransaction,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_sendRawTransaction",
                params: [transaction.rlp()]
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
        
        public func newFilter(
            fromBlock: EthereumQuantityTag? = nil,
            toBlock: EthereumQuantityTag? = nil,
            address: EthereumAddress? = nil,
            topics: [EthereumTopic]? = nil,
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = RPCRequest<[EthereumNewFilterParams]>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_newFilter",
                params: [EthereumNewFilterParams(
                    fromBlock: fromBlock,
                    toBlock: toBlock,
                    address: address,
                    topics: topics
                )]
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func newBlockFilter(
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_newBlockFilter",
                params: []
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func newPendingTransactionFilter(
            response: @escaping Web3ResponseCompletion<EthereumQuantity>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_newPendingTransactionFilter",
                params: []
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func uninstallFilter(
            id: EthereumQuantity,
            response: @escaping Web3ResponseCompletion<Bool>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_uninstallFilter",
                params: [id]
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func getFilterChanges(
            id: EthereumQuantity,
            response: @escaping Web3ResponseCompletion<EthereumFilterChangesObject>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getFilterChanges",
                params: [id]
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func getFilterLogs(
            id: EthereumQuantity,
            response: @escaping Web3ResponseCompletion<[EthereumLogObject]>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getFilterLogs",
                params: [id]
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func getLogs(
            fromBlock: EthereumQuantityTag? = nil,
            toBlock: EthereumQuantityTag? = nil,
            address: EthereumAddress? = nil,
            topics: [EthereumTopic]? = nil,
            blockhash: EthereumData? = nil,
            response: @escaping Web3ResponseCompletion<[EthereumLogObject]>
        ) {
            let param = EthereumGetLogsParams(
                fromBlock: fromBlock, toBlock: toBlock, address: address,
                topics: topics, blockhash: blockhash
            )
            let req = RPCRequest<[EthereumGetLogsParams]>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "eth_getLogs",
                params: [param]
            )
            
            properties.provider.send(request: req, response: response)
        }
    }
    
    // MARK: - Personal methods
    
    public struct Personal {
        public let properties: Properties
        
        public func importRawKey(
            privateKey: EthereumData,
            password: String,
            response: @escaping Web3ResponseCompletion<EthereumAddress>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "personal_importRawKey",
                params: [privateKey, password]
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func listAccounts(
            response: @escaping Web3ResponseCompletion<[EthereumAddress]>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "personal_listAccounts",
                params: []
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func newAccount(
            password: String,
            response: @escaping Web3ResponseCompletion<EthereumAddress>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "personal_newAccount",
                params: [password]
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func lockAccount(
            account: EthereumAddress,
            response: @escaping Web3ResponseCompletion<Bool>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "personal_lockAccount",
                params: [account]
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func unlockAccount(
            account: EthereumAddress,
            password: String,
            duration: Int? = nil,
            response: @escaping Web3ResponseCompletion<Bool>
        ) {
            let params: [EthereumValueRepresentable] = duration != nil
                ? [account, password, duration!]
                : [account, password]
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "personal_unlockAccount",
                params: EthereumValue(array: params)
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func sendTransaction(
            transaction: EthereumTransaction,
            password: String,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let id = properties.rpcId
            guard transaction.from != nil else {
                let error = Web3Response<EthereumData>(id: id, error: .requestFailed(nil))
                response(error)
                return
            }
            let req = RPCRequest<EthereumPersonalSignTransactionParams>(
                id: id,
                jsonrpc: Web3.jsonrpc,
                method: "personal_sendTransaction",
                params: EthereumPersonalSignTransactionParams(
                    transaction: transaction, password: password
                )
            )
            properties.provider.send(request: req, response: response)
        }
        
        public func sign(
            message: EthereumData,
            account: EthereumAddress,
            password: String,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "personal_sign",
                params: [message, account, password]
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func signTypedData(
            account: EthereumAddress,
            data: EthereumTypedData,
            password: String,
            response: @escaping Web3ResponseCompletion<EthereumData>
        ) {
            let req = RPCRequest<EthereumSignTypedDataCallParams>(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "personal_signTypedData",
                params: EthereumSignTypedDataCallParams(
                    account: account, data: data, password: password
                )
            )
            
            properties.provider.send(request: req, response: response)
        }
        
        public func ecRecover(
            message: EthereumData,
            signature: EthereumData,
            response: @escaping Web3ResponseCompletion<EthereumAddress>
        ) {
            let req = BasicRPCRequest(
                id: properties.rpcId,
                jsonrpc: Web3.jsonrpc,
                method: "personal_ecRecover",
                params: [message, signature]
            )
            
            properties.provider.send(request: req, response: response)
        }
    }
}
