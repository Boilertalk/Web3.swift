//
//  EthereumSyncStatusObject.swift
//  Web3
//
//  Created by Koray Koska on 30.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
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

    public init() {
        self.syncing = false
        self.startingBlock = nil
        self.currentBlock = nil
        self.highestBlock = nil
    }

    public init(startingBlock: EthereumQuantity, currentBlock: EthereumQuantity, highestBlock: EthereumQuantity) {
        self.startingBlock = startingBlock
        self.currentBlock = currentBlock
        self.highestBlock = highestBlock
        self.syncing = true
    }

    public enum CodingKeys: String, CodingKey {

        case startingBlock
        case currentBlock
        case highestBlock
    }

    public init(from decoder: Decoder) throws {
        if let container = try? decoder.singleValueContainer(), let syncing = try? container.decode(Bool.self) {
            self.syncing = syncing
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

// MARK: - Equatable

extension EthereumSyncStatusObject: Equatable {

    public static func ==(_ lhs: EthereumSyncStatusObject, _ rhs: EthereumSyncStatusObject) -> Bool {
        return lhs.syncing == rhs.syncing
            && lhs.startingBlock == rhs.startingBlock
            && lhs.currentBlock == rhs.currentBlock
            && lhs.highestBlock == rhs.highestBlock
    }
}

// MARK: - Hashable

extension EthereumSyncStatusObject: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(syncing)
        hasher.combine(startingBlock)
        hasher.combine(currentBlock)
        hasher.combine(highestBlock)
    }
}
