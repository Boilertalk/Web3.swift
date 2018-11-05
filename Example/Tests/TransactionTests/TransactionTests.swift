//
//  TransactionTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 11.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Quick
import Nimble
@testable import Web3

class TransactionTests: QuickSpec {

    override func spec() {
        describe("transaction tests") {
            context("signing") {

                let p = try? EthereumPrivateKey(
                    hexPrivateKey: "0x94eca03b4541a0eb0d173e321b6f960d08cfe4c5a75fa00ebe0a3d283c609c3a"
                )
                let t = p?.address
                it("should not be nil") {
                    expect(t).toNot(beNil())
                }

                guard let to = t, let privateKey = p else {
                    return
                }

                let tx = EthereumTransaction(nonce: 0, gasPrice: EthereumQuantity(quantity: 21.gwei), gas: 21000, to: to, value: EthereumQuantity(quantity: 1.eth))

                // Sign transaction with private key
                let newTx = try? tx.sign(with: privateKey, chain: .main)
                it("should not be nil") {
                    expect(newTx).toNot(beNil())
                }

                let expectedTransaction = "0xf86c808504e3b2920082520894867aeeeed428ed9ba7f97fc7e16f16dfcf02f375880de0b6b3a76400008026a05d9fb6e88cead48b65d5f9d9e3256be4105bceec356c85dfcc6f84fd4e8314a2a04487c0f65ef0b416ec3f6f3843370e68afa9d2c1d5af09500ff5b35a9fe05c7d"

                it("should produce the expected rlp encoding") {
                    expect(try? RLPEncoder().encode(newTx!.rlp()).hexString(prefix: true)) == expectedTransaction
                }

                // Check validity
                it("should be a valid tx") {
                    expect(newTx!.verifySignature()) == true
                }

                let afterHashValue = newTx!.hashValue
                it("should create a different hashValue") {
                    expect(tx.hashValue) != afterHashValue
                }
            }
        }
    }
}
