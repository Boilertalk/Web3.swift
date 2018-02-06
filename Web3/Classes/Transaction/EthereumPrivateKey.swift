//
//  EthereumPrivateKey.swift
//  Web3
//
//  Created by Koray Koska on 06.02.18.
//

import Foundation
import VaporBytes
import secp256k1_ios
import Security

public class EthereumPrivateKey {

    // MARK: - Properties

    public let rawPrivateKey: Bytes

    private let ctx: OpaquePointer

    // MARK: - Initialization

    public init(privateKey: Bytes) throws {
        guard privateKey.count == 32 else {
            throw Error.keyMalformed
        }
        self.rawPrivateKey = privateKey

        let c = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN) | UInt32(SECP256K1_CONTEXT_VERIFY))
        guard let ctx = c else {
            throw Error.internalError
        }

        var rand = Bytes(repeating: 0, count: 32)
        guard SecRandomCopyBytes(kSecRandomDefault, 32, &rand) == errSecSuccess else {
            throw Error.internalError
        }

        guard secp256k1_context_randomize(ctx, &rand) == 1 else {
            throw Error.internalError
        }
        self.ctx = ctx

        // Verify private key
        try verifyPrivateKey()
    }

    public convenience init(hexPrivateKey: String) throws {
        guard hexPrivateKey.count == 64 || hexPrivateKey.count == 66 else {
            throw Error.keyMalformed
        }

        var hexPrivateKey = hexPrivateKey

        if hexPrivateKey.count == 66 {
            let s = hexPrivateKey.index(hexPrivateKey.startIndex, offsetBy: 0)
            let e = hexPrivateKey.index(hexPrivateKey.startIndex, offsetBy: 2)
            let prefix = String(hexPrivateKey[s..<e])

            guard prefix == "0x" else {
                throw Error.keyMalformed
            }

            // Remove prefix
            hexPrivateKey = String(hexPrivateKey[e...])
        }

        var raw = Bytes()
        for i in stride(from: 0, to: hexPrivateKey.count, by: 2) {
            let s = hexPrivateKey.index(hexPrivateKey.startIndex, offsetBy: i)
            let e = hexPrivateKey.index(hexPrivateKey.startIndex, offsetBy: i + 2)

            guard let b = Byte(String(hexPrivateKey[s..<e]), radix: 16) else {
                throw Error.keyMalformed
            }
            raw.append(b)
        }

        try self.init(privateKey: raw)
    }

    // MARK: - Convenient functions

    public func publicKey() throws -> Bytes {
        guard let ctx = secp256k1_context_create(UInt32(SECP256K1_CONTEXT_SIGN)) else {
            throw Error.pubKeyGenerationFailed
        }

        // Cleanup
        defer {
            secp256k1_context_destroy(ctx)
        }

        guard let pubKey = malloc(MemoryLayout<secp256k1_pubkey>.size)?.assumingMemoryBound(to: secp256k1_pubkey.self) else {
            throw Error.pubKeyGenerationFailed
        }

        // Cleanup
        defer {
            free(pubKey)
        }

        var secret = rawPrivateKey

        let result = secp256k1_ec_pubkey_create(ctx, pubKey, &secret)

        if result != 1 {
            throw Error.keyMalformed
        }

        let rawPK = pubKey.pointee.data
        let pk: Bytes = [
            rawPK.0, rawPK.1, rawPK.2, rawPK.3, rawPK.4, rawPK.5, rawPK.6, rawPK.7,
            rawPK.8, rawPK.9, rawPK.10, rawPK.11, rawPK.12, rawPK.13, rawPK.14, rawPK.15,
            rawPK.16, rawPK.17, rawPK.18, rawPK.19, rawPK.20, rawPK.21, rawPK.22, rawPK.23,
            rawPK.24, rawPK.25, rawPK.26, rawPK.27, rawPK.28, rawPK.29, rawPK.30, rawPK.31,
            rawPK.32, rawPK.33, rawPK.34, rawPK.35, rawPK.36, rawPK.37, rawPK.38, rawPK.39,
            rawPK.40, rawPK.41, rawPK.42, rawPK.43, rawPK.44, rawPK.45, rawPK.46, rawPK.47,
            rawPK.48, rawPK.49, rawPK.50, rawPK.51, rawPK.52, rawPK.53, rawPK.54, rawPK.55,
            rawPK.56, rawPK.57, rawPK.58, rawPK.59, rawPK.60, rawPK.61, rawPK.62, rawPK.63
        ]

        return pk
    }

    // MARK: - Helper functions

    private func verifyPrivateKey() throws {
        var secret = rawPrivateKey
        guard secp256k1_ec_seckey_verify(ctx, &secret) == 1 else {
            throw Error.keyMalformed
        }
    }

    // MARK: - Errors

    public enum Error: Swift.Error {

        case internalError
        case keyMalformed
        case pubKeyGenerationFailed
    }

    // MARK: - Deinitialization

    deinit {
        secp256k1_context_destroy(ctx)
    }
}
