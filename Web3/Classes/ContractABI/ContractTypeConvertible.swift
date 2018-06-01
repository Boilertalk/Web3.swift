//
//  ContractTypeConvertible.swift
//  Web3
//
//  Created by Koray Koska on 30.05.18.
//

import Foundation
import BigInt
#if !Web3CocoaPods
import Web3
#endif

public protocol ContractTypeConvertible {

    var parameterType: ContractFunctionDescription.FunctionParameter { get }

    var isDynamic: Bool { get }

    func encoding() -> Bytes
}

public struct ContractTypeTuple: ContractTypeConvertible {

    public let types: [ContractTypeConvertible]

    public let parameterType: ContractFunctionDescription.FunctionParameter

    public let isDynamic: Bool

    public init(types: [ContractTypeConvertible]) {
        self.types = types
        self.parameterType = .init(name: "", type: .tuple, components: types.map { $0.parameterType })
        self.isDynamic = types.contains { $0.isDynamic }
    }

    public func encoding() -> Bytes {
        var bytes = Bytes()

        var types = self.types.map { (type: $0, encoding: $0.encoding()) }

        // Head part
        for i in 0..<types.count {
            let type = types[i]

            if type.type.isDynamic {
                // Offset
                var offset: BigUInt = 0
                for j in 0..<types.count {
                    let t = types[j]

                    // Offset for type heads
                    if t.type.isDynamic {
                        // Dynamic head is interpreted as uint256 (len(x) is always a uint256)
                        offset += 32
                    } else {
                        // Head of static types in the actual encoding
                        offset += BigUInt(integerLiteral: UInt64(t.encoding.count))
                    }

                    // Offset for type tails (only tails for types before current type)
                    if j < i && t.type.isDynamic {
                        offset += BigUInt(integerLiteral: UInt64(t.encoding.count))
                    }
                }
                bytes.append(contentsOf: offset.contractType(bits: 256).encoding())
            } else {
                bytes.append(contentsOf: type.encoding)
            }
        }

        // Tail part
        for i in 0..<types.count {
            let type = types[i]

            if isDynamic {
                bytes.append(contentsOf: type.encoding)
            } else {
                // Nothing. Static tail is empty
            }
        }

        return bytes
    }
}

public struct ContractTypeFixedSizeArray<Type: ContractTypeConvertible>: ContractTypeConvertible {

    public let parameterType: ContractFunctionDescription.FunctionParameter

    public let isDynamic: Bool

    public let types: [Type]

    public init(types: [Type], abiType: ContractABIType) {
        self.types = types
        self.parameterType = .init(name: "", type: .array(type: abiType, count: UInt(types.count)))

        if types.count < 1 {
            self.isDynamic = false
        } else {
            self.isDynamic = types[0].isDynamic
        }
    }

    public func encoding() -> Bytes {
        return ContractTypeTuple(types: types).encoding()
    }
}

public struct ContractTypeDynamicSizeArray<Type: ContractTypeConvertible>: ContractTypeConvertible {

    public let parameterType: ContractFunctionDescription.FunctionParameter

    public let isDynamic: Bool

    public let types: [Type]

    public init(types: [Type], abiType: ContractABIType) {
        self.types = types
        self.parameterType = .init(name: "", type: .dynamicArray(type: abiType))

        self.isDynamic = true
    }

    public func encoding() -> Bytes {
        var bytes = Bytes()

        bytes.append(contentsOf: BigUInt(integerLiteral: UInt64(types.count)).contractType(bits: 256).encoding())
        bytes.append(contentsOf: ContractTypeTuple(types: types).encoding())

        return bytes
    }
}

public struct ContractTypeDynamicSizeBytes: ContractTypeConvertible {

    public let parameterType: ContractFunctionDescription.FunctionParameter

    public let isDynamic = true

    public let bytes: Bytes

    public init(bytes: Bytes) {
        self.bytes = bytes
        self.parameterType = .init(name: "", type: .dynamicBytes)
    }

    public func encoding() -> Bytes {
        var bytes = Bytes()

        bytes.append(contentsOf: BigUInt(integerLiteral: UInt64(bytes.count)).contractType(bits: 256).encoding())

        var content = self.bytes
        if content.count % 32 != 0 {
            let padding = Bytes(repeating: 0, count: 32 - (content.count % 32))
            content.append(contentsOf: padding)
        }

        bytes.append(contentsOf: content)

        return bytes
    }
}

public struct ContractTypeFixedSizeBytes: ContractTypeConvertible {

    public let parameterType: ContractFunctionDescription.FunctionParameter

    public let isDynamic = false

    public let bytes: Bytes

    public init(bytes: Bytes) {
        var bytes = bytes
        if bytes.count > 32 {
            bytes = Array(bytes[0..<32])
        }
        self.bytes = bytes
        self.parameterType = .init(name: "", type: .bytes(count: UInt8(bytes.count)))
    }

    public func encoding() -> Bytes {
        var bytes = self.bytes

        if bytes.count < 32 {
            let padding = Bytes(repeating: 0, count: 32 - bytes.count)
            bytes.append(contentsOf: padding)
        }

        return bytes
    }
}
