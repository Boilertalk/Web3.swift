//
//  TransactionTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 11.02.18.
//

import Quick
import Nimble
@testable import Web3

class TransactionTests: QuickSpec {

    override func spec() {
        describe("transaction tests") {
            context("signing legacy") {

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

            context("signing eip1559") {
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

                // Basic TX

                let basicTx = EthereumTransaction(
                    nonce: 0,
                    gasPrice: EthereumQuantity(quantity: 21.gwei),
                    maxFeePerGas: EthereumQuantity(quantity: 21.gwei),
                    maxPriorityFeePerGas: EthereumQuantity(quantity: 1.gwei),
                    gasLimit: 21000,
                    to: to,
                    value: EthereumQuantity(quantity: 1.eth),
                    transactionType: .eip1559
                )
                let basicSignature = try? basicTx.sign(with: privateKey, chainId: 1)
                it("should not be nil") {
                    expect(basicSignature).toNot(beNil())
                }

                let expectedBasicTx = "0x02f8730180843b9aca008504e3b2920082520894867aeeeed428ed9ba7f97fc7e16f16dfcf02f375880de0b6b3a764000080c001a007f4bf6cdde42fbf8bf2da94b8285521fb160c760413ba92de04fb90af108460a03178961acc860c5e0f29dc9f43d28e684ef195ee286f9c4620f74042135f7eb0"
                it("should produce the expected transaction") {
                    expect(try? basicSignature?.rawTransaction().bytes.hexString(prefix: true)) == expectedBasicTx
                }

                it("should be a valid tx") {
                    expect(basicSignature!.verifySignature()) == true
                }

                // Complicated TX

                let extendedTx = try! EthereumTransaction(
                    nonce: 0,
                    gasPrice: EthereumQuantity(quantity: 21.gwei),
                    maxFeePerGas: EthereumQuantity(quantity: 21.gwei),
                    maxPriorityFeePerGas: EthereumQuantity(quantity: 1.gwei),
                    gasLimit: 21000,
                    to: to,
                    value: EthereumQuantity(quantity: 1.eth),
                    data: EthereumData("0x02f8730180843b9aca008504e3b2920082".hexBytes()),
                    accessList: [
                        try! EthereumAddress(hex: "0xde0b295669a9fd93d5f28d9ec85e40f4cb697bae", eip55: false): [
                            EthereumData(ethereumValue: "0x0000000000000000000000000000000000000000000000000000000000000003"),
                            EthereumData(ethereumValue: "0x0000000000000000000000000000000000000000000000000000000000000007")
                        ],
                        try! EthereumAddress(hex: "0xbb9bc244d798123fde783fcc1c72d3bb8c189413", eip55: false): [],
                    ],
                    transactionType: .eip1559
                )
                let extendedSignature = try? extendedTx.sign(with: privateKey, chainId: 3)
                it("should not be nil") {
                    expect(extendedSignature).toNot(beNil())
                }

                let expectedExtendedTx = "0x02f8f70380843b9aca008504e3b2920082520894867aeeeed428ed9ba7f97fc7e16f16dfcf02f375880de0b6b3a76400009102f8730180843b9aca008504e3b2920082f872f85994de0b295669a9fd93d5f28d9ec85e40f4cb697baef842a00000000000000000000000000000000000000000000000000000000000000003a00000000000000000000000000000000000000000000000000000000000000007d694bb9bc244d798123fde783fcc1c72d3bb8c189413c080a0e0cd5f5e03d10e3d792fb652f6d1ea470cb6cdf745462980dff1652904cc4ed5a06f8b372427d15b68158597cd547c0f77165563da6a0b954d575920888edaf36c"
                it("should produce the expected transaction") {
                    expect(try? extendedSignature?.rawTransaction().bytes.hexString(prefix: true)) == expectedExtendedTx
                }

                it("should be a valid tx") {
                    expect(extendedSignature!.verifySignature()) == true
                }
            }
        }
    }
}
