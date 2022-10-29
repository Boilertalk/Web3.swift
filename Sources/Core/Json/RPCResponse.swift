//
//  RPCResponse.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation

// MARK: - Normal RPC Response

public struct RPCResponse<Result: Codable>: Codable {

    /// The rpc id
    public let id: Int

    /// The jsonrpc version. Typically 2.0
    public let jsonrpc: String

    /// The result
    public let result: Result?

    /// The error
    public let error: Error?

    public struct Error: Swift.Error, Codable {

        /// The error code
        public let code: Int

        /// The error message
        public let message: String

        /// Description
        public var localizedDescription: String {
            return "RPC Error (\(code)) \(message)"
        }
    }
}

public typealias BasicRPCResponse = RPCResponse<EthereumValue>

// MARK: - RPC Event Notification Response

public struct RPCEventResponse<Result: Codable>: Codable {

    /// The jsonrpc version. Typically 2.0
    public let jsonrpc: String

    /// The method. Typically eth_subscription
    public let method: String

    /// The params of the notification
    public let params: Params?

    public struct Params: Codable {

        /// The subscription id
        public let subscription: String

        /// The actual expected result
        public let result: Result
    }

    /// The error
    public let error: Error?

    public struct Error: Swift.Error, Codable {

        /// The error code
        public let code: Int

        /// The error message
        public let message: String

        /// Description
        public var localizedDescription: String {
            return "RPC Error (\(code)) \(message)"
        }
    }
}
