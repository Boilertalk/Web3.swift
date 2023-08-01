//
//  EthereumPublicKey.swift
//  Web3
//
//  Created by Koray Koska on 07.02.18.
//

import Foundation
import VaporBytes
import secp256k1_ios
import Security
import CryptoSwift

public class EthereumPublicKey {

    // MARK: - Properties

    /// The raw public key bytes
    public let rawPublicKey: Bytes

    /// The `EthereumAddress` associated with this public key
    public let address: EthereumAddress

    /// Internal context for secp256k1 library calls
    private let ctx: OpaquePointer

    // MARK: - Initialization

    /**
     * Initializes a new instance of `EthereumPublicKey` with the given raw uncompressed public key Bytes.
     *
     * `publicKey` must be either a 64 Byte array (containing the uncompressed public key)
     * or a 65 byte array where the first byte must be the uncompressed header byte 0x04
     * and the following 64 bytes must be the uncompressed public key.
     *
     * - parameter publicKey: The uncompressed public key either with the header byte 0x04 or without.
     *
     * - throws: EthereumPublicKey.Error.keyMalformed if the given `publicKey` does not fulfill the requirements from above.
     *           EthereumPublicKey.Error.internalError if a secp256k1 library call or another internal call fails.
     */
    public init(publicKey: Bytes) throws {
        guard publicKey.count == 64 || publicKey.count == 65 else {
            throw Error.keyMalformed
        }
        var publicKey = publicKey
        if publicKey.count == 65 {
            guard publicKey[0] == 0x04 else {
                throw Error.keyMalformed
            }
            publicKey.remove(at: 0)
        }
        self.rawPublicKey = publicKey

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

        // Generate associated ethereum address
        var hash = SHA3(variant: .keccak256).calculate(for: publicKey)
        guard hash.count == 32 else {
            throw Error.internalError
        }
        hash = Array(hash[12...])
        self.address = try EthereumAddress(rawAddress: hash)

        // Verify public key
        try verifyPublicKey()
    }

    /**
     * Initializes a new instance of `EthereumPublicKey` with the given uncompressed hex string.
     *
     * `hexPublicKey` must have either 128 characters (containing the uncompressed public key)
     * or 130 characters in which case the first two characters must be the hex prefix 0x
     * and the following 128 characters must be the uncompressed public key.
     *
     * - parameter hexPublicKey: The uncompressed hex public key either with the hex prefix 0x or without.
     *
     * - throws: EthereumPublicKey.Error.keyMalformed if the given `hexPublicKey` does not fulfill the requirements from above.
     *           EthereumPublicKey.Error.internalError if a secp256k1 library call or another internal call fails.
     */
    public convenience init(hexPublicKey: String) throws {
        guard hexPublicKey.count == 128 || hexPublicKey.count == 130 else {
            throw Error.keyMalformed
        }

        var hexPublicKey = hexPublicKey

        if hexPublicKey.count == 130 {
            let s = hexPublicKey.index(hexPublicKey.startIndex, offsetBy: 0)
            let e = hexPublicKey.index(hexPublicKey.startIndex, offsetBy: 2)
            let prefix = String(hexPublicKey[s..<e])

            guard prefix == "0x" else {
                throw Error.keyMalformed
            }

            // Remove prefix
            hexPublicKey = String(hexPublicKey[e...])
        }

        var raw = Bytes()
        for i in stride(from: 0, to: hexPublicKey.count, by: 2) {
            let s = hexPublicKey.index(hexPublicKey.startIndex, offsetBy: i)
            let e = hexPublicKey.index(hexPublicKey.startIndex, offsetBy: i + 2)

            guard let b = Byte(String(hexPublicKey[s..<e]), radix: 16) else {
                throw Error.keyMalformed
            }
            raw.append(b)
        }

        try self.init(publicKey: raw)
    }

    // MARK: - Convenient functions

    /**
     * Returns this public key serialized as a hex string.
     */
    public func hex() -> String {
        var h = "0x"
        for b in rawPublicKey {
            h += String(format: "%02x", b)
        }

        return h
    }

    // MARK: - Helper functions

    private func verifyPublicKey() throws {
        var pubKey = rawPublicKey
        pubKey.insert(0x04, at: 0)

        guard let result = malloc(MemoryLayout<secp256k1_pubkey>.size)?.assumingMemoryBound(to: secp256k1_pubkey.self) else {
            throw Error.internalError
        }

        defer {
            free(result)
        }

        guard secp256k1_ec_pubkey_parse(ctx, result, &pubKey, 65) == 1 else {
            throw Error.keyMalformed
        }
    }

    // MARK: - Errors

    public enum Error: Swift.Error {

        case internalError
        case keyMalformed
    }

    // MARK: - Deinitialization

    deinit {
        secp256k1_context_destroy(ctx)
    }
}
