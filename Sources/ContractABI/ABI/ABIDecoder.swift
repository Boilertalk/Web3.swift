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

public struct ABIDecoder {
    
    enum Error: Swift.Error {
        case typeNotSupported(type: SolidityType)
        case couldNotParseLength
        case doesNotMatchSignature(event: SolidityEvent, log: EthereumLogObject)
        case associatedTypeNotFound(type: SolidityType)
        case couldNotDecodeType(type: SolidityType, string: String)
        case unknownError

        case realisticIndexOutOfBounds
    }
    
    // MARK: - Decoding
    
    public static func decodeTuple(_ type: SolidityType, from hexString: String) throws -> Any {
        if let decoded = try decodeTuple([type], from: hexString).first {
            return decoded
        }
        throw Error.unknownError
    }
    
    public static func decodeTuple(_ types: SolidityType..., from hexString: String) throws -> [Any] {
        return try decodeTuple(types, from: hexString)
    }

    public static func decodeTuple(_ types: [SolidityType], from hexString: String) throws -> [Any] {
        struct BasicSolParam: SolidityParameter {
            let name: String
            let type: SolidityType
            let components: [SolidityParameter]?
        }

        var outputs = [SolidityParameter]()
        for i in 0..<types.count {
            outputs.append(BasicSolParam(name: "\(i)", type: types[i], components: nil))
        }

        let decodedDictionary = try decodeTuple(outputs: outputs, from: hexString)

        var outputArray = [Any]()

        for i in 0..<types.count {
            guard let el = decodedDictionary["\(i)"] else {
                throw Error.couldNotDecodeType(type: types[i], string: "decode unexpectedly returned nil")
            }
            outputArray.append(el)
        }

        return outputArray
    }
    
    public static func decodeTuple(outputs: [SolidityParameter], from hexString: String) throws -> [String: Any] {
        // See https://docs.soliditylang.org/en/develop/abi-spec.html#formal-specification-of-the-encoding

        let hexString = hexString.replacingOccurrences(of: "0x", with: "")

        var returnDictionary: [String: Any] = [:]

        var currentIndex = 0
        var tailsToBeParsed: [(dataLocation: Int, param: SolidityParameter)] = []
        for i in 0..<outputs.count {
            let output = outputs[i]

            if output.type.isDynamic {
                // Head
                let headStartIndex = hexString.index(hexString.startIndex, offsetBy: currentIndex)
                let headEndIndex = hexString.index(headStartIndex, offsetBy: 64)
                let subHex = String(hexString[headStartIndex..<headEndIndex])

                // More than Int.max doesn't make sense in any world. That's 2^63 - 1 bytes to read.
                guard let indexBigUInt = (try decodeType(type: .uint256, hexString: subHex)) as? BigUInt, indexBigUInt <= Int.max else {
                    throw Error.realisticIndexOutOfBounds
                }
                let dataLocation = Int(UInt(indexBigUInt))

                // Bump index (faster than removing)
                currentIndex += 64

                // Tails need to be parsed once we are done with the static parts (current block)
                tailsToBeParsed.append((dataLocation: dataLocation, param: output))
            } else {
                // Length as hex
                let length = Int(output.type.staticPartLength) * 2

                let startIndex = hexString.index(hexString.startIndex, offsetBy: currentIndex)
                let endIndex = hexString.index(startIndex, offsetBy: length)
                let subHex = String(hexString[startIndex..<endIndex])

                returnDictionary[output.name] = try decodeType(type: output.type, hexString: subHex, components: output.components)

                // Bump index (faster than removing)
                currentIndex += length
            }
        }

        // Tails

        let startIndexes = tailsToBeParsed.map({ $0.dataLocation })
        let endIndexes = Array(startIndexes.dropFirst() + [hexString.count / 2])
        let missingTails = tailsToBeParsed.map({ $0.param })

        for i in 0..<missingTails.count {
            let output = missingTails[i]

            // Index to start from in hex
            let tailStartIndex = hexString.index(hexString.startIndex, offsetBy: startIndexes[i] * 2)
            let tailEndIndex = hexString.index(hexString.startIndex, offsetBy: endIndexes[i] * 2)

            let subHex = String(hexString[tailStartIndex..<tailEndIndex])

            returnDictionary[output.name] = try decodeType(type: output.type, hexString: subHex, components: output.components)
        }

        return returnDictionary
    }

    private static func decodeType(type: SolidityType, hexString: String, components: [SolidityParameter]? = nil) throws -> Any {
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
                return try decodeTuple(outputs: components, from: hexString)
            } else {
                // just return the values
                return try decodeTuple(types, from: hexString)
            }
        }
    }
    
    // MARK: - Arrays
    
    private static func decodeArray(elementType: SolidityType, length: UInt?, from hexString: String) throws -> [Any] {
        if !elementType.isDynamic, let length = length {
            return try decodeFixedArray(elementType: elementType, length: Int(length), from: hexString)
        } else {
            return try decodeDynamicArray(elementType: elementType, from: hexString)
        }
    }
    
    private static func decodeDynamicArray(elementType: SolidityType, from hexString: String) throws -> [Any] {
        // split into parts
        let lengthString = hexString.substr(0, 64)
        let valueString = String(hexString.dropFirst(64))
        // calculate length
        guard let string = lengthString, let length = Int(string, radix: 16) else {
            throw Error.couldNotParseLength
        }
        return try decodeFixedArray(elementType: elementType, length: length, from: valueString)
    }
    
    private static func decodeFixedArray(elementType: SolidityType, length: Int, from hexString: String) throws -> [Any] {
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
    
    public static func decodeEvent(_ event: SolidityEvent, from log: EthereumLogObject) throws -> [String: Any] {
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
                    values[param.name] = try decodeTuple(param.type, from: topicData.hex())
                } else {
                    values[param.name] = topicData.hex()
                }
            }
        }
        // decode non-indexed values
        if nonIndexedParameters.count > 0 {
            for (key, value) in try decodeTuple(outputs: nonIndexedParameters, from: log.data.hex()) {
                values[key] = value
            }
        }
        return values
    }
}
