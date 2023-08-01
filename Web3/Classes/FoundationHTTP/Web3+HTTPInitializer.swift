//
//  Web3+HTTPInitializer.swift
//  Web3HTTPExtension
//
//  Created by Koray Koska on 17.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public extension Web3 {

    /**
     * Initializes a new instance of `Web3` with the default HTTP RPC interface and the given url.
     *
     * - parameter rpcURL: The URL of the HTTP RPC API.
     * - parameter rpcId: The rpc id to be used in all requests. Defaults to 1.
     */
    public init(rpcURL: String, rpcId: Int = 1) {
        self.init(provider: Web3HttpProvider(rpcURL: rpcURL), rpcId: rpcId)
    }
}
