//
//  Web3+HTTPInitializer.swift
//  Alamofire
//
//  Created by Koray Koska on 16.02.18.
//

import Foundation
import Alamofire

public extension Web3 {

    /**
     * Initializes a new instance of `Web3` with the default HTTP RPC interface and the given url.
     *
     * - parameter rpcURL: The URL of the HTTP RPC API.
     * - parameter rpcId: The rpc id to be used in all requests. Defaults to 1.
     */
    public init(rpcURL: URLConvertible, rpcId: Int = 1) {
        self.init(provider: Web3HttpProvider(rpcURL: rpcURL), rpcId: rpcId)
    }
}
