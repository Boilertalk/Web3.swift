//
//  ABIEncoder.swift
//  Web3
//
//  Created by Josh Pyles on 5/21/18.
//

import Foundation
import BigInt

class ABIEncoder {
    
    enum Error: Swift.Error {
        case couldNotEncode(type: SolidityType, value: Any)
    }
    
    struct Segment {
        let type: SolidityType
        let encodedValue: String
        
        init(type: SolidityType, value: String) {
            self.type = type
            self.encodedValue = value
        }
        
        /// Byte count of static value
        var staticLength: Int {
            if !type.isDynamic {
                // if we have a static value, return the length / 2 (assuming hex string)
                return encodedValue.count / 2
            }
            // otherwise, this will be an offset value, padded to 32 bytes
            return 32
        }
    }
    
    /// Encode pairs of values and expected types to Solidity ABI compatible string
    public class func encode(_ values: [SolidityWrappedValue]) throws -> String {
        // map segments
        let segments = try values.map { wrapped -> Segment in
            // encode value portion
            let encodedValue = try encode(wrapped.value, to: wrapped.type)
            return Segment(type: wrapped.type, value: encodedValue)
        }
        // calculate start of dynamic portion in bytes (combined length of all static parts)
        let dynamicOffsetStart = segments.map { $0.staticLength }.reduce(0, +)
        // reduce to static string and dynamic string
        let (staticValues, dynamicValues) = segments.reduce(("", ""), { result, segment in
            var (staticParts, dynamicParts) = result
            if !segment.type.isDynamic {
                staticParts += segment.encodedValue
            } else {
                // static portion for dynamic value represents offset in bytes
                // offset is start of dynamic segment + length of current dynamic portion (in bytes)
                let offset = dynamicOffsetStart + (result.1.count / 2)
                staticParts += String(offset, radix: 16).paddingLeft(toLength: 64, withPad: "0")
                dynamicParts += segment.encodedValue
            }
            return (staticParts, dynamicParts)
        })
        // combine as single string (static parts, then dynamic parts)
        return staticValues + dynamicValues
    }
    
    /// Encode with values inline
    public class func encode(_ values: SolidityWrappedValue...) throws -> String {
        return try encode(values)
    }
    
    /// Encode a single wrapped value
    public class func encode(_ wrapped: SolidityWrappedValue) throws -> String {
        return try encode([wrapped])
    }
    
    /// Encode a single value to a type
    public class func encode(_ value: ABIEncodable, to type: SolidityType) throws -> String {
        if let encoded = value.abiEncode(dynamic: type.isDynamic) {
            return encoded
        }
        throw Error.couldNotEncode(type: type, value: value)
    }
}
