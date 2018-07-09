//
//  RPCResponse.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

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
