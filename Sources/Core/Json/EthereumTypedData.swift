//
//  EthereumTypedDataParams.swift
//  Web3
//
import Foundation

public struct EthereumTypedData: Codable {
    public struct EIP712Domain: Codable {
        var name: String
        var version: String
    }

    public struct DomainType: Codable {
        var name: String
        var type: String
    }

    public struct Pass: Codable {
        var holder: String
        var contractAddress: String
        var tokenId: BigUInt
        var environmentId: String
    }

    public struct TypedDataMessage: Codable {
        var domain: EIP712Domain
        var message: Pass
        var primaryType: String
        var types: [String: [DomainType]]
    }
    public let typedData: TypedDataMessage

    public init(
        typedData: TypedDataMessage
    ) {
        self.typedData = typedData
    }

}
public struct EthereumTypedDataParams: Codable {

    /// The actual call parameters
    public let typedData: EthereumTypedData

    public let address: EthereumAddress

    public init(
        typedData: EthereumTypedData,
        address: EthereumAddress
    ) {
        self.typedData = typedData
        self.address = address
    }

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()

        let typedData = try container.decode(EthereumTypedData.self)

        let address = try container.decode(EthereumAddress.self)

        self.init(typedData: typedData, address: address)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.unkeyedContainer()

        try container.encode(typedData)

        try container.encode(address)
    }
}
