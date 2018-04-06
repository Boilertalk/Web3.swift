//
//  Web3Provider.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public protocol Web3Provider {

    typealias Web3ResponseCompletion<Result: Codable> = (_ resp: Web3Response<Result>) -> Void

    func send<Params, Result>(request: RPCRequest<Params>, response: @escaping Web3ResponseCompletion<Result>)
}

public struct Web3Response<Result: Codable> {

    public let status: Status

    public enum Status: String {

        case ok
        case requestFailed
        case connectionFailed
        case serverError
    }

    public let rpcResponse: RPCResponse<Result>?

    public init(status: Status, rpcResponse: RPCResponse<Result>? = nil) {
        self.status = status
        self.rpcResponse = rpcResponse
    }
}
