//
//  ContractEventDescription.swift
//  Web3
//
//  Created by Koray Koska on 30.05.18.
//

import Foundation

public struct ContractEventDescription: Codable {

    public enum EventType: String, Codable {

        case event
    }

    public struct EventParameter: Codable {

        public let name: String

        public let type: ContractABIType

        public let components: [EventParameter]?

        public let indexed: Bool

        public init(name: String, type: ContractABIType, components: [EventParameter]? = nil, indexed: Bool) {
            self.name = name
            self.type = type
            self.components = components
            self.indexed = indexed
        }
    }

    // MARK: - Properties

    public let type: EventType

    public let name: String

    public let inputs: [EventParameter]

    public let anonymous: Bool

    // MARK: - Initialization

    public init(type: EventType = .event, name: String, inputs: [EventParameter], anonymous: Bool) {
        self.type = type
        self.name = name
        self.inputs = inputs
        self.anonymous = anonymous
    }
}

// MARK: - Equatable

extension ContractEventDescription.EventParameter: Equatable {

    public static func == (lhs: ContractEventDescription.EventParameter, rhs: ContractEventDescription.EventParameter) -> Bool {
        return lhs.name == rhs.name && lhs.type == rhs.type && lhs.components == rhs.components && lhs.indexed == rhs.indexed
    }
}

extension ContractEventDescription: Equatable {

    public static func == (lhs: ContractEventDescription, rhs: ContractEventDescription) -> Bool {
        return lhs.type == rhs.type && lhs.name == rhs.name && lhs.inputs == rhs.inputs && lhs.anonymous == rhs.anonymous
    }
}
