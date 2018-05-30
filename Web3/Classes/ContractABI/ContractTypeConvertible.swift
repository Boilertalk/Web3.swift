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

    var isDynamic: Bool { get }

    func encoding() -> Bytes
}

public struct ContractTypeTuple: ContractTypeConvertible {

    let types: [ContractTypeConvertible]

    public let isDynamic: Bool

    public init(types: [ContractTypeConvertible]) {
        self.types = types
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
                bytes.append(contentsOf: offset.encoding())
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

    public let isDynamic: Bool

    public let types: [Type]

    public let count: UInt

    public init(types: [Type], count: UInt) {
        self.types = types
        self.count = count

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

    public let isDynamic: Bool

    public let types: [Type]

    public init(types: [Type]) {
        self.types = types
        self.isDynamic = true
    }

    public func encoding() -> Bytes {
        var bytes = Bytes()

        bytes.append(contentsOf: BigUInt(integerLiteral: UInt64(types.count)).encoding())
        bytes.append(contentsOf: ContractTypeTuple(types: types).encoding())

        return bytes
    }
}

// MARK: - Conveniences

extension BigUInt: ContractTypeConvertible {

    public var isDynamic: Bool {
        return false
    }

    public func encoding() -> Bytes {
        var bytes = makeBytes()
        if bytes.count < 32 {
            bytes.insert(contentsOf: Bytes.init(repeating: 0, count: 32 - bytes.count), at: 0)
        }
        return bytes
    }
}

extension UInt: ContractTypeConvertible {

    public var isDynamic: Bool {
        return false
    }

    public func encoding() -> Bytes {
        var bytes = makeBytes()
        if bytes.count < 32 {
            bytes.insert(contentsOf: Bytes.init(repeating: 0, count: 32 - bytes.count), at: 0)
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
            bytes.insert(contentsOf: Bytes.init(repeating: 0, count: 32 - bytes.count), at: 0)
        }
        return bytes
    }
}
