//
//  Web3.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation
import Alamofire

public struct Web3 {

    public let provider: Web3Provider

    public init(rpcURL: URLConvertible) {
        self.init(provider: Web3HttpProvider(rpcURL: rpcURL))
    }

    public init(provider: Web3Provider) {
        self.provider = provider
    }
}
