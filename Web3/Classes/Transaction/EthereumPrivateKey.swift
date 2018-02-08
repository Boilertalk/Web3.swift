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
import CryptoSwift

public class EthereumPrivateKey {

    // MARK: - Properties

    /// The raw private key bytes
    public let rawPrivateKey: Bytes

    /// The public key associated with this private key
    public let publicKey: EthereumPublicKey

    /// Returns the ethereum address representing the public key associated with this private key.
    public var address: EthereumAddress {
        return publicKey.address
    }

    /// Internal context for secp256k1 library calls
    private let ctx: OpaquePointer

    // MARK: - Initialization

    /**
     * Initializes a new instance of `EthereumPrivateKey` with the given `privateKey` Bytes.
     *
     * `privateKey` must be exactly a big endian 32 Byte array representing the private key.
     *
     * The number must be in the secp256k1 range as described in: https://en.bitcoin.it/wiki/Private_key
     *
     * So any number between
     *
     * 0x0000000000000000000000000000000000000000000000000000000000000001
     *
     * and
     *
     * 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364140
     *
     * is considered to be a valid secp256k1 private key.
     *
     * - parameter privateKey: The private key bytes.
     *
     * - throws: EthereumPrivateKey.Error.keyMalformed if the restrictions described above are not met.
     *           EthereumPrivateKey.Error.internalError if a secp256k1 library call or another internal call fails.
     *           EthereumPrivateKey.Error.pubKeyGenerationFailed if the public key extraction from the private key fails.
     */
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

        // *** Generate public key ***
        guard let pubKey = malloc(MemoryLayout<secp256k1_pubkey>.size)?.assumingMemoryBound(to: secp256k1_pubkey.self) else {
            throw Error.internalError
        }
        // Cleanup
        defer {
            free(pubKey)
        }
        var secret = privateKey
        if secp256k1_ec_pubkey_create(ctx, pubKey, &secret) != 1 {
            throw Error.pubKeyGenerationFailed
        }

        var pubOut = Bytes(repeating: 0, count: 65)
        var pubOutLen = 65
        _ = secp256k1_ec_pubkey_serialize(ctx, &pubOut, &pubOutLen, pubKey, UInt32(SECP256K1_EC_UNCOMPRESSED))
        guard pubOutLen == 65 else {
            throw Error.pubKeyGenerationFailed
        }

        // First byte is header byte 0x04
        pubOut.remove(at: 0)

        self.publicKey = try EthereumPublicKey(publicKey: pubOut)
        // *** End Generate public key ***

        // Verify private key
        try verifyPrivateKey()
    }

    /**
     * Initializes a new instance of `EthereumPrivateKey` with the given `hexPrivateKey` hex string.
     *
     * `hexPrivateKey` must be either 64 characters long or 66 characters (with the hex prefix 0x).
     *
     * The number must be in the secp256k1 range as described in: https://en.bitcoin.it/wiki/Private_key
     *
     * So any number between
     *
     * 0x0000000000000000000000000000000000000000000000000000000000000001
     *
     * and
     *
     * 0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364140
     *
     * is considered to be a valid secp256k1 private key.
     *
     * - parameter hexPrivateKey: The private key bytes.
     *
     * - throws: EthereumPrivateKey.Error.keyMalformed if the restrictions described above are not met.
     *           EthereumPrivateKey.Error.internalError if a secp256k1 library call or another internal call fails.
     *           EthereumPrivateKey.Error.pubKeyGenerationFailed if the public key extraction from the private key fails.
     */
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

    public func sign(message: Bytes) throws -> (v: UInt, r: Bytes, s: Bytes) {
        var hash = SHA3(variant: .keccak256).calculate(for: message)
        guard hash.count == 32 else {
            throw Error.internalError
        }
        guard let sig = malloc(MemoryLayout<secp256k1_ecdsa_recoverable_signature>.size)?.assumingMemoryBound(to: secp256k1_ecdsa_recoverable_signature.self) else {
            throw Error.internalError
        }
        defer {
            free(sig)
        }

        var seckey = rawPrivateKey

        guard secp256k1_ecdsa_sign_recoverable(ctx, sig, &hash, &seckey, nil, nil) == 1 else {
            throw Error.internalError
        }

        var output64 = Bytes(repeating: 0, count: 64)
        var recid: Int32 = 0
        secp256k1_ecdsa_recoverable_signature_serialize_compact(ctx, &output64, &recid, sig)

        guard recid == 0 || recid == 1 else {
            // Well I guess this one should never happen but to avoid bigger problems...
            throw Error.internalError
        }

        return (v: UInt(recid), r: Array(output64[0..<32]), s: Array(output64[32..<64]))
    }

    /**
     * Returns this private key serialized as a hex string.
     */
    public func hex() -> String {
        var h = "0x"
        for b in rawPrivateKey {
            h += String(format: "%02x", b)
        }

        return h
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
