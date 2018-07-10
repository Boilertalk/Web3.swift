//
//  ABIObject.swift
//  Web3.swift
//
//  Created by Josh Pyles on 6/1/18.
//

import Foundation

/// Container for data about a function or event within a contract
public struct ABIObject: Codable {
    
    /// Represents the ability for a method to be able to influence state of the contract
    public enum StateMutability: String, Codable {
        //specified not to read blockchain state
        //http://solidity.readthedocs.io/en/v0.4.21/contracts.html#pure-functions
        case pure
        //specified not to modify blockchain state
        //http://solidity.readthedocs.io/en/v0.4.21/contracts.html#view-functions
        case view
        // does not accept ether
        case nonpayable
        // accepts ether
        case payable
        
        var isConstant: Bool {
            return self == .pure || self == .view
        }
    }
    
    /// Represents the type of the ABIObject
    ///
    /// - event: An event object. Emitted from sending transactions to the contract.
    /// - function: A function object
    /// - constructor: A constructor method for a contract
    /// - fallback: The fallback function for a contract (executed whenever eth is sent)
    public enum ObjectType: String, Codable {
        // event
        case event
        
        // normal function
        case function
        
        // constructor function. can't have name or outputs
        case constructor
        
        // http://solidity.readthedocs.io/en/v0.4.21/contracts.html#fallback-function
        case fallback
    }
    
    /// Represents a value passed into our returned from a method or event
    public struct Parameter: Codable {
        let name: String
        let type: String
        let components: [Parameter]?
        let indexed: Bool?
    }
    
    // true if function is pure or view
    let constant: Bool?
    
    // input parameters
    let inputs: [Parameter]?
    
    // output parameters
    let outputs: [Parameter]?
    
    // name of the function or event (not available for fallback or constructor functions)
    let name: String?
    
    // type of function (constructor, function, or fallback) or event
    // can be omitted, defaulting to function
    // constructors never have name or outputs
    // fallback function never has name outputs or inputs
    let type: ObjectType
    
    // true if function accepts ether
    let payable: Bool?
    
    // whether or not this function reads, writes, and accepts payment
    let stateMutability: StateMutability?
    
    // true if the event was declared as anonymous
    let anonymous: Bool?
    
    public init(decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.constant = try container.decodeIfPresent(Bool.self, forKey: .constant)
        self.inputs = try container.decode([Parameter].self, forKey: .inputs)
        self.outputs = try container.decodeIfPresent([Parameter].self, forKey: .outputs)
        self.name = try container.decodeIfPresent(String.self, forKey: .name)
        self.type = try container.decodeIfPresent(ObjectType.self, forKey: .type) ?? .function
        self.payable = try container.decodeIfPresent(Bool.self, forKey: .payable) ?? false
        self.stateMutability = try container.decodeIfPresent(StateMutability.self, forKey: .stateMutability)
        self.anonymous = try container.decodeIfPresent(Bool.self, forKey: .anonymous)
    }
}
