//
//  EthereumLogObject.swift
//  Web3
//
//  Created by Koray Koska on 31.12.17.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public struct LogObject: Codable {

    /// true when the log was removed, due to a chain reorganization. false if its a valid log.
    public let removed: Bool?

    /// Integer of the log index position in the block. nil when its pending log.
    public let logIndex: Quantity?

    /// Integer of the transactions index position log was created from. nil when its pending log.
    public let transactionIndex: Quantity?

    /// 32 Bytes - hash of the transactions this log was created from. nil when its pending log.
    public let transactionHash: DataObject?

    /// 32 Bytes - hash of the block where this log was in. nil when its pending. nil when its pending log.
    public let blockHash: DataObject?

    /// The block number where this log was in. nil when its pending. nil when its pending log.
    public let blockNumber: Quantity?

    /// 20 Bytes - address from which this log originated.
    public let address: Address

    /// Contains one or more 32 Bytes non-indexed arguments of the log.
    public let data: DataObject

    /**
     * Array of 0 to 4 32 Bytes DATA of indexed log arguments.
     *
     * In solidity: The first topic is the hash of the signature of the event (e.g. Deposit(address,bytes32,uint256))
     * except you declared the event with the anonymous specifier.)
     */
    public let topics: [DataObject]
}

// MARK: - Equatable

extension LogObject: Equatable {

    public static func ==(_ lhs: LogObject, _ rhs: LogObject) -> Bool {
        return lhs.removed == rhs.removed
            && lhs.logIndex == rhs.logIndex
            && lhs.transactionIndex == rhs.transactionIndex
            && lhs.transactionHash == rhs.transactionHash
            && lhs.blockHash == rhs.blockHash
            && lhs.blockNumber == rhs.blockNumber
            && lhs.address == rhs.address
            && lhs.data == rhs.data
            && lhs.topics == rhs.topics
    }
}

// MARK: - Hashable

extension LogObject: Hashable {

    public func hash(into hasher: inout Hasher) {
        var removedBytes: UInt8?
        if let removed = self.removed {
            removedBytes = removed ? UInt8(0x01) : UInt8(0x00)
        }
        var arr: [BytesRepresentable?] = [
            removedBytes, logIndex, transactionIndex, transactionHash, blockHash, blockNumber,
            address, data
        ]
        for t in topics {
            arr.append(t)
        }

        for bytes in arr {
            // TODO: Is throwing deterministic here?
            try? hasher.combine(bytes?.makeBytes())
        }
    }
}
