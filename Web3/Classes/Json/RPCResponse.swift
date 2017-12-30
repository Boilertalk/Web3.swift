//
//  RPCResponse.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation

public struct RPCResponse: Codable {

    /// The rpc id
    public let id: Int

    /// The jsonrpc version. Typically 2.0
    public let jsonrpc: String

    /// The result
    public let result: EthereumValue?

    /// The error
    public let error: Error?

    public struct Error: Codable {

        /// The error code
        let code: Int

        /// The error message
        let message: String
    }
}
