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

                let tx = EthereumTransaction(nonce: 0, gasPrice: EthereumQuantity(quantity: 21.gwei), gasLimit: 21000, to: to, value: EthereumQuantity(quantity: 1.eth))

                // Sign transaction with private key
                let newTx = try? tx.sign(with: privateKey, chainId: 3)
                it("should not be nil") {
                    expect(newTx).toNot(beNil())
                }

                let expectedTransaction = "0xf86c808504e3b2920082520894867aeeeed428ed9ba7f97fc7e16f16dfcf02f375880de0b6b3a76400008029a099060c9146c68716da3a79533866dc941a03b171911d675f518c97a73882f7a6a0019167adb26b602501c954e7793e798407836f524b9778f5be6ebece5fc998c6"

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
