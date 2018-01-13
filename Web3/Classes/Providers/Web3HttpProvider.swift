//
//  Web3HttpProvider.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation
import Alamofire

public struct Web3HttpProvider: Web3Provider {

    let queue: DispatchQueue

    static let headers = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]

    public let rpcURL: URLConvertible

    public init(rpcURL: URLConvertible) {
        self.rpcURL = rpcURL
        // Synchronized queue so our requests are made as they come in (FIFO)
        self.queue = DispatchQueue(label: "Web3HttpProvider")
    }

    public func send<Result>(request: RPCRequest, response: @escaping Web3ResponseCompletion<Result>) {
        let req = Alamofire.request(rpcURL, method: HTTPMethod.post, parameters: [:], encoding: request, headers: type(of: self).headers)

        req.responseDecodable(queue: queue) { (resp: DataResponse<RPCResponse<Result>>) in
            guard case .success(let value) = resp.result else {
                var genericError = true

                if case .failure(let error) = resp.result {
                    if error._code == NSURLErrorTimedOut {
                        // Connection problems
                        genericError = false

                        let err = Web3Response<Result>(status: .connectionFailed, rpcResponse: nil)
                        response(err)
                    }
                }

                if genericError {
                    let err = Web3Response<Result>(status: .serverError, rpcResponse: nil)
                    response(err)
                }
                return
            }
            guard let s = resp.response?.statusCode, s >= 200, s < 300 else {
                // This is a non typical rpc error response and should be considered a server error.
                let err = Web3Response<Result>(status: .serverError, rpcResponse: nil)
                response(err)
                return
            }

            // We got the Result object
            let res = Web3Response(status: .ok, rpcResponse: value)
            response(res)
        }
    }
}

extension RPCRequest: ParameterEncoding {

    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        let encoder = JSONEncoder()
        var request = try urlRequest.asURLRequest()
        request.httpBody = try encoder.encode(self)
        return request
    }
}
