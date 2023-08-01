//
//  EthereumCallParams.swift
//  Web3
//
//  Created by Koray Koska on 11.02.18.
//

import Foundation

public struct EthereumCallParams: Codable {

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

    /// Integer block number, or the string "latest", "earliest" or "pending"
    public let block: EthereumQuantityTag

    public init(
        from: EthereumAddress? = nil,
        to: EthereumAddress,
        gas: EthereumQuantity? = nil,
        gasPrice: EthereumQuantity? = nil,
        value: EthereumQuantity? = nil,
        data: EthereumData? = nil,
        block: EthereumQuantityTag
    ) {
        self.from = from
        self.to = to
        self.gas = gas
        self.gasPrice = gasPrice
        self.value = value
        self.data = data
        self.block = block
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let callContainer = try container.nestedContainer(keyedBy: CodingKeys.self)

        let from = try callContainer.decodeIfPresent(EthereumAddress.self, forKey: .from)
        let to = try callContainer.decode(EthereumAddress.self, forKey: .to)
        let gas = try callContainer.decodeIfPresent(EthereumQuantity.self, forKey: .gas)
        let gasPrice = try callContainer.decodeIfPresent(EthereumQuantity.self, forKey: .gasPrice)
        let value = try callContainer.decodeIfPresent(EthereumQuantity.self, forKey: .value)
        let data = try callContainer.decodeIfPresent(EthereumData.self, forKey: .data)

        let block = try container.decode(EthereumQuantityTag.self)

        self.init(from: from, to: to, gas: gas, gasPrice: gasPrice, value: value, data: data, block: block)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()
        var callContainer = container.nestedContainer(keyedBy: CodingKeys.self)

        try callContainer.encodeIfPresent(from, forKey: .from)
        try callContainer.encode(to, forKey: .to)
        try callContainer.encodeIfPresent(gas, forKey: .gas)
        try callContainer.encodeIfPresent(gasPrice, forKey: .gasPrice)
        try callContainer.encodeIfPresent(value, forKey: .value)
        try callContainer.encodeIfPresent(data, forKey: .data)

        try container.encode(block)
    }

    public enum CodingKeys: String, CodingKey {

        case from, to, gas, gasPrice, value, data
    }
}
