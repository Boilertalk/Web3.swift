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
    init(rpcURL: String, handleFilters: Bool = false) {
        let provider = Web3HttpProvider(rpcURL: rpcURL)
        if handleFilters {
            let counter = AtomicCounter()
            self.init(provider: Web3HttpProviderFilterHandler(provider, counter: counter), rpcIdCounter: counter)
        } else {
            self.init(provider: provider)
        }
    }
}
