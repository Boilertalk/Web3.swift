//
//  Eth+Contract.swift
//  Web3
//
//  Created by Josh Pyles on 6/18/18.
//

import Foundation
#if !Web3CocoaPods
    import Web3
#endif

public enum ContractParsingError: Error, LocalizedError {
    case invalidKey
    
    public var localizedDescription: String {
        switch self {
        case .invalidKey:
            return "ABI not found at the provided key."
        }
    }
}

public extension Web3.Eth {
    
    /// Initialize an instance of a dynamic EthereumContract from data
    ///
    /// - Parameters:
    ///   - data: JSON ABI data from compiled contract
    ///   - abiKey: The top level key for the array of ABI objects, if it is nested within the JSON object.
    ///   - name: Name of this contract instance
    ///   - address: The address of the contract, if it is deployed
    /// - Returns: Instance of the dynamic contract from the data provided
    /// - Throws: Error when the ABI data cannot be decoded
    func Contract(json data: Data, abiKey: String?, address: EthereumAddress?) throws -> DynamicContract {
        let decoder = JSONDecoder()
        // Many tools generate a JSON file or response that includes the actual ABI nested under another key
        if let key = abiKey {
            let containerObject = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            if let nestedObject = containerObject?[key] {
                let nestedData = try JSONSerialization.data(withJSONObject: nestedObject, options: [])
                let abi = try decoder.decode([ABIObject].self, from: nestedData)
                return Contract(abi: abi, address: address)
            }
            throw ContractParsingError.invalidKey
        } else {
            let abi = try decoder.decode([ABIObject].self, from: data)
            return Contract(abi: abi, address: address)
        }
    }
    
    /// Initialize an instance of a dynamic EthereumContract from data
    ///
    /// - Parameters:
    ///   - abi: the ABIObjects parsed from the JSON
    ///   - name: Name of your contract instance
    ///   - address: The address of the contract, if it is deployed
    /// - Returns: Instance of the dynamic contract as represented in the provided ABI
    func Contract(abi: [ABIObject], address: EthereumAddress? = nil) -> DynamicContract {
        return DynamicContract(abi: abi, address: address, eth: self)
    }
    
    
    /// Initialize an instance of a staticly typed EthereumContract
    ///
    /// - Parameters:
    ///   - type: The contract type to initialize. Must conform to `StaticContract`
    ///   - address: Address the contract is deployed at, if it is deployed
    /// - Returns: An instance of the contract that is configured with this instance of Web3
    func Contract<T: StaticContract>(type: T.Type, address: EthereumAddress? = nil) -> T {
        return T(address: address, eth: self)
    }
    
}
