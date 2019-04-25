//
//  Keychain+PromiseKit.swift
//  Web3
//
//  Created by Yehor Popovych on 4/25/19.
//

#if canImport(PromiseKit)

#if canImport(Web3PromiseKit)
    import Web3PromiseKit
#endif

// MARK: - Promisable and Guaranteeable

extension EthereumPrivateKey: Guaranteeable {}
extension EthereumPublicKey: Guaranteeable {}

#endif
