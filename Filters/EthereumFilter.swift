//
//  EthereumFilter.swift
//  Web3
//
//  Created by Yehor Popovych on 3/16/19.
//

import Foundation

public protocol EthereumBlockFilterProtocol {
    // last get changes date from this event. For auto destroying
    var lastFetched: Date { get }
    
    // Should empty events and update lastUpdated
    mutating func getFilterChanges() -> [EthereumData]
    
    // New events arrived. Should filter them and add to internal events list if needed
    mutating func apply(block: EthereumBlockObject)
}

public protocol EthereumLogsFilterProtocol {
    
    // Parameters
    var fromBlock: EthereumQuantityTag? { get }
    var toBlock: EthereumQuantityTag? { get }
    var address: EthereumAddress? { get }
    var topics: Array<EthereumTopic> { get }
    
    // last get changes date from this event. For auto destroying
    var lastFetched: Date { get }
    
    // Should empty events and update lastUpdated
    mutating func getFilterChanges() -> [EthereumLogObject]
    
    // New events arrived. Should filter them and add to internal events list if needed
    mutating func apply(block: EthereumBlockObject, logs: Array<EthereumLogObject>)
}
