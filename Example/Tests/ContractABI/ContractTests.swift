//
//  ContractTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 31.05.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3
import BigInt
#if canImport(Web3ContractABI)
import Web3ContractABI
#endif

struct ERC20: Contract {

    let address: EthereumAddress

    var reading: Reading
    var writing: Writing

    init(contractAddress: EthereumAddress) {
        self.address = contractAddress
        self.reading = Reading(contractAddress: contractAddress)
        self.writing = Writing(contractAddress: contractAddress)
    }

    struct Reading: Contract {

        let contractAddress: EthereumAddress

        init(contractAddress: EthereumAddress) {
            self.contractAddress = contractAddress
        }
    }

    struct Writing: Contract {

        let contractAddress: EthereumAddress

        init(contractAddress: EthereumAddress) {
            self.contractAddress = contractAddress
        }

        func transfer(
            nonce: EthereumQuantity,
            gasPrice: EthereumQuantity,
            gasLimit: EthereumQuantity,
            to: EthereumAddress,
            value: EthereumQuantity,
            chainId: EthereumQuantity
        ) -> EthereumTransaction {
            let data = createTransactionData(name: "transfer", inputs: [
                to,
                value.contractType(bits: 256)
            ])

            return EthereumTransaction(nonce: nonce, gasPrice: gasPrice, gasLimit: gasLimit, to: contractAddress, value: 0, data: data, chainId: chainId)
        }

        func transferFrom(
            nonce: EthereumQuantity,
            gasPrice: EthereumQuantity,
            gasLimit: EthereumQuantity,
            from: EthereumAddress,
            to: EthereumAddress,
            value: EthereumQuantity,
            chainId: EthereumQuantity
        ) -> EthereumTransaction {
            let data = createTransactionData(name: "transferFrom", inputs: [
                from,
                to,
                value.contractType(bits: 256)
            ])

            return EthereumTransaction(nonce: nonce, gasPrice: gasPrice, gasLimit: gasLimit, to: contractAddress, value: 0, data: data, chainId: chainId)
        }

        func approve(
            nonce: EthereumQuantity,
            gasPrice: EthereumQuantity,
            gasLimit: EthereumQuantity,
            spender: EthereumAddress,
            value: EthereumQuantity,
            chainId: EthereumQuantity
        ) -> EthereumTransaction {
            let data = createTransactionData(name: "approve", inputs: [
                spender,
                value.contractType(bits: 256)
            ])

            return EthereumTransaction(nonce: nonce, gasPrice: gasPrice, gasLimit: gasLimit, to: contractAddress, value: 0, data: data, chainId: chainId)
        }
    }
}

class ContractTests: QuickSpec {

    override func spec() {
        describe("contract tests") {

            context("erc20 tx data generation") {
                do {
                    let erc20 = try ERC20(contractAddress: EthereumAddress(hex: "0xb63b606ac810a52cca15e44bb630fd42d8d1d83d", eip55: false))
                    let privateKey = try EthereumPrivateKey(hexPrivateKey: "0xc144c24c9d75a46aad6517e4a864c13a5f302f1534b4bba39687e6d6af29d4fb")

                    // *** TRANSFER ***
                    var tx = try erc20.writing.transfer(
                        nonce: 0,
                        gasPrice: EthereumQuantity(quantity: 21.gwei),
                        gasLimit: 21000,
                        to: EthereumAddress(hex: "0xF92AB39A37CF96316132B50c8a85ED467A0deBE6", eip55: false),
                        value: EthereumQuantity(quantity: BigUInt(integerLiteral: 100000).multiplied(by: BigUInt(10).power(8))),
                        chainId: 1
                    )
                    try tx.sign(with: privateKey)

                    let expectedTx = "0xf8a9808504e3b2920082520894b63b606ac810a52cca15e44bb630fd42d8d1d83d80b844a9059cbb000000000000000000000000f92ab39a37cf96316132b50c8a85ed467a0debe6000000000000000000000000000000000000000000000000000009184e72a00025a092ec410fee64c6cd09408116af9be112f0ccecdabc68e3d72acd173b4448c702a07134497ca7b5868b7cb1f170d6d80bfe2c898abb6d72d4a1a55cc55a8eeae9ad"
                    it("should be the expected tx data") {
                        expect(try? EthereumData(bytes: RLPEncoder().encode(tx.rlp())).hex()) == expectedTx
                    }

                    // *** TRANSFER FROM ***
                    var fromTx = try erc20.writing.transferFrom(
                        nonce: 0,
                        gasPrice: EthereumQuantity(quantity: 21.gwei),
                        gasLimit: 21000,
                        from: EthereumAddress(hex: "0xF92AB39A37CF96316132B50c8a85ED467A0deBE6", eip55: false),
                        to: EthereumAddress(hex: "0xF92AB39A37CF96316132B50c8a85ED467A0deBE6", eip55: false),
                        value: 100000,
                        chainId: 1
                    )
                    try fromTx.sign(with: privateKey)

                    let expectedFromTx = "0xf8c9808504e3b2920082520894b63b606ac810a52cca15e44bb630fd42d8d1d83d80b86423b872dd000000000000000000000000f92ab39a37cf96316132b50c8a85ed467a0debe6000000000000000000000000f92ab39a37cf96316132b50c8a85ed467a0debe600000000000000000000000000000000000000000000000000000000000186a026a0c73bc54cf155242a9e42ed356de04cf8c35cdc0988176c08a68a13d0a3f3bac8a03d828881b83e5c95001394d8506c2f573b5c95adfae9dbabbfbbe6f73eae836d"
                    it("should be the expected from tx data") {
                        expect(try? EthereumData(bytes: RLPEncoder().encode(fromTx.rlp())).hex()) == expectedFromTx
                    }

                    // *** APPROVE ***
                    var approveTx = try erc20.writing.approve(
                        nonce: 0,
                        gasPrice: EthereumQuantity(quantity: 21.gwei),
                        gasLimit: 21000,
                        spender: EthereumAddress(hex: "0xF92AB39A37CF96316132B50c8a85ED467A0deBE6", eip55: false),
                        value: 100000,
                        chainId: 1
                    )
                    try approveTx.sign(with: privateKey)

                    let expectedApproveTx = "0xf8a9808504e3b2920082520894b63b606ac810a52cca15e44bb630fd42d8d1d83d80b844095ea7b3000000000000000000000000f92ab39a37cf96316132b50c8a85ed467a0debe600000000000000000000000000000000000000000000000000000000000186a025a094880103e6c0fbcacf44a00a4cec592fa20a3bd9358d6ebbae2024c199642ce3a01d3fb2d4dace65d9ad8537aa25561efecb022a330423c1be81ad87d035e6f0a8"
                    it("should be the expected approve tx data") {
                        expect(try? EthereumData(bytes: RLPEncoder().encode(approveTx.rlp())).hex()) == expectedApproveTx
                    }
                } catch {
                    it("should not throw") {
                        expect(false) == true
                    }
                }
            }
        }
    }
}
