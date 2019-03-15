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
     */
    public init(rpcURL: String) {
        self.init(provider: Web3HttpProvider(rpcURL: rpcURL))
    }
}
