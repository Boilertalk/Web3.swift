//
//  Eth+ABI.swift
//  Web3
//
//  Created by Josh Pyles on 6/18/18.
//

import Foundation
#if !Web3CocoaPods
    import Web3
#endif

public extension Web3.Eth {
    
    /// The struct holding all `abi` methods
    var abi: ABI.Type {
        return ABI.self
    }
    
}
