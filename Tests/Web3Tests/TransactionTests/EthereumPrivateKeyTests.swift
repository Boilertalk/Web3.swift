//
//  EthereumPrivateKeyTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 06.02.18.
//

import Quick
import Nimble
@testable import Web3
import BigInt

class EthereumPrivateKeyTests: QuickSpec {

    enum OwnErrors: Error {

        case shouldNotThrow
    }

    override func spec() {
        describe("ethereum private key checks") {
            context("private key verification") {
                it("should be a valid private key") {
                    let hex = "0xddeff73b1db1d8ddfd5e4c8e6e9a538938e53f98aaa027403ae69885fc97ddad"
                    let bytes: [UInt8] = [
                        0xdd, 0xef, 0xf7, 0x3b, 0x1d, 0xb1, 0xd8, 0xdd, 0xfd, 0x5e, 0x4c, 0x8e, 0x6e, 0x9a, 0x53, 0x89,
                        0x38, 0xe5, 0x3f, 0x98, 0xaa, 0xa0, 0x27, 0x40, 0x3a, 0xe6, 0x98, 0x85, 0xfc, 0x97, 0xdd, 0xad
                    ]

                    let priv = try? EthereumPrivateKey(
                        hexPrivateKey: hex
                    )
                    expect(priv).toNot(beNil())
                    expect(priv?.rawPrivateKey) == bytes

                    let priv2 = try? EthereumPrivateKey(
                        privateKey: bytes
                    )
                    expect(priv2).toNot(beNil())
                    expect(priv2?.rawPrivateKey) == bytes

                    // Both should be the same private key
                    expect(priv?.rawPrivateKey) == priv2?.rawPrivateKey
                }

                it("should be edge case valid private keys") {
                    let upperEdge = try? EthereumPrivateKey(
                        hexPrivateKey: "0xfffffffffffffffffffffffffffffffebaaedce6af48a03bbfd25e8cd0364140"
                    )
                    let lowerEdge = try? EthereumPrivateKey(
                        hexPrivateKey: "0x0000000000000000000000000000000000000000000000000000000000000001"
                    )

                    expect(upperEdge).toNot(beNil())
                    expect(lowerEdge).toNot(beNil())
                }
            }

            context("public key verification") {

                it("should be a valid public key") {
                    let publicKey = try? EthereumPrivateKey(
                        hexPrivateKey: "0x026cf37c61297a451e340cdc7fbc71b6789a3b1cb27dcdc9a9a2a32c16ce2afc"
                    ).publicKey
                    expect(publicKey?.rawPublicKey) == [
                        0xf8, 0x52, 0x1a, 0x0e, 0x42, 0x7d, 0xd3, 0xec, 0xd7, 0x1a, 0xf4, 0xf2, 0x17, 0xdf, 0x8f, 0xef,
                        0xf2, 0x6b, 0x85, 0x72, 0x95, 0x38, 0xb7, 0x59, 0x0c, 0x20, 0x98, 0x60, 0x55, 0x46, 0x7f, 0xb6,
                        0x0c, 0xce, 0xd0, 0x8f, 0x6b, 0x2c, 0x56, 0x76, 0x75, 0x08, 0xf3, 0xe7, 0x97, 0x6d, 0x5b, 0xcc,
                        0xd5, 0x2c, 0x91, 0xbf, 0x59, 0x77, 0xbb, 0x5d, 0x95, 0x43, 0x82, 0x67, 0x52, 0x26, 0x79, 0x18
                    ]
                }

                // We don't destroy the context as for these tests this is not really a security problem and quite
                // cumbersome (How do we know the tests are really finished?)
                // It should nevertheless always be done for real applications.
                let oCtx = try? secp256k1_default_ctx_create(errorThrowable: OwnErrors.shouldNotThrow)
                it("should be a valid ctx pointer") {
                    expect(oCtx).toNot(beNil())
                }
                guard let ctx = oCtx else {
                    return
                }

                it("should work with own ctx") {
                    let publicKey = try? EthereumPrivateKey(
                        hexPrivateKey: "0x026cf37c61297a451e340cdc7fbc71b6789a3b1cb27dcdc9a9a2a32c16ce2afc",
                        ctx: ctx
                    ).publicKey
                    expect(publicKey?.rawPublicKey) == [
                        0xf8, 0x52, 0x1a, 0x0e, 0x42, 0x7d, 0xd3, 0xec, 0xd7, 0x1a, 0xf4, 0xf2, 0x17, 0xdf, 0x8f, 0xef,
                        0xf2, 0x6b, 0x85, 0x72, 0x95, 0x38, 0xb7, 0x59, 0x0c, 0x20, 0x98, 0x60, 0x55, 0x46, 0x7f, 0xb6,
                        0x0c, 0xce, 0xd0, 0x8f, 0x6b, 0x2c, 0x56, 0x76, 0x75, 0x08, 0xf3, 0xe7, 0x97, 0x6d, 0x5b, 0xcc,
                        0xd5, 0x2c, 0x91, 0xbf, 0x59, 0x77, 0xbb, 0x5d, 0x95, 0x43, 0x82, 0x67, 0x52, 0x26, 0x79, 0x18
                    ]
                }

                it("should work with own ctx twice") {
                    let publicKey = try? EthereumPrivateKey(
                        hexPrivateKey: "0x026cf37c61297a451e340cdc7fbc71b6789a3b1cb27dcdc9a9a2a32c16ce2afc",
                        ctx: ctx
                    ).publicKey
                    expect(publicKey?.rawPublicKey) == [
                        0xf8, 0x52, 0x1a, 0x0e, 0x42, 0x7d, 0xd3, 0xec, 0xd7, 0x1a, 0xf4, 0xf2, 0x17, 0xdf, 0x8f, 0xef,
                        0xf2, 0x6b, 0x85, 0x72, 0x95, 0x38, 0xb7, 0x59, 0x0c, 0x20, 0x98, 0x60, 0x55, 0x46, 0x7f, 0xb6,
                        0x0c, 0xce, 0xd0, 0x8f, 0x6b, 0x2c, 0x56, 0x76, 0x75, 0x08, 0xf3, 0xe7, 0x97, 0x6d, 0x5b, 0xcc,
                        0xd5, 0x2c, 0x91, 0xbf, 0x59, 0x77, 0xbb, 0x5d, 0x95, 0x43, 0x82, 0x67, 0x52, 0x26, 0x79, 0x18
                    ]
                }
            }

            context("hashable") {
                it("should produce correct hashValues") {
                    let p1 = try? EthereumPrivateKey(
                        hexPrivateKey: "0xddeff73b1db1d8ddfd5e4c8e6e9a538938e53f98aaa027403ae69885fc97ddad"
                    )
                    let p2 = try? EthereumPrivateKey(
                        hexPrivateKey: "0xddeff73b1db1d8ddfd5e4c8e6e9a538938e53f98aaa027403ae69885fc97ddad"
                    )

                    expect(p1?.hashValue) == p2?.hashValue
                }

                it("should produce different hashValues") {
                    let p1 = try? EthereumPrivateKey(
                        hexPrivateKey: "0xddeff73b1db1d8ddfd5e4c8e6e9a538938e53f98aaa027403ae69885fc97ddad"
                    )
                    let p2 = try? EthereumPrivateKey(
                        hexPrivateKey: "0xad028828bbe74b01302dfcd0b8f06cdc8fc50668649ce5859926bd69a947667f"
                    )

                    expect(p1?.hashValue) != p2?.hashValue
                }
            }
        }
    }
}
