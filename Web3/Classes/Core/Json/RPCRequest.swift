//
//  RPCRequest.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public struct RPCRequest<Params: Codable>: Codable {

    /// The rpc id
    public let id: Int

    /// The jsonrpc version. Typically 2.0
    public let jsonrpc: String

    /// The jsonrpc method to be called
    public let method: String

    /// The jsonrpc parameters
    public let params: Params
    
    public init(id: Int, jsonrpc: String, method: String, params: Params) {
        self.id = id
        self.jsonrpc = jsonrpc
        self.method = method
        self.params = params
    }
}

public typealias BasicRPCRequest = RPCRequest<EthereumValue>
