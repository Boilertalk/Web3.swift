//
//  ERC165.swift
//  Web3
//
//  Created by Josh Pyles on 6/19/18.
//

import Foundation

/// ERC165
public protocol ERC165Contract: EthereumContract {
    func supportsInterface(interface: String) -> SolidityInvocation
}

public extension ERC165Contract {
    
    /// Determine if a contract supports the given interface
    ///
    /// - Parameter interface: first 4 bytes of keccak hash of the interface, expressed as a string (ex: "0x01ffc9a7")
    /// - Returns: Invocation for this method with the interface
    func supportsInterface(interface: String) -> SolidityInvocation {
        let inputs = [SolidityFunctionParameter(name: "_interface", type: .bytes(length: 4))]
        let outputs = [SolidityFunctionParameter(name: "_supportsInterface", type: .bool)]
        let method = SolidityConstantFunction(name: "supportsInterface", inputs: inputs, outputs: outputs, handler: self)
        let interfaceData = Data(hex: interface)
        return method.invoke(interfaceData)
    }
    
}
