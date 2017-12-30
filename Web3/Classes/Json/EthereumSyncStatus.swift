//
//  EthereumSyncStatus.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation

public struct EthereumSyncStatus: Codable {

    /// The block at which the import started (will only be reset, after the sync reached his head)
    let startingBlock: String

    /// The current block, same as eth_blockNumber
    let currentBlock: String

    /// The estimated highest block
    let highestBlock: String
}
