//
//  Web3.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public typealias Ethereum = Blockchain
public typealias Binance = Blockchain

/// `Web3` alias for `Blockchain` for standard `Web3` protocols
public typealias Web3 = Blockchain

/// Base class for all `Web3` interactions
public struct Blockchain {
  /// RPC Version
  public static let jsonrpc = "2.0"

  /// Object holding all `Network`, `net` requests
  public let network: Network

  /// Object holding all `eth` requests
  public let node: Node

  public let properties: Properties
  /**
   * Initializes a new instance of `Web3` with the given custom provider.
   *
   * - parameter provider: The provider which handles all requests and responses.
   * - parameter rpcId: The rpc id to be used in all requests. Defaults to 1.
   */
  public init(connectTo provider: Provider, withID rpcID: RPCID = 1) {
    let properties = Properties(provider: provider, rpcId: rpcID)
    self.properties = properties
    self.network = Network(properties: properties)
    self.node = Node(properties: properties)
  }

  /// Gets the current client version.
  /// - returns: Mist/v0.9.3/darwin/go1.4.1
  public func clientVersion(response: @escaping Web3ResponseCompletion<String>) {
    let req = BasicRPCRequest(id: rpcId, jsonrpc: type(of: self).jsonrpc, method: "web3_clientVersion", params: [])

    provider.send(request: req, response: response)
  }
}

// MARK: Network Methods

public extension Blockchain {
  /// `Net` alias for `Network` for standard `Web3` protocols
  typealias Net = Network
  /// The `Network` object for fetching information about the current network.
  struct Network {
    public let properties: Properties

    /**
     * Returns the current network id (chain id).
     *
     * e.g.: "1" - Ethereum Mainnet, "2" - Morden testnet, "3" - Ropsten Testnet
     *
     * - parameter response: The response handler. (Returns `String` - The current network id)
     */
    public func version(response: @escaping Web3ResponseCompletion<String>) {
      let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Blockchain.jsonrpc, method: "net_version", params: [])

      properties.provider.send(request: req, response: response)
    }

    /**
     * Returns number of peers currently connected to the client.
     *
     * e.g.: 0x2 - 2
     *
     * - parameter response: The response handler. (Returns `EthereumQuantity` - Integer of the number of connected peers)
     */
    public func peerCount(response: @escaping Web3ResponseCompletion<Quantity>) {
      let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Blockchain.jsonrpc, method: "net_peerCount", params: [])

      properties.provider.send(request: req, response: response)
    }
  }
}

// MARK: Node Methods

public extension Blockchain {
  /// `Eth` alias for `Node` for standard `Web3` protocols
  typealias Eth = Node

  /// The `Node` for interacting with the network.
  struct Node {
    public let properties: Properties

    public func protocolVersion(response: @escaping Web3ResponseCompletion<String>) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_protocolVersion",
        params: []
      )

      properties.provider.send(request: req, response: response)
    }

    public func syncing(response: @escaping Web3ResponseCompletion<SyncStatusObject>) {
      let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Blockchain.jsonrpc, method: "eth_syncing", params: [])

      properties.provider.send(request: req, response: response)
    }

    public func mining(response: @escaping Web3ResponseCompletion<Bool>) {
      let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Blockchain.jsonrpc, method: "eth_mining", params: [])

      properties.provider.send(request: req, response: response)
    }

    public func hashrate(response: @escaping Web3ResponseCompletion<Quantity>) {
      let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Blockchain.jsonrpc, method: "eth_hashrate", params: [])

      properties.provider.send(request: req, response: response)
    }

    public func gasPrice(response: @escaping Web3ResponseCompletion<Quantity>) {
      let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Blockchain.jsonrpc, method: "eth_gasPrice", params: [])

      properties.provider.send(request: req, response: response)
    }

    public func accounts(response: @escaping Web3ResponseCompletion<[Address]>) {
      let req = BasicRPCRequest(id: properties.rpcId, jsonrpc: Blockchain.jsonrpc, method: "eth_accounts", params: [])

      properties.provider.send(request: req, response: response)
    }

    public func blockNumber(response: @escaping Web3ResponseCompletion<Quantity>) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_blockNumber",
        params: []
      )

      properties.provider.send(request: req, response: response)
    }

    public func getBalance(
      address: Address,
      block: QuantityTag,
      response: @escaping Web3ResponseCompletion<Quantity>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getBalance",
        params: [address, block]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getStorageAt(
      address: Address,
      position: Quantity,
      block: QuantityTag,
      response: @escaping Web3ResponseCompletion<DataObject>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getStorageAt",
        params: [address, position, block]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getTransactionCount(
      address: Address,
      block: QuantityTag,
      response: @escaping Web3ResponseCompletion<Quantity>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getTransactionCount",
        params: [address, block]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getBlockTransactionCountByHash(
      blockHash: DataObject,
      response: @escaping Web3ResponseCompletion<Quantity>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getBlockTransactionCountByHash",
        params: [blockHash]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getBlockTransactionCountByNumber(
      block: QuantityTag,
      response: @escaping Web3ResponseCompletion<Quantity>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getBlockTransactionCountByNumber",
        params: [block]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getUncleCountByBlockHash(
      blockHash: DataObject,
      response: @escaping Web3ResponseCompletion<Quantity>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getUncleCountByBlockHash",
        params: [blockHash]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getUncleCountByBlockNumber(
      block: QuantityTag,
      response: @escaping Web3ResponseCompletion<Quantity>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getUncleCountByBlockNumber",
        params: [block]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getCode(
      address: Address,
      block: QuantityTag,
      response: @escaping Web3ResponseCompletion<DataObject>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getCode",
        params: [address, block]
      )

      properties.provider.send(request: req, response: response)
    }

    public func sendTransaction(
      transaction: Transaction,
      response: @escaping Web3ResponseCompletion<DataObject>
    ) {
      guard transaction.from != nil else {
        let error = NetworkResponse<DataObject>(error: .requestFailed(nil))
        response(error)
        return
      }
      let req = RPCRequest<[Transaction]>(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_sendTransaction",
        params: [transaction]
      )
      properties.provider.send(request: req, response: response)
    }

    public func sendRawTransaction(
      transaction: SignedTransaction,
      response: @escaping Web3ResponseCompletion<DataObject>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_sendRawTransaction",
        params: [transaction.rlp()]
      )

      properties.provider.send(request: req, response: response)
    }

    public func call(
      call: Call,
      block: QuantityTag,
      response: @escaping Web3ResponseCompletion<DataObject>
    ) {
      let req = RPCRequest<EthereumCallParams>(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_call",
        params: EthereumCallParams(call: call, block: block)
      )

      properties.provider.send(request: req, response: response)
    }

    public func estimateGas(call: Call, response: @escaping Web3ResponseCompletion<Quantity>) {
      let req = RPCRequest<[Call]>(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_estimateGas",
        params: [call]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getBlockByHash(
      blockHash: DataObject,
      fullTransactionObjects: Bool,
      response: @escaping Web3ResponseCompletion<BlockObject?>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getBlockByHash",
        params: [blockHash, fullTransactionObjects]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getBlockByNumber(
      block: QuantityTag,
      fullTransactionObjects: Bool,
      response: @escaping Web3ResponseCompletion<BlockObject?>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getBlockByNumber",
        params: [block, fullTransactionObjects]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getTransactionByHash(
      blockHash: DataObject,
      response: @escaping Web3ResponseCompletion<TransactionObject?>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getTransactionByHash",
        params: [blockHash]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getTransactionByBlockHashAndIndex(
      blockHash: DataObject,
      transactionIndex: Quantity,
      response: @escaping Web3ResponseCompletion<TransactionObject?>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getTransactionByBlockHashAndIndex",
        params: [blockHash, transactionIndex]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getTransactionByBlockNumberAndIndex(
      block: QuantityTag,
      transactionIndex: Quantity,
      response: @escaping Web3ResponseCompletion<TransactionObject?>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getTransactionByBlockNumberAndIndex",
        params: [block, transactionIndex]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getTransactionReceipt(
      transactionHash: DataObject,
      response: @escaping Web3ResponseCompletion<TransactionReceiptObject?>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getTransactionReceipt",
        params: [transactionHash]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getUncleByBlockHashAndIndex(
      blockHash: DataObject,
      uncleIndex: Quantity,
      response: @escaping Web3ResponseCompletion<BlockObject?>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getUncleByBlockHashAndIndex",
        params: [blockHash, uncleIndex]
      )

      properties.provider.send(request: req, response: response)
    }

    public func getUncleByBlockNumberAndIndex(
      block: QuantityTag,
      uncleIndex: Quantity,
      response: @escaping Web3ResponseCompletion<BlockObject?>
    ) {
      let req = BasicRPCRequest(
        id: properties.rpcId,
        jsonrpc: Blockchain.jsonrpc,
        method: "eth_getUncleByBlockNumberAndIndex",
        params: [block, uncleIndex]
      )

      properties.provider.send(request: req, response: response)
    }
  }
}

// MARK: Properties

public extension Blockchain {
  struct Properties {
    public let provider: Provider
    public let rpcId: Int
  }

  var provider: Provider {
    properties.provider
  }

  var rpcId: Int {
    properties.rpcId
  }
}

// MARK: Typealias

public extension Blockchain {
  typealias Web3ResponseCompletion<Result: Codable> = (_ resp: NetworkResponse<Result>) -> Void
  typealias BasicWeb3ResponseCompletion = Web3ResponseCompletion<Value>
}
