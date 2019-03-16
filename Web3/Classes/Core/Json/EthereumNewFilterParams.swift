//
//  EthereumNewFilterParams.swift
//  Web3
//
//  Created by Yehor Popovych on 3/16/19.
//

import Foundation

public struct EthereumNewFilterParams: Codable {
    let fromBlock: EthereumQuantityTag?
    
    let toBlock: EthereumQuantityTag?
    
    let address: EthereumAddress?
    
    let topics: [EthereumTopic]?
    
    public init(
        fromBlock: EthereumQuantityTag? = nil,
        toBlock: EthereumQuantityTag? = nil,
        address: EthereumAddress? = nil,
        topics: [EthereumTopic]? = nil
    ) {
        self.fromBlock = fromBlock
        self.toBlock = toBlock
        self.address = address
        self.topics = topics
    }
}

extension EthereumNewFilterParams: Equatable {
    public static func ==(_ lhs: EthereumNewFilterParams, _ rhs: EthereumNewFilterParams) -> Bool {
        return lhs.fromBlock == rhs.fromBlock
            && lhs.toBlock == rhs.toBlock
            && lhs.address == rhs.address
            && lhs.topics == rhs.topics
    }
}

