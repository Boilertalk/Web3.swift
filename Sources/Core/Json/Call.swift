//
//  EthereumCallParams.swift
//  Web3
//
//  Created by Koray Koska on 11.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public struct Call: Codable {

    /// The address the transaction is sent from.
    public let from: Address?

    /// The address the transaction is directed to.
    public let to: Address

    /// Integer of the gas provided for the transaction execution.
    /// `eth_call` consumes zero gas, but this parameter may be needed by some executions.
    public let gas: Quantity?

    /// Integer of the gasPrice used for each paid gas
    public let gasPrice: Quantity?

    /// Integer of the value send with this transaction
    public let value: Quantity?

    /// Hash of the method signature and encoded parameters.
    /// For details see https://github.com/ethereum/wiki/wiki/Ethereum-Contract-ABI
    public let data: DataObject?

    public init(
        from: Address? = nil,
        to: Address,
        gas: Quantity? = nil,
        gasPrice: Quantity? = nil,
        value: Quantity? = nil,
        data: DataObject? = nil
        ) {
        self.from = from
        self.to = to
        self.gas = gas
        self.gasPrice = gasPrice
        self.value = value
        self.data = data
    }
}

public struct EthereumCallParams: Codable {

    /// The actual call parameters
    public let call: Call

    /// The address the transaction is sent from.
    public var from: Address? {
        return call.from
    }

    /// The address the transaction is directed to.
    public var to: Address {
        return call.to
    }

    /// Integer of the gas provided for the transaction execution.
    /// `eth_call` consumes zero gas, but this parameter may be needed by some executions.
    public var gas: Quantity? {
        return call.gas
    }

    /// Integer of the gasPrice used for each paid gas
    public var gasPrice: Quantity? {
        return call.gasPrice
    }

    /// Integer of the value send with this transaction
    public var value: Quantity? {
        return call.value
    }

    /// Hash of the method signature and encoded parameters.
    /// For details see https://github.com/ethereum/wiki/wiki/Ethereum-Contract-ABI
    public var data: DataObject? {
        return call.data
    }

    /// Integer block number, or the string "latest", "earliest" or "pending"
    public let block: QuantityTag

    public init(
        call: Call,
        block: QuantityTag
    ) {
        self.call = call
        self.block = block
    }

    public init(
        from: Address? = nil,
        to: Address,
        gas: Quantity? = nil,
        gasPrice: Quantity? = nil,
        value: Quantity? = nil,
        data: DataObject? = nil,
        block: QuantityTag
        ) {
        let call = Call(from: from, to: to, gas: gas, gasPrice: gasPrice, value: value, data: data)
        self.init(call: call, block: block)
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        let call = try container.decode(Call.self)

        let block = try container.decode(QuantityTag.self)

        self.init(call: call, block: block)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()

        try container.encode(call)

        try container.encode(block)
    }
}

// MARK: - Equatable

extension Call: Equatable {

    public static func ==(_ lhs: Call, _ rhs: Call) -> Bool {
        return lhs.from == rhs.from
            && lhs.to == rhs.to
            && lhs.gas == rhs.gas
            && lhs.gasPrice == rhs.gasPrice
            && lhs.value == rhs.value
            && lhs.data == rhs.data
    }
}

extension EthereumCallParams: Equatable {

    public static func ==(_ lhs: EthereumCallParams, _ rhs: EthereumCallParams) -> Bool {
        return lhs.call == rhs.call && lhs.block == rhs.block
    }
}

// MARK: - Hashable

extension Call: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(to)
        hasher.combine(gas)
        hasher.combine(gasPrice)
        hasher.combine(value)
        hasher.combine(data)
    }
}

extension EthereumCallParams: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(call)
    }
}
