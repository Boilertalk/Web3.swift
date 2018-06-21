//
//  SolidityTuple.swift
//  Web3
//
//  Created by Josh Pyles on 6/13/18.
//

import Foundation

/// Wrapper for a tuple in Solidity
/// Use this instead of native Swift tuples when encoding
public struct SolidityTuple: ABIEncodable {
    
    var values: [SolidityWrappedValue]
    
    public init(_ values: SolidityWrappedValue...) {
        self.values = values
    }
    
    public init(_ values: [SolidityWrappedValue]) {
        self.values = values
    }
    
    public func abiEncode(dynamic: Bool) -> String? {
        return try? ABIEncoder.encode(values)
    }
}
