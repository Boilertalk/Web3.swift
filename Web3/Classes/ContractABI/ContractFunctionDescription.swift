//
//  ContractFunctionDescription.swift
//  Web3
//
//  Created by Koray Koska on 30.05.18.
//

import Foundation

public struct ContractFunctionDescription: Codable {

    public enum FunctionType: String, Codable {

        case function
        case constructor
        case fallback
    }

    public struct FunctionParameter: Codable {

        public let name: String

        public let type: ContractABIType

        public let components: [FunctionParameter]?

        public init(name: String, type: ContractABIType, components: [FunctionParameter]? = nil) {
            self.name = name
            self.type = type
            self.components = components
        }

        public var signatureTypeString: String {
            switch type {
            case .tuple:
                var selector = "("
                for c in components ?? [] {
                    selector += "\(c.signatureTypeString),"
                }
                if selector.hasSuffix(",") {
                    selector = String(selector.dropLast())
                }
                selector += ")"

                return selector
            default:
                return type.string
            }
        }
    }

    public enum StateMutability: String, Codable {

        case pure
        case view
        case nonpayable
        case payable
    }

    // MARK: - Properties

    public let type: FunctionType

    public let name: String?

    public let inputs: [FunctionParameter]

    public let outputs: [FunctionParameter]

    public let payable: Bool

    public let stateMutability: StateMutability?

    public let constant: Bool

    // MARK: - Initialization

    public init(
        type: FunctionType = .function,
        name: String? = nil,
        inputs: [FunctionParameter] = [],
        outputs: [FunctionParameter] = [],
        payable: Bool = false,
        stateMutability: StateMutability
    ) {
        self.type = type
        self.name = name
        self.inputs = inputs
        self.outputs = outputs
        self.payable = payable
        self.stateMutability = stateMutability
        self.constant = stateMutability == .pure || stateMutability == .view
    }

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {

        case type
        case name
        case inputs
        case outputs
        case payable
        case stateMutability
        case constant
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decodeIfPresent(FunctionType.self, forKey: .type) ?? .function
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.inputs = try container.decodeIfPresent([FunctionParameter].self, forKey: .inputs) ?? []
        self.outputs = try container.decodeIfPresent([FunctionParameter].self, forKey: .outputs) ?? []
        self.payable = try container.decodeIfPresent(Bool.self, forKey: .payable) ?? false
        self.stateMutability = try container.decode(StateMutability.self, forKey: .stateMutability)
        self.constant = try container.decode(Bool.self, forKey: .constant)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(type, forKey: .type)
        try container.encode(name, forKey: .name)
        try container.encode(inputs, forKey: .inputs)
        try container.encode(outputs, forKey: .outputs)
        try container.encode(payable, forKey: .payable)
        try container.encode(stateMutability, forKey: .stateMutability)
        try container.encode(constant, forKey: .constant)
    }
}

// MARK: - Equatable

extension ContractFunctionDescription.FunctionParameter: Equatable {

    public static func == (lhs: ContractFunctionDescription.FunctionParameter, rhs: ContractFunctionDescription.FunctionParameter) -> Bool {
        return lhs.name == rhs.name && lhs.type == rhs.type && lhs.components == rhs.components
    }
}

extension ContractFunctionDescription: Equatable {

    public static func == (lhs: ContractFunctionDescription, rhs: ContractFunctionDescription) -> Bool {
        return lhs.type == rhs.type &&
            lhs.name == rhs.name &&
            lhs.inputs == rhs.inputs &&
            lhs.outputs == rhs.outputs &&
            lhs.payable == rhs.payable &&
            lhs.stateMutability == rhs.stateMutability &&
            lhs.constant == rhs.constant
    }
}
