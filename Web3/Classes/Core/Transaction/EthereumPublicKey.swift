//
//  EthereumPublicKey.swift
//  Web3
//
//  Created by Koray Koska on 07.02.18.
//

import Foundation
import VaporBytes
import secp256k1
import CryptoSwift
import BigInt

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

        // Create context
        let ctx = try secp256k1_default_ctx_create(errorThrowable: Error.internalError)
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
     * Initializes a new instance of `EthereumPublicKey` with the message and corresponding signature.
     * This is done by extracting the public key from the recoverable signature, which guarantees a
     * valid signature.
     *
     * - parameter message: The original message which will be used to generate the hash which must match the given signature.
     * - paramater v: The recovery id of the signature. Must be 0, 1, 2 or 3 or Error.signatureMalformed will be thrown.
     * - parameter r: The r value of the signature.
     * - parameter s: The s value of the signature.
     *
     * - throws: EthereumPublicKey.Error.signatureMalformed if the signature is not valid or in other ways malformed.
     *           EthereumPublicKey.Error.internalError if a secp256k1 library call or another internal call fails.
     */
    public init(message: Bytes, v: UInt, r: BigUInt, s: BigUInt) throws {
        // Create context
        let ctx = try secp256k1_default_ctx_create(errorThrowable: Error.internalError)
        self.ctx = ctx

        // Create raw signature array
        var rawSig = Bytes()
        var r = r.makeBytes().trimLeadingZeros()
        var s = s.makeBytes().trimLeadingZeros()

        guard r.count <= 32 && s.count <= 32 else {
            throw Error.signatureMalformed
        }
        guard v <= Int32.max else {
            throw Error.signatureMalformed
        }
        var v = Int32(v)

        for i in 0..<(32 - r.count) {
            r.insert(0, at: 0)
        }
        for i in 0..<(32 - s.count) {
            s.insert(0, at: 0)
        }

        rawSig.append(contentsOf: r)
        rawSig.append(contentsOf: s)

        // Parse recoverable signature
        guard let recsig = malloc(MemoryLayout<secp256k1_ecdsa_recoverable_signature>.size)?.assumingMemoryBound(to: secp256k1_ecdsa_recoverable_signature.self) else {
            throw Error.internalError
        }
        defer {
            free(recsig)
        }
        guard secp256k1_ecdsa_recoverable_signature_parse_compact(ctx, recsig, &rawSig, v) == 1 else {
            throw Error.signatureMalformed
        }

        // Recover public key
        guard let pubkey = malloc(MemoryLayout<secp256k1_pubkey>.size)?.assumingMemoryBound(to: secp256k1_pubkey.self) else {
            throw Error.internalError
        }
        defer {
            free(pubkey)
        }
        var hash = SHA3(variant: .keccak256).calculate(for: rawSig)
        guard hash.count == 32 else {
            throw Error.internalError
        }
        guard secp256k1_ecdsa_recover(ctx, pubkey, recsig, &hash) == 1 else {
            throw Error.signatureMalformed
        }

        // Generate uncompressed public key bytes
        var rawPubKey = Bytes(repeating: 0, count: 65)
        var outputlen = 65
        guard secp256k1_ec_pubkey_serialize(ctx, &rawPubKey, &outputlen, pubkey, UInt32(SECP256K1_EC_UNCOMPRESSED)) == 1 else {
            throw Error.internalError
        }

        rawPubKey.remove(at: 0)
        self.rawPublicKey = rawPubKey

        // Generate associated ethereum address
        var pubHash = SHA3(variant: .keccak256).calculate(for: rawPubKey)
        guard pubHash.count == 32 else {
            throw Error.internalError
        }
        pubHash = Array(pubHash[12...])
        self.address = try EthereumAddress(rawAddress: pubHash)
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

        try self.init(publicKey: hexPublicKey.hexBytes())
    }

    // MARK: - Convenient functions

    /*
    public func verifySignature(message: Bytes, v: UInt, r: BigUInt, s: BigUInt) throws -> Bool {
        // Get public key
        var rawpubKey = rawPublicKey
        rawpubKey.insert(0x04, at: 0)
        guard let pubkey = malloc(MemoryLayout<secp256k1_pubkey>.size)?.assumingMemoryBound(to: secp256k1_pubkey.self) else {
            throw Error.internalError
        }
        defer {
            free(pubkey)
        }
        guard secp256k1_ec_pubkey_parse(ctx, pubkey, &rawpubKey, 65) == 1 else {
            throw Error.keyMalformed
        }

        // Create raw signature array
        var rawSig = Bytes()
        var r = r.makeBytes().trimLeadingZeros()
        var s = s.makeBytes().trimLeadingZeros()

        guard r.count <= 32 && s.count <= 32 else {
            throw Error.signatureMalformed
        }
        guard v <= Int32.max else {
            throw Error.signatureMalformed
        }
        var v = Int32(v)

        for i in 0..<(32 - r.count) {
            r.insert(0, at: 0)
        }
        for i in 0..<(32 - s.count) {
            s.insert(0, at: 0)
        }

        rawSig.append(contentsOf: r)
        rawSig.append(contentsOf: s)

        // Parse recoverable signature
        guard let recsig = malloc(MemoryLayout<secp256k1_ecdsa_recoverable_signature>.size)?.assumingMemoryBound(to: secp256k1_ecdsa_recoverable_signature.self) else {
            throw Error.internalError
        }
        defer {
            free(recsig)
        }
        guard secp256k1_ecdsa_recoverable_signature_parse_compact(ctx, recsig, &rawSig, v) == 1 else {
            throw Error.signatureMalformed
        }

        // Convert to normal signature
        guard let sig = malloc(MemoryLayout<secp256k1_ecdsa_signature>.size)?.assumingMemoryBound(to: secp256k1_ecdsa_signature.self) else {
            throw Error.internalError
        }
        defer {
            free(sig)
        }
        guard secp256k1_ecdsa_recoverable_signature_convert(ctx, sig, recsig) == 1 else {
            throw Error.internalError
        }

        // Check validity with signature
        var hash = SHA3(variant: .keccak256).calculate(for: message)
        guard hash.count == 32 else {
            throw Error.internalError
        }
        return secp256k1_ecdsa_verify(ctx, sig, &hash, pubkey) == 1
    }*/

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
        case signatureMalformed
    }

    // MARK: - Deinitialization

    deinit {
        secp256k1_context_destroy(ctx)
    }
}
