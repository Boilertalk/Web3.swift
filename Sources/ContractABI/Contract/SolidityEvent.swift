//
//  Event.swift
//  Web3
//
//  Created by Josh Pyles on 6/5/18.
//

import Foundation
import BigInt

/// An event that has been emitted by a contract
public struct SolidityEmittedEvent {
    public let name: String
    public let values: [String: Any]
    
    public init(name: String, values: [String: Any]) {
        self.name = name
        self.values = values
    }
}

/// Describes an event that can be emitted from a contract
public struct SolidityEvent {
    
    /// Represents a value stored with an event
    public struct Parameter: SolidityParameter {
        
        /// Name of the parameter
        public let name: String
        
        /// Type of the value
        public let type: SolidityType
        
        /// Used to describe a tuple's sub-parameters
        public let components: [SolidityParameter]?
        
        /// When indexed, a value will be included in the topics instead of the data
        /// of an EthereumLogObject. Dynamic types will be logged as a Keccak hash
        /// of their value instead of the actual value.
        public let indexed: Bool
        
        public init?(_ abi: ABIObject.Parameter) {
            self.name = abi.name
            let components = abi.components?.compactMap { Parameter($0) }
            let subTypes = components?.map { $0.type }
            guard let type = SolidityType(abi.type, subTypes: subTypes) else { return nil }
            self.type = type
            self.components = components
            self.indexed = abi.indexed ?? false
        }
        
        public init(name: String, type: SolidityType, indexed: Bool, components: [Parameter]? = nil) {
            self.name = name
            self.type = type
            self.components = components
            self.indexed = indexed
        }
    }
    
    /// Name of the event
    public let name: String
    
    /// When false, the log will include the the hashed signature as topics[0]
    public let anonymous: Bool
    
    
    /// The values expected to be returned with the event
    public let inputs: [Parameter]
    
    /// A string representing the signature of the event
    public var signature: String {
        return "\(name)(\(inputs.map { $0.type.stringValue }.joined(separator: ",")))"
    }
    
    private var indexedInputs: [Parameter] {
        return inputs.filter { $0.indexed }
    }
    
    private var nonIndexedInputs: [Parameter] {
        return inputs.filter { !$0.indexed }
    }
    
    public init?(abiObject: ABIObject) {
        guard abiObject.type == .event, let name = abiObject.name else { return nil }
        self.anonymous = abiObject.anonymous ?? false
        self.inputs = abiObject.inputs?.compactMap { Parameter($0) } ?? []
        self.name = name
    }
    
    public init(name: String, anonymous: Bool, inputs: [Parameter]) {
        self.name = name
        self.anonymous = anonymous
        self.inputs = inputs
    }
    
}

extension SolidityEvent: Hashable {
    
    public static func == (lhs: SolidityEvent, rhs: SolidityEvent) -> Bool {
        return lhs.signature == rhs.signature
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(signature)
    }
}
