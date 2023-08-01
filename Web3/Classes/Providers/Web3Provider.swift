//
//  Web3Provider.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation

public protocol Web3Provider {

    typealias Web3ResponseCompletion<Result: Codable> = (_ resp: Web3Response<Result>) -> Void

    func send<Result>(request: RPCRequest, response: @escaping Web3ResponseCompletion<Result>)
}

public extension Web3Provider {

    public func basicSend(request: RPCRequest, response: @escaping Web3ResponseCompletion<EthereumValue>) {
        send(request: request, response: response)
    }
}

public struct Web3Response<Result: Codable> {

    let status: Status

    public enum Status {

        case ok
        case connectionFailed
        case serverError
    }

    let rpcResponse: RPCResponse<Result>?
}
