//
//  EthereumTopic.swift
//  Web3
//
//  Created by Yehor Popovych on 3/15/19.
//

import Foundation

public enum EthereumTopic: EthereumValueConvertible, Equatable {
    case any
    case exact(EthereumData)
    case or([EthereumTopic])
    
    public func ethereumValue() -> EthereumValue {
        switch self {
        case .any: return EthereumValue(valueType: .nil)
        case .exact(let data): return data.ethereumValue()
        case .or(let topics): return EthereumValue(array: topics)
        }
    }
    
    public init(ethereumValue: EthereumValue) throws {
        switch ethereumValue.valueType {
        case .array(let values):
            self = .or(try values.map { try EthereumTopic(ethereumValue: $0) })
        case .nil:
            self = .any
        case .string(let hex):
            self = .exact(try EthereumData.string(hex))
        default:
            throw EthereumValueInitializableError.notInitializable
        }
    }
}

extension EthereumValue {
    public var topic: EthereumTopic? {
        return try? EthereumTopic(ethereumValue: self)
    }
    
    public var topics: [EthereumTopic]? {
        guard let array = self.array else {
            return nil
        }
        return try? array.map { try EthereumTopic(ethereumValue: $0) }
    }
}

