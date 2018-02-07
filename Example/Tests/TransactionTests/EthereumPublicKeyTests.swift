//
//  EthereumPublicKeyTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 07.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3

class EthereumPublicKeyTests: QuickSpec {

    override func spec() {
        describe("ethereum public key checks") {
            context("public key verification") {

                it("should be a valid public key") {
                    let hex = "0x5ff2ea6b8d33785647dad53ff31548f8d173845cabccde40fe810b9bc5fc20394035c7173c95a352576dec3124a83f6581bae850cf7d770b12df995a325b7106"
                    let bytes: [UInt8] = [
                        0x5f, 0xf2, 0xea, 0x6b, 0x8d, 0x33, 0x78, 0x56, 0x47, 0xda, 0xd5, 0x3f, 0xf3, 0x15, 0x48, 0xf8,
                        0xd1, 0x73, 0x84, 0x5c, 0xab, 0xcc, 0xde, 0x40, 0xfe, 0x81, 0x0b, 0x9b, 0xc5, 0xfc, 0x20, 0x39,
                        0x40, 0x35, 0xc7, 0x17, 0x3c, 0x95, 0xa3, 0x52, 0x57, 0x6d, 0xec, 0x31, 0x24, 0xa8, 0x3f, 0x65,
                        0x81, 0xba, 0xe8, 0x50, 0xcf, 0x7d, 0x77, 0x0b, 0x12, 0xdf, 0x99, 0x5a, 0x32, 0x5b, 0x71, 0x06
                    ]

                    let pub = try? EthereumPublicKey(hexPublicKey: hex)
                    expect(pub).toNot(beNil())
                    expect(pub?.rawPublicKey) == bytes

                    let pub2 = try? EthereumPublicKey(publicKey: bytes)
                    expect(pub2).toNot(beNil())
                    expect(pub2?.rawPublicKey) == bytes

                    // Both should be the same private key
                    expect(pub?.rawPublicKey) == pub2?.rawPublicKey

                    // hex should match
                    expect(pub?.hex()) == hex
                    expect(pub2?.hex()) == hex
                }

                it("should be edge case invalid public keys") {
                    // Yes I know, those pubkeys are not real 'edge cases' as public keys are coordinates on the
                    // secp256k1 curve and not ascending numbers, but let's just call them like that for the tests.

                    let hexMin = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
                    expect { try EthereumPublicKey(hexPublicKey: hexMin) }
                        .to(throwError(EthereumPublicKey.Error.keyMalformed))

                    let haxMax = "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
                    expect { try EthereumPublicKey(hexPublicKey: haxMax) }
                        .to(throwError(EthereumPublicKey.Error.keyMalformed))
                }
            }

            context("ethereum address verification") {

                it("should generate a valid ethereum address") {
                    let hex = "0x5872ec8b7f69bebfd6104d5eb19a339e9316afcc84864c98bbb3d5e10f0eea21b361d2cb1890113c85c5fc633fd0897223b69823a9c59341dd2981b0fb978671"
                    let pub = try? EthereumPublicKey(hexPublicKey: hex)

                    expect(pub?.address.hex(eip55: false)) == "0xb54c5e59124546034bf1b8a07b52e35b34cb5ff8"
                    expect(pub?.address.hex(eip55: true)) == "0xB54C5E59124546034BF1b8a07b52e35b34cb5Ff8"
                }
            }
        }
    }
}
