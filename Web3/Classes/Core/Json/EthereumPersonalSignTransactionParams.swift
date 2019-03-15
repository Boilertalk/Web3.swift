//
//  EthereumPersonalSignTransactionParams.swift
//  Web3
//
//  Created by Yehor Popovych on 3/15/19.
//

import Foundation


public struct EthereumPersonalSignTransactionParams: Codable {
    public let transaction: EthereumTransaction
    public let password: String
    
    public init(transaction: EthereumTransaction, password: String) {
        self.transaction = transaction
        self.password = password
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let tx = try container.decode(EthereumTransaction.self)
        let pwd = try container.decode(String.self)
        self.init(transaction: tx, password: pwd)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(transaction)
        try container.encode(password)
    }
}

// MARK: - Equatable

extension EthereumPersonalSignTransactionParams: Equatable {
    
    public static func ==(_ lhs: EthereumPersonalSignTransactionParams, _ rhs: EthereumPersonalSignTransactionParams) -> Bool {
        return lhs.transaction == rhs.transaction && lhs.password == rhs.password
    }
}

// MARK: - Hashable

extension EthereumPersonalSignTransactionParams: Hashable {
    
    public var hashValue: Int {
        var hash = transaction.hashValue
        let bytes = withUnsafeBytes(of: &hash) { Array<UInt8>($0) }
        return hashValues(Data(bytes: bytes), password)
    }
}
