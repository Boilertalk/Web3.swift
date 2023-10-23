//
//  EthereumTypedDataParams.swift
//  Web3
//
import Foundation

public struct EthereumTypedData: Codable {
    public struct EIP712Domain: Codable {
        var name: String
        var version: String
        init(name: String, version: String) {
            self.name = name
            self.version = version
        }
    }

    public struct DomainType: Codable {
        var name: String
        var type: String
        init(name: String, type: String) {
            self.name = name
            self.type = type
        }
    }

    public struct TypedDataMessage: Codable {
        var holder: String
        var contractAddress: String
        var tokenId: BigUInt
        var environmentId: String
        init(holder: String, contractAddress: String, tokenId: BigUInt, environmentId: String) {
            self.holder = holder
            self.contractAddress = contractAddress
            self.tokenId = tokenId
            self.environmentId = environmentId
        }
    }

    public struct TypedData: Codable {
        var domain: EIP712Domain
        var message: TypedDataMessage
        var primaryType: String
        var types: [String: [DomainType]]
        init(domain: EIP712Domain, message: TypedDataMessage, primaryType: String, types: [String: [DomainType]]) {
            self.domain = domain
            self.message = message
            self.primaryType = primaryType
            self.types = types
        }

    }
    public let typedData: TypedData

    public init(
        typedData: TypedData
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
