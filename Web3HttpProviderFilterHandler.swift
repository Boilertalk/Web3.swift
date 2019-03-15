//
//  Web3HttpProviderFilterHandler.swift
//  Web3
//
//  Created by Yehor Popovych on 3/15/19.
//

import Foundation

public struct Web3HttpProviderFilterHandler: Web3Provider {
    private let _provider: Web3Provider
    
    public init(_ web3Provider: Web3Provider) {
        _provider = web3Provider
    }
    
    public func send<Params, Result>(request: RPCRequest<Params>, response: @escaping Web3ResponseCompletion<Result>) {
        switch request.method {
        default:
            _provider.send(request: request, response: response)
        }
    }
}
