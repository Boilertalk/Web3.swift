//
//  EthereumTypedData.swift
//  Web3
//
//  Created by Yehor Popovych on 3/19/19.
//

import Foundation

public struct EthereumTypedData: Codable, Equatable {
    public struct `Type`: Codable, Equatable {
        public let name: String
        public let type: String
        
        public init(name: String, type: String) {
            self.name = name
            self.type = type
        }
    }
    
    public struct Domain: Codable, Equatable {
        public let name: String
        public let version: String
        //Theoretically should be EthereumQuantity, but all libs are using Int
        public let chainId: Int
        public let verifyingContract: EthereumAddress
        
        public init(
            name: String,
            version: String,
            chainId: Int,
            verifyingContract: EthereumAddress
        ) {
            self.name = name
            self.version = version
            self.chainId = chainId
            self.verifyingContract = verifyingContract
        }
    }
    
    public let types: Dictionary<String, Array<Type>>
    public let primaryType: String
    public let domain: Domain
    public let message: Dictionary<String, JSONValue>
    
    public init(
        primaryType: String,
        domain: Domain,
        types: Dictionary<String, Array<Type>>,
        message: Dictionary<String, JSONValue>
    ) {
        self.primaryType = primaryType
        self.domain = domain
        self.types = types
        self.message = message
    }
}

public struct EthereumSignTypedDataCallParams: Codable, Equatable {
    public let account: EthereumAddress
    public let data: EthereumTypedData
    public let password: String?
    
    public init(account: EthereumAddress, data: EthereumTypedData, password: String? = nil) {
        self.account = account
        self.data = data
        self.password = password
    }
    
    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let account = try container.decode(EthereumAddress.self)
        let data = try container.decode(EthereumTypedData.self)
        let password = try? container.decode(String.self)
        self.init(account: account, data: data, password: password)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(account)
        try container.encode(data)
        if let pwd = password {
            try container.encode(pwd)
        }
    }
}
