//
//  Web3+PromiseKit.swift
//  Web3
//
//  Created by Koray Koska on 08.03.18.
//

import Foundation
import PromiseKit
#if !Web3CocoaPods
    import Web3Core
#endif

extension RPCResponse.Error: Error {
}

extension Web3Response.Status: Error {
}

public extension Web3 {

    public func clientVersion() -> Promise<String> {
        return Promise { seal in
            self.clientVersion { response in
                guard let rpc = response.rpcResponse, response.status == .ok else {
                    seal.reject(response.status)
                    return
                }

                seal.resolve(rpc.result, rpc.error)
            }
        }
    }
}
