//
//  ABIDecoder.swift
//  Web3
//
//  Created by Josh Pyles on 5/21/18.
//

import Foundation
import BigInt
#if !Web3CocoaPods
    import Web3
#endif

class ABIDecoder {
    
    enum Error: Swift.Error {
        case typeNotSupported(type: SolidityType)
        case couldNotParseLength
        case doesNotMatchSignature(event: SolidityEvent, log: EthereumLogObject)
        case associatedTypeNotFound(type: SolidityType)
        case couldNotDecodeType(type: SolidityType, string: String)
        case unknownError
    }
    
    struct Segment {
        let type: SolidityType
        let name: String?
        let components: [SolidityParameter]?
        var dynamicOffset: String.Index?
        let staticString: String
        var decodedValue: Any? = nil
        
        init(type: SolidityType, name: String? = nil, components: [SolidityParameter]? = nil, dynamicOffset: String.Index? = nil, staticString: String) {
            self.type = type
            self.name = name
            self.components = components
            self.dynamicOffset = dynamicOffset
            self.staticString = staticString
        }
        
        mutating func decode(from hexString: String, ranges: inout [Range<String.Index>]) throws {
            var substring = staticString
            if type.isDynamic {
                // We expect the value in the tail
                guard ranges.count > 0 else { throw Error.couldNotDecodeType(type: type, string: hexString) }
                let range = ranges.removeFirst()
                substring = String(hexString[range])
            }
            decodedValue = try decodeType(type: type, hexString: substring, components: components)
        }
    }
    
    // MARK: - Decoding
    
    public class func decode(_ type: SolidityType, from hexString: String) throws -> Any {
        if let decoded = try decode([type], from: hexString).first {
            return decoded
        }
        throw Error.unknownError
    }
    
    public class func decode(_ types: SolidityType..., from hexString: String) throws -> [Any] {
        return try decode(types, from: hexString)
    }
    
    public class func decode(_ types: [SolidityType], from hexString: String) throws -> [Any] {
        // Strip out leading 0x if included
        let hexString = hexString.replacingOccurrences(of: "0x", with: "")
        // Create segments
        let segments = (0..<types.count).compactMap { i -> Segment? in
            let type = types[i]
            if let staticPart = hexString.substr(i * 64, Int(type.staticPartLength) * 2) {
                var dynamicOffset: String.Index?
                if type.isDynamic, let offset = Int(staticPart, radix: 16) {
                    guard (offset * 2) < hexString.count else { return nil }
                    dynamicOffset = hexString.index(hexString.startIndex, offsetBy: offset * 2)
                }
                return Segment(type: type, dynamicOffset: dynamicOffset, staticString: staticPart)
            }
            return nil
        }
        let decoded = try decodeSegments(segments, from: hexString)
        return decoded.compactMap { $0.decodedValue }
    }
    
    public class func decode(outputs: [SolidityParameter], from hexString: String) throws -> [String: Any] {
        // Strip out leading 0x if included
        let hexString = hexString.replacingOccurrences(of: "0x", with: "")
        // Create segments
        let segments = (0..<outputs.count).compactMap { i -> Segment? in
            let type = outputs[i].type
            let name = outputs[i].name
            let components = outputs[i].components
            if let staticPart = hexString.substr(i * 64, Int(type.staticPartLength) * 2) {
                var dynamicOffset: String.Index?
                if type.isDynamic, let offset = Int(staticPart, radix: 16) {
                    dynamicOffset = hexString.index(hexString.startIndex, offsetBy: offset * 2)
                }
                return Segment(type: type, name: name, components: components, dynamicOffset: dynamicOffset, staticString: staticPart)
            }
            return nil
        }
        let decoded = try decodeSegments(segments, from: hexString)
        return decoded.reduce([String: Any]()) { input, segment in
            guard let name = segment.name else { return input }
            var dict = input
            dict[name] = segment.decodedValue
            return dict
        }
    }
    
    private class func decodeSegments(_ segments: [Segment], from hexString: String) throws -> [Segment] {
        // Calculate ranges for dynamic parts
        var ranges = getDynamicRanges(from: segments, forString: hexString)
        // Parse each segment
        return try segments.compactMap { segment in
            var segment = segment
            try segment.decode(from: hexString, ranges: &ranges)
            return segment
        }
    }
    
    private class func getDynamicRanges(from segments: [Segment], forString hexString: String) -> [Range<String.Index>] {
        let startIndexes = segments.compactMap { $0.dynamicOffset }
        let endIndexes = startIndexes.dropFirst() + [hexString.endIndex]
        return zip(startIndexes, endIndexes).map { start, end in
            return start..<end
        }
    }
    
    private class func decodeType(type: SolidityType, hexString: String, components: [SolidityParameter]? = nil) throws -> Any {
        switch type {
        case .type(let valueType):
            switch valueType {
            case .bytes(let length):
                var data: Data?
                if let length = length {
                    data = Data(hexString: hexString, length: length)
                } else {
                    data = Data(hexString: hexString)
                }
                guard let decoded = data else {
                    throw Error.couldNotDecodeType(type: type, string: hexString)
                }
                return decoded
            case .fixed:
                // Decimal doesn't support numbers large enough
                throw Error.typeNotSupported(type: type)
            case .ufixed:
                // Decimal doesn't support numbers large enough
                throw Error.typeNotSupported(type: type)
            default:
                if let nativeType = valueType.nativeType {
                    if let decodedValue = nativeType.init(hexString: hexString) {
                        return decodedValue
                    }
                    throw Error.couldNotDecodeType(type: type, string: hexString)
                }
                throw Error.associatedTypeNotFound(type: type)
            }
        case .array(let elementType, let length):
            return try decodeArray(elementType: elementType, length: length, from: hexString)
        case .tuple(let types):
            if let components = components {
                // will return with names
                return try decode(outputs: components, from: hexString)
            } else {
                // just return the values
                return try decode(types, from: hexString)
            }
        }
    }
    
    // MARK: - Arrays
    
    class func decodeArray(elementType: SolidityType, length: UInt?, from hexString: String) throws -> [Any] {
        if !elementType.isDynamic, let length = length {
            return try decodeFixedArray(elementType: elementType, length: Int(length), from: hexString)
        } else {
            return try decodeDynamicArray(elementType: elementType, from: hexString)
        }
    }
    
    private class func decodeDynamicArray(elementType: SolidityType, from hexString: String) throws -> [Any] {
        // split into parts
        let lengthString = hexString.substr(0, 64)
        let valueString = String(hexString.dropFirst(64))
        // calculate length
        guard let string = lengthString, let length = Int(string, radix: 16) else {
            throw Error.couldNotParseLength
        }
        return try decodeFixedArray(elementType: elementType, length: length, from: valueString)
    }
    
    private class func decodeFixedArray(elementType: SolidityType, length: Int, from hexString: String) throws -> [Any] {
        guard length > 0 else { return [] }
        let elementSize = hexString.count / length
        return try (0..<length).compactMap { n in
            if let elementString = hexString.substr(n * elementSize, elementSize) {
                return try decodeType(type: elementType, hexString: elementString)
            }
            return nil
        }
    }
    
    // MARK: Event Values
    
    static func decode(event: SolidityEvent, from log: EthereumLogObject) throws -> [String: Any] {
        typealias Param = SolidityEvent.Parameter
        var values = [String: Any]()
        // determine if this event is eligible to be decoded from this log
        var topics = log.topics.makeIterator()
        // anonymous events don't include their signature in the topics
        if !event.anonymous {
            if let signatureTopic = topics.next() {
                let eventSignature = ABI.encodeEventSignature(event)
                if signatureTopic.hex() != eventSignature {
                    throw Error.doesNotMatchSignature(event: event, log: log)
                }
            }
        }
        //split indexed and non-indexed parameters
        let splitParams: (([Param], [Param]), Param) -> ([Param], [Param]) = { accumulator, value in
            var (indexed, nonIndexed) = accumulator
            if value.indexed {
                indexed.append(value)
            } else {
                nonIndexed.append(value)
            }
            return (indexed, nonIndexed)
        }
        
        let (indexedParameters, nonIndexedParameters) = event.inputs.reduce(([], []), splitParams)
        // decode indexed values
        for param in indexedParameters {
            if let topicData = topics.next() {
                if !param.type.isDynamic {
                    values[param.name] = try decode(param.type, from: topicData.hex())
                } else {
                    values[param.name] = topicData.hex()
                }
            }
        }
        // decode non-indexed values
        if nonIndexedParameters.count > 0 {
            for (key, value) in try decode(outputs: nonIndexedParameters, from: log.data.hex()) {
                values[key] = value
            }
        }
        return values
    }
}
