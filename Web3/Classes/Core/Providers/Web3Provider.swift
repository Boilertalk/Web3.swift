//
//  Web3Provider.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public protocol Web3Provider {

    typealias Web3ResponseCompletion<Result: Codable> = (_ resp: Web3Response<Result>) -> Void

    func send<Params, Result>(request: RPCRequest<Params>, response: @escaping Web3ResponseCompletion<Result>)
}

public struct Web3Response<Result: Codable> {
    
    public enum Error: Swift.Error {
        case emptyResponse
        case requestFailed(Swift.Error?)
        case connectionFailed(Swift.Error?)
        case serverError(Swift.Error?)
        case decodingError(Swift.Error?)
    }
    
    public enum Status<Result> {
        case success(Result)
        case failure(Swift.Error)
    }
    
    public let id: Int
    public let status: Status<Result>
    
    public var result: Result? {
        return status.result
    }
    
    public var error: Swift.Error? {
        return status.error
    }
    
    // MARK: - Initialization
    
    public init(id: Int, status: Status<Result>) {
        self.status = status
        self.id = id
    }
    
    public init(id: Int, value: Result) {
        self.status = .success(value)
        self.id = id
    }
    
    /// Initialize with any Error object
    public init(id: Int, error: Swift.Error) {
        self.status = .failure(error)
        self.id = id
    }
    
    /// Initialize with a response
    public init(rpcResponse: RPCResponse<Result>) {
        if let result = rpcResponse.result {
            self.status = .success(result)
        } else if let error = rpcResponse.error {
            self.status = .failure(error)
        } else {
            self.status = .failure(Error.emptyResponse)
        }
        self.id = rpcResponse.id
    }
    
    /// For convenience, initialize with one of the common errors
    public init(id: Int, error: Error) {
        self.status = .failure(error)
        self.id = id
    }
}

/// Convenience properties
extension Web3Response.Status {
    public var isSuccess: Bool {
        switch self {
        case .success:
            return true
        case .failure:
            return false
        }
    }
    
    public var isFailure: Bool {
        return !isSuccess
    }
    
    public var result: Result? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
    
    public var error: Error? {
        switch self {
        case .failure(let error):
            return error
        case .success:
            return nil
        }
    }
}

extension Web3Response.Status: CustomStringConvertible {
    public var description: String {
        switch self {
        case .success:
            return "SUCCESS"
        case .failure:
            return "FAILURE"
        }
    }
}

extension Web3Response.Status: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .success(let value):
            return "SUCCESS: \(value)"
        case .failure(let error):
            return "FAILURE: \(error)"
        }
    }
}
