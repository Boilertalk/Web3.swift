//
//  EthereumGetLogsParams.swift
//  Web3
//
//  Created by Yehor Popovych on 3/15/19.
//

import Foundation

public struct EthereumGetLogsParams: Codable {
    let fromBlock: EthereumQuantityTag?
    
    let toBlock: EthereumQuantityTag?
    
    let address: EthereumAddress?
    
    let topics: [EthereumTopic]?
    
    let blockhash: EthereumData?
    
    public init(
        fromBlock: EthereumQuantityTag? = nil,
        toBlock: EthereumQuantityTag? = nil,
        address: EthereumAddress? = nil,
        topics: [EthereumTopic]? = nil,
        blockhash: EthereumData? = nil
    ) {
        self.fromBlock = fromBlock
        self.toBlock = toBlock
        self.address = address
        self.topics = topics
        self.blockhash = blockhash
    }
}

extension EthereumGetLogsParams: Equatable {
    
    public static func ==(_ lhs: EthereumGetLogsParams, _ rhs: EthereumGetLogsParams) -> Bool {
        return lhs.fromBlock == rhs.fromBlock
            && lhs.toBlock == rhs.toBlock
            && lhs.address == rhs.address
            && lhs.blockhash == rhs.blockhash
    }
}

