//
//  EthereumFilterChangesObject.swift
//  Web3
//
//  Created by Yehor Popovych on 3/16/19.
//

import Foundation

public enum EthereumFilterChangesObject: Codable {
    case hashes([EthereumData])
    case logs([EthereumLogObject])
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let hashes = try? container.decode([EthereumData].self) {
            self = .hashes(hashes)
        } else {
            self = .logs(try container.decode([EthereumLogObject].self))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .hashes(let hashes):
            try container.encode(hashes)
        case .logs(let logs):
            try container.encode(logs)
        }
    }
}
