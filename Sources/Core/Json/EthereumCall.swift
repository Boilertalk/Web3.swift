//
//  EthereumCallParams.swift
//  Web3
//
//  Created by Koray Koska on 11.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

public struct EthereumCall: Codable {

    /// The address the transaction is sent from.
    public let from: EthereumAddress?

    /// The address the transaction is directed to.
    public let to: EthereumAddress

    /// Integer of the gas provided for the transaction execution.
    /// `eth_call` consumes zero gas, but this parameter may be needed by some executions.
    public let gas: EthereumQuantity?

    /// Integer of the gasPrice used for each paid gas
    public let gasPrice: EthereumQuantity?

    /// Integer of the value send with this transaction
    public let value: EthereumQuantity?

    /// Hash of the method signature and encoded parameters.
    /// For details see https://github.com/ethereum/wiki/wiki/Ethereum-Contract-ABI
    public let data: EthereumData?

    public init(
        from: EthereumAddress? = nil,
        to: EthereumAddress,
        gas: EthereumQuantity? = nil,
        gasPrice: EthereumQuantity? = nil,
        value: EthereumQuantity? = nil,
        data: EthereumData? = nil
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
    public let call: EthereumCall

    /// The address the transaction is sent from.
    public var from: EthereumAddress? {
        return call.from
    }

    /// The address the transaction is directed to.
    public var to: EthereumAddress {
        return call.to
    }

    /// Integer of the gas provided for the transaction execution.
    /// `eth_call` consumes zero gas, but this parameter may be needed by some executions.
    public var gas: EthereumQuantity? {
        return call.gas
    }

    /// Integer of the gasPrice used for each paid gas
    public var gasPrice: EthereumQuantity? {
        return call.gasPrice
    }

    /// Integer of the value send with this transaction
    public var value: EthereumQuantity? {
        return call.value
    }

    /// Hash of the method signature and encoded parameters.
    /// For details see https://github.com/ethereum/wiki/wiki/Ethereum-Contract-ABI
    public var data: EthereumData? {
        return call.data
    }

    /// Integer block number, or the string "latest", "earliest" or "pending"
    public let block: EthereumQuantityTag

    public init(
        call: EthereumCall,
        block: EthereumQuantityTag
    ) {
        self.call = call
        self.block = block
    }

    public init(
        from: EthereumAddress? = nil,
        to: EthereumAddress,
        gas: EthereumQuantity? = nil,
        gasPrice: EthereumQuantity? = nil,
        value: EthereumQuantity? = nil,
        data: EthereumData? = nil,
        block: EthereumQuantityTag
        ) {
        let call = EthereumCall(from: from, to: to, gas: gas, gasPrice: gasPrice, value: value, data: data)
        self.init(call: call, block: block)
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        let call = try container.decode(EthereumCall.self)

        let block = try container.decode(EthereumQuantityTag.self)

        self.init(call: call, block: block)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()

        try container.encode(call)

        try container.encode(block)
    }
}

// MARK: - Equatable

extension EthereumCall: Equatable {

    public static func ==(_ lhs: EthereumCall, _ rhs: EthereumCall) -> Bool {
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

extension EthereumCall: Hashable {

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
