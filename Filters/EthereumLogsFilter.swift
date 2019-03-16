//
//  EthereumLogsFilter.swift
//  Web3
//
//  Created by Yehor Popovych on 3/16/19.
//

import Foundation

// Thread unsafe
public struct EthereumLogsFilter: EthereumLogsFilterProtocol {
    private var changes: Array<EthereumLogObject>
    
    
    public private(set) var lastFetched: Date
    
    public let fromBlock: EthereumQuantityTag?
    public let toBlock: EthereumQuantityTag?
    public let topics: Array<EthereumTopic>
    public let address: EthereumAddress?
    
    public init(
        fromBlock: EthereumQuantityTag? = nil,
        toBlock: EthereumQuantityTag? = nil,
        address: EthereumAddress? = nil,
        topics: [EthereumTopic] = []
    ) {
        self.lastFetched = Date(timeIntervalSinceNow: -1.0)
        self.changes = []
        self.topics = topics
        self.address = address
        self.fromBlock = fromBlock
        self.toBlock = toBlock
    }
    
    public mutating func getFilterChanges() -> [EthereumLogObject] {
        self.lastFetched = Date(timeIntervalSinceNow: 0.0)
        let changes = self.changes
        self.changes.removeAll()
        return changes
    }
    
    public mutating func apply(block: EthereumBlockObject, logs: Array<EthereumLogObject>) {
        if let from = self.fromBlock, case .block(let fromId) = from.tagType, fromId > block.number!.quantity {
            return
        }
        let topics = self.topics.enumerated()
        let filtered = logs.filter { obj in
            (self.address == nil || self.address == obj.address) && topics.reduce(true) { (prev, data) in
                let (index, elem) = data
                return prev && self.checkTopic(log: obj, index: index, topic: elem)
            }
        }
        self.changes.append(contentsOf: filtered)
    }
    
    private func checkTopic(log: EthereumLogObject, index: Int, topic: EthereumTopic) -> Bool {
        switch topic {
        case .any:
            return log.topics.count >= index
        case .exact(let data):
            return log.topics.count >= index && log.topics[index] == data
        case .or(let topics):
            return topics.enumerated().reduce(false) { (prev, data) in
                let (index, element) = data
                return prev || self.checkTopic(log: log, index: index, topic: element)
            }
        }
    }
}
