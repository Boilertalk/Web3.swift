//
//  EthereumPendingTransactionFilter.swift
//  Web3
//
//  Created by Yehor Popovych on 3/16/19.
//

import Foundation

// Thread unsafe
public struct EthereumPendingTransactionFilter: EthereumBlockFilterProtocol {
    public private(set) var lastFetched: Date
    
    private var changes: Array<EthereumData>
    
    public init() {
        self.lastFetched = Date(timeIntervalSinceNow: -1.0)
        self.changes = []
    }
    
    public mutating func getFilterChanges() -> [EthereumData] {
        self.lastFetched = Date(timeIntervalSinceNow: 0)
        let changes = self.changes
        self.changes.removeAll()
        return changes
    }
    
    public mutating func apply(block: EthereumBlockObject) {
        self.changes.removeAll()
        let txHashes = block.transactions.map { $0.hash! }
        self.changes.append(contentsOf: txHashes)
    }
}
