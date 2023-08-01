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
        guard let pubKey = malloc(MemoryLayout<secp256k1_pubkey>.size)?.assumingMemoryBound(to: secp256k1_pubkey.self) else {
            throw Error.internalError
        }

        // Cleanup
        defer {
            free(pubKey)
        }

        var secret = rawPrivateKey

        let result = secp256k1_ec_pubkey_create(ctx, pubKey, &secret)

        if result != 1 {
            throw Error.pubKeyGenerationFailed
        }

        var pubOut = Bytes(repeating: 0, count: 65)
        var pubOutLen = 65
        _ = secp256k1_ec_pubkey_serialize(ctx, &pubOut, &pubOutLen, pubKey, UInt32(SECP256K1_EC_UNCOMPRESSED))
        guard pubOutLen == 65 else {
            throw Error.pubKeyGenerationFailed
        }

        // First byte is 0x04
        pubOut.remove(at: 0)

        return pubOut
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
