//
//  ContractTypeConvertible+Conveniences.swift
//  Web3
//
//  Created by Koray Koska on 31.05.18.
//

import Foundation
import BigInt
#if !Web3CocoaPods
import Web3
#endif

public struct ContractType {

    public static func tuple(_ types: [ContractTypeConvertible]) -> ContractTypeConvertible {
        return ContractTypeTuple(types: types)
    }

    public static func fixedArray<Type: ContractTypeConvertible>(abiType: ContractABIType, _ types: [Type]) -> ContractTypeConvertible {
        return ContractTypeFixedSizeArray(types: types, abiType: abiType)
    }

    public static func dynamicArray<Type: ContractTypeConvertible>(abiType: ContractABIType, _ types: [Type]) -> ContractTypeConvertible {
        return ContractTypeDynamicSizeArray(types: types, abiType: abiType)
    }

    public static func dynamicBytes(_ bytes: Bytes) -> ContractTypeConvertible {
        return ContractTypeDynamicSizeBytes(bytes: bytes)
    }

    public static func fixedBytes(_ bytes: Bytes) -> ContractTypeConvertible {
        return ContractTypeFixedSizeBytes(bytes: bytes)
    }

    public static func string(_ string: String) -> ContractTypeConvertible {
        return string
    }

    public static func uint(bits: UInt16, _ bigint: BigUInt) -> ContractTypeConvertible {
        return bigint.contractType(bits: bits)
    }

    public static func address(_ address: EthereumAddress) -> ContractTypeConvertible {
        return address
    }

    public static func bool(_ bool: Bool) -> ContractTypeConvertible {
        return bool
    }
}

// MARK: - Type extensions

public struct ContractTypeBigUInt: ContractTypeConvertible {

    public let parameterType: ContractFunctionDescription.FunctionParameter

    public let isDynamic = false

    public let bigUInt: BigUInt

    public init(bigUInt: BigUInt, bits: UInt16) {
        self.bigUInt = bigUInt
        self.parameterType = .init(name: "", type: .uint(bits: bits))
    }

    public func encoding() -> Bytes {
        var bytes = bigUInt.makeBytes()
        if bytes.count < 32 {
            bytes.insert(contentsOf: Bytes(repeating: 0, count: 32 - bytes.count), at: 0)
        }
        return bytes
    }
}

public struct ContractTypeBigInt: ContractTypeConvertible {

    public let parameterType: ContractFunctionDescription.FunctionParameter

    public let isDynamic = false

    public let bigInt: BigInt

    let bits: UInt16

    public init(bigInt: BigInt, bits: UInt16) {
        self.bigInt = bigInt
        self.bits = bits
        self.parameterType = .init(name: "", type: .int(bits: bits))
    }

    public func encoding() -> Bytes {
        if bigInt >= 0 {
            return bigInt.magnitude.contractType(bits: bits).encoding()
        } else {
            let twoComplement = (bigInt.magnitude ^ BigUInt(bytes: Bytes(repeating: 0xff, count: 32))) + 1
            var bytes = twoComplement.makeBytes()
            if bytes.count < 32 {
                bytes.append(contentsOf: Bytes(repeating: 0xff, count: 32 - bytes.count))
            }
            return bytes
        }
    }
}

public extension BigUInt {

    public func contractType(bits: UInt16) -> ContractTypeBigUInt {
        return ContractTypeBigUInt(bigUInt: self, bits: bits)
    }
}

public extension BigInt {

    public func contractType(bits: UInt16) -> ContractTypeBigInt {
        return ContractTypeBigInt(bigInt: self, bits: bits)
    }
}

public extension UInt {

    public func contractType(bits: UInt16) -> ContractTypeBigUInt {
        return ContractTypeBigUInt(bigUInt: BigUInt(self), bits: bits)
    }
}

public extension UInt64 {

    public func contractType(bits: UInt16) -> ContractTypeBigUInt {
        return ContractTypeBigUInt(bigUInt: BigUInt(self), bits: bits)
    }
}

public extension EthereumQuantity {

    public func contractType(bits: UInt16) -> ContractTypeBigUInt {
        return ContractTypeBigUInt(bigUInt: quantity, bits: bits)
    }
}

public extension Int {

    public func contractType(bits: UInt16) -> ContractTypeBigInt {
        return ContractTypeBigInt(bigInt: BigInt(self), bits: bits)
    }
}

public extension Int64 {

    public func contractType(bits: UInt16) -> ContractTypeBigInt {
        return ContractTypeBigInt(bigInt: BigInt(self), bits: bits)
    }
}

extension String: ContractTypeConvertible {

    public var parameterType: ContractFunctionDescription.FunctionParameter {
        return .init(name: "", type: .dynamicString)
    }

    public var isDynamic: Bool {
        return true
    }

    public func encoding() -> Bytes {
        let utf8 = data(using: .utf8)?.makeBytes() ?? []

        return ContractTypeDynamicSizeBytes(bytes: utf8).encoding()
    }
}

extension EthereumAddress: ContractTypeConvertible {

    public var parameterType: ContractFunctionDescription.FunctionParameter {
        return .init(name: "", type: .address)
    }

    public var isDynamic: Bool {
        return false
    }

    public func encoding() -> Bytes {
        return BigUInt(bytes: rawAddress).contractType(bits: 160).encoding()
    }
}

extension Bool: ContractTypeConvertible {

    public var parameterType: ContractFunctionDescription.FunctionParameter {
        return .init(name: "", type: .bool)
    }

    public var isDynamic: Bool {
        return false
    }

    public func encoding() -> Bytes {
        let bigInt: BigUInt = self ? 1 : 0

        return bigInt.contractType(bits: 8).encoding()
    }
}
