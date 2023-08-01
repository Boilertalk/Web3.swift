//
//  EthereumSyncStatusObject.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//

import Foundation

public struct EthereumSyncStatusObject: Codable {

    /// True iff the peer is syncing right now. If false, all other values will be nil
    public let syncing: Bool

    /// The block at which the import started (will only be reset, after the sync reached his head)
    public let startingBlock: EthereumQuantity?

    /// The current block, same as eth_blockNumber
    public let currentBlock: EthereumQuantity?

    /// The estimated highest block
    public let highestBlock: EthereumQuantity?

    public enum CodingKeys: String, CodingKey {

        case startingBlock
        case currentBlock
        case highestBlock
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer() {
            self.syncing = try container.decode(Bool.self)
            self.startingBlock = nil
            self.currentBlock = nil
            self.highestBlock = nil
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            self.syncing = true
            self.startingBlock = try container.decode(EthereumQuantity.self, forKey: .startingBlock)
            self.currentBlock = try container.decode(EthereumQuantity.self, forKey: .currentBlock)
            self.highestBlock = try container.decode(EthereumQuantity.self, forKey: .highestBlock)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if !syncing {
            var container = encoder.singleValueContainer()
            try container.encode(syncing)
        } else {
            var container = encoder.container(keyedBy: CodingKeys.self)

            try container.encode(startingBlock, forKey: .startingBlock)
            try container.encode(currentBlock, forKey: .currentBlock)
            try container.encode(highestBlock, forKey: .highestBlock)
        }
    }
}
