//
//  EthereumPrivateKeyTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 06.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3

class EthereumPrivateKeyTests: QuickSpec {

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
        }
    }
}
