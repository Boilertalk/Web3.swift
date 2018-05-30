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

public extension ContractTypeConvertible {

    public static func tuple(_ types: [ContractTypeConvertible]) -> ContractTypeConvertible {
        return ContractTypeTuple(types: types)
    }

    public static func fixedArray<Type: ContractTypeConvertible>(_ types: [Type]) -> ContractTypeConvertible {
        return ContractTypeFixedSizeArray(types: types)
    }

    public static func dynamicArray<Type: ContractTypeConvertible>(_ types: [Type]) -> ContractTypeConvertible {
        return ContractTypeDynamicSizeArray(types: types)
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

    public static func uint(_ bigint: BigUInt) -> ContractTypeConvertible {
        return bigint
    }

    public static func address(_ address: EthereumAddress) -> ContractTypeConvertible {
        return address
    }

    public static func bool(_ bool: Bool) -> ContractTypeConvertible {
        return bool
    }
}

// MARK: - Type extensions

extension BigUInt: ContractTypeConvertible {

    public var isDynamic: Bool {
        return false
    }

    public func encoding() -> Bytes {
        var bytes = makeBytes()
        if bytes.count < 32 {
            bytes.insert(contentsOf: Bytes(repeating: 0, count: 32 - bytes.count), at: 0)
        }
        return bytes
    }
}

extension BigInt: ContractTypeConvertible {

    public var isDynamic: Bool {
        return false
    }

    public func encoding() -> Bytes {
        if self >= 0 {
            return magnitude.encoding()
        } else {
            let twoComplement = (magnitude ^ BigUInt(bytes: Bytes(repeating: 0xff, count: 32))) + 1
            var bytes = twoComplement.makeBytes()
            if bytes.count < 32 {
                bytes.append(contentsOf: Bytes(repeating: 0xff, count: 32 - bytes.count))
            }
            return bytes
        }
    }
}

extension UInt: ContractTypeConvertible {

    public var isDynamic: Bool{
        return false
    }

    public func encoding() -> Bytes {
        var bytes = makeBytes()
        if bytes.count < 32 {
            bytes.insert(contentsOf: Bytes(repeating: 0, count: 32 - bytes.count), at: 0)
        }
        return bytes
    }
}

extension UInt64: ContractTypeConvertible {

    public var isDynamic: Bool {
        return false
    }

    public func encoding() -> Bytes {
        var bytes = makeBytes()
        if bytes.count < 32 {
            bytes.insert(contentsOf: Bytes(repeating: 0, count: 32 - bytes.count), at: 0)
        }
        return bytes
    }
}

extension Int: ContractTypeConvertible {

    public var isDynamic: Bool{
        return false
    }

    public func encoding() -> Bytes {
        if self >= 0 {
            return UInt(self).encoding()
        } else {
            let twoComplement = (UInt(abs(self)) ^ UInt.max) + 1
            var bytes = twoComplement.makeBytes()
            if bytes.count < 32 {
                bytes.append(contentsOf: Bytes(repeating: 0xff, count: 32 - bytes.count))
            }
            return bytes
        }
    }
}

extension Int64: ContractTypeConvertible {

    public var isDynamic: Bool{
        return false
    }

    public func encoding() -> Bytes {
        if self >= 0 {
            return UInt64(self).encoding()
        } else {
            let twoComplement = (UInt64(abs(self)) ^ UInt64.max) + 1
            var bytes = twoComplement.makeBytes()
            if bytes.count < 32 {
                bytes.append(contentsOf: Bytes(repeating: 0xff, count: 32 - bytes.count))
            }
            return bytes
        }
    }
}

extension String: ContractTypeConvertible {

    public var isDynamic: Bool {
        return true
    }

    public func encoding() -> Bytes {
        let utf8 = data(using: .utf8)?.makeBytes() ?? []

        return ContractTypeDynamicSizeBytes(bytes: utf8).encoding()
    }
}

extension EthereumAddress: ContractTypeConvertible {

    public var isDynamic: Bool {
        return false
    }

    public func encoding() -> Bytes {
        return BigUInt(bytes: rawAddress).encoding()
    }
}

extension Bool: ContractTypeConvertible {

    public var isDynamic: Bool {
        return false
    }

    public func encoding() -> Bytes {
        let bigInt: BigUInt = self ? 1 : 0

        return bigInt.encoding()
    }
}
