//
//  ContractDescriptionElement.swift
//  Web3
//
//  Created by Koray Koska on 30.05.18.
//

import Foundation

public enum ContractDescriptionElement: Codable {

    case event(description: ContractEventDescription)

    case function(description: ContractFunctionDescription)

    // MARK: - Codable

    enum CodingKeys: String, CodingKey {

        case type
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        if try container.decodeIfPresent(String.self, forKey: .type) == "event" {
            let description = try ContractEventDescription(from: decoder)
            self = .event(description: description)
        } else {
            let description = try ContractFunctionDescription(from: decoder)
            self = .function(description: description)
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .event(let description):
            try description.encode(to: encoder)
        case .function(let description):
            try description.encode(to: encoder)
        }
    }
}

// MARK: - Equatable

extension ContractDescriptionElement: Equatable {

    public static func == (lhs: ContractDescriptionElement, rhs: ContractDescriptionElement) -> Bool {
        switch lhs {
        case .event(let description):
            if case .event(let rDescription) = rhs {
                return description == rDescription
            }
            return false
        case .function(let description):
            if case .function(let rDescription) = rhs {
                return description == rDescription
            }
            return false
        }
    }
}

// MARK: - Conveniences

public extension ContractDescriptionElement {

    public var functionDescription: ContractFunctionDescription? {
        switch self {
        case .function(let description):
            return description
        default:
            return nil
        }
    }

    public var eventDescription: ContractEventDescription? {
        switch self {
        case .event(let description):
            return description
        default:
            return nil
        }
    }
}

public extension Array where Element == ContractDescriptionElement {

    public func findFunctionDescription(with name: String) -> ContractFunctionDescription? {
        for element in self {
            if let description = element.functionDescription, description.name == name {
                return description
            }
        }

        return nil
    }

    public var functionDescriptions: [ContractFunctionDescription] {
        return self.compactMap { element in
            switch element {
            case .function(let description):
                return description
            case .event(_):
                return nil
            }
        }
    }

    public var eventDescriptions: [ContractEventDescription] {
        return self.compactMap { element in
            switch element {
            case .function(_):
                return nil
            case .event(let description):
                return description
            }
        }
    }
}
