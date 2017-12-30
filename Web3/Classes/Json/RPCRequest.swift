//
//  RPCRequest.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation

public struct RPCRequest: Codable {

    /// The rpc id
    public let id: Int

    /// The jsonrpc version. Typically 2.0
    public let jsonrpc: String

    /// The jsonrpc method to be called
    public let method: String

    /// The jsonrpc parameters
    public let params: EthereumValue
}
