//
//  Web3HttpProvider.swift
//  Web3
//
//  Created by Koray Koska on 17.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import Dispatch

public struct Web3HttpProvider: Web3Provider, Web3DataProvider {
    public enum Error: Swift.Error {
        case badRpcUrl(String)
        case serverError(Swift.Error?)
        case badHttpStatus(Int)
    }
    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    let queue: DispatchQueue

    let session: URLSession

    static let headers = [
        "Accept": "application/json",
        "Content-Type": "application/json"
    ]

    public let rpcURL: String

    public init(rpcURL: String, session: URLSession = URLSession(configuration: .default)) {
        self.rpcURL = rpcURL
        self.session = session
        // Concurrent queue for faster concurrent requests
        self.queue = DispatchQueue(label: "Web3HttpProvider", attributes: .concurrent)
    }
    
    public func send(data: Data, response: @escaping (Swift.Error?, Data?) -> Void) {
        guard let url = URL(string: self.rpcURL) else {
            response(Error.badRpcUrl(self.rpcURL), nil)
            return
        }
        
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.httpBody = data
        for (k, v) in type(of: self).headers {
            req.addValue(v, forHTTPHeaderField: k)
        }
        
        let task = self.session.dataTask(with: req) { data, urlResponse, error in
            guard let urlResponse = urlResponse as? HTTPURLResponse, let data = data, error == nil else {
                response(Error.serverError(error), nil)
                return
            }
            
            let status = urlResponse.statusCode
            guard status >= 200 && status < 300 else {
                response(Error.badHttpStatus(status), nil)
                return
            }
            
            response(nil, data)
        }
        
        task.resume()
    }

    public func send<Params, Result>(request: RPCRequest<Params>, response: @escaping Web3ResponseCompletion<Result>) {
        queue.async {
            let body: Data
            do {
                body = try self.encoder.encode(request)
            } catch {
                let err = Web3Response<Result>(id: request.id, error: .requestFailed(error))
                response(err)
                return
            }
            
            self.send(data: body) { err, data in
                if let err = err {
                    let web3Res: Web3Response<Result>
                    switch err {
                    case Error.badRpcUrl(_):
                        web3Res = Web3Response<Result>(id: request.id, error: .requestFailed(nil))
                    case Error.serverError(let serr):
                        web3Res = Web3Response<Result>(id: request.id, error: .serverError(serr))
                    case Error.badHttpStatus(_):
                        web3Res = Web3Response<Result>(id: request.id, error: .serverError(nil))
                    default:
                        web3Res = Web3Response<Result>(id: request.id, error: .serverError(nil))
                    }
                    response(web3Res)
                }
                do {
                    let rpcResponse = try self.decoder.decode(RPCResponse<Result>.self, from: data!)
                    // We got the Result object
                    let res = Web3Response(rpcResponse: rpcResponse)
                    response(res)
                } catch {
                    // We don't have the response we expected...
                    let err = Web3Response<Result>(id: request.id, error: .decodingError(error))
                    response(err)
                }
            }
        }
    }
}
