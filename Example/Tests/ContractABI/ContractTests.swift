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
import PromiseKit
#if canImport(Web3PromiseKit)
import Web3PromiseKit
#endif

struct ERC20: Contract {

    let address: EthereumAddress

    let reading: Reading
    let writing: Writing

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

        func name() -> EthereumCall {
            let data = createTransactionData(functionName: "name", inputs: [])
            return EthereumCall(to: contractAddress, data: data)
        }

        func symbol() -> EthereumCall {
            let data = createTransactionData(functionName: "symbol", inputs: [])
            return EthereumCall(to: contractAddress, data: data)
        }

        func decimals() -> EthereumCall {
            let data = createTransactionData(functionName: "decimals", inputs: [])
            return EthereumCall(to: contractAddress, data: data)
        }

        func totalSupply() -> EthereumCall {
            let data = createTransactionData(functionName: "totalSupply", inputs: [])
            return EthereumCall(to: contractAddress, data: data)
        }

        func balanceOf(owner: EthereumAddress) -> EthereumCall {
            let data = createTransactionData(functionName: "balanceOf", inputs: [owner])
            return EthereumCall(to: contractAddress, data: data)
        }

        func allowance(owner: EthereumAddress, spender: EthereumAddress) -> EthereumCall {
            let data = createTransactionData(functionName: "allowance", inputs: [owner, spender])
            return EthereumCall(to: contractAddress, data: data)
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
            let data = createTransactionData(functionName: "transfer", inputs: [
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
            let data = createTransactionData(functionName: "transferFrom", inputs: [
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
            let data = createTransactionData(functionName: "approve", inputs: [
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

            let erc20 = try! ERC20(contractAddress: EthereumAddress(hex: "0x0Cf7e107881AC96c0c241326746bce2742575cf7", eip55: false))

            context("erc20 calls") {

                let web3 = Web3(rpcURL: "https://ropsten.infura.io/rFWTF4C1mwjexZVw0LoU")

                waitUntil(timeout: 2.0) { done in
                    firstly {
                        web3.eth.call(call: erc20.reading.name(), block: .latest)
                    }.done { name in
                        print("NAME")
                        print(name.hex())
                        // TODO: Expect correct name
                        done()
                    }.catch { error in
                        it("should not fail") {
                            expect(false) == true
                        }
                        done()
                    }
                }

                waitUntil(timeout: 2.0) { done in
                    firstly {
                        web3.eth.call(call: erc20.reading.symbol(), block: .latest)
                    }.done { symbol in
                        print("SYMBOL")
                        // TODO: Expect correct symbol
                        print(symbol.hex())
                        done()
                    }.catch { error in
                        it("should not fail") {
                            expect(false) == true
                        }
                        done()
                    }
                }

                waitUntil(timeout: 2.0) { done in
                    firstly {
                        web3.eth.call(call: erc20.reading.decimals(), block: .latest)
                    }.done { decimals in
                        print("DECIMALS")
                        print(decimals.hex())
                        // TODO: Expect correct decimals
                        done()
                    }.catch { error in
                        it("should not fail") {
                            expect(false) == true
                        }
                        done()
                    }
                }

                waitUntil(timeout: 2.0) { done in
                    firstly {
                        web3.eth.call(call: erc20.reading.totalSupply(), block: .latest)
                    }.done { totalSupply in
                        print("TOTAL SUPPY")
                        print(totalSupply.hex())
                        done()
                    }.catch { error in
                        it("should not fail") {
                            expect(false) == true
                        }
                        done()
                    }
                }
            }

            context("erc20 tx data generation") {
                do {
                    let privateKey = try EthereumPrivateKey(hexPrivateKey: "0xc144c24c9d75a46aad6517e4a864c13a5f302f1534b4bba39687e6d6af29d4fb")

                    // *** TRANSFER ***
                    var tx = try erc20.writing.transfer(
                        nonce: 0,
                        gasPrice: EthereumQuantity(quantity: 21.gwei),
                        gasLimit: 21000,
                        to: EthereumAddress(hex: "0x78C758b3038afeF79Fc753FD7CcbFFf59a77Acc6", eip55: false),
                        value: EthereumQuantity(quantity: BigUInt(integerLiteral: 100000).multiplied(by: BigUInt(10).power(8))),
                        chainId: 3
                    )
                    try tx.sign(with: privateKey)

                    let expectedTx = "0xf8a9808504e3b29200825208940cf7e107881ac96c0c241326746bce2742575cf780b844a9059cbb00000000000000000000000078c758b3038afef79fc753fd7ccbfff59a77acc6000000000000000000000000000000000000000000000000000009184e72a00029a04ad7a97288af4456a9ca52d53bc8c5ed3bdb3478e3c92f52e4b2cf1f1d1eafcba01677e5a7b35e8d209f1188023103365420915599b8280ae3ea2aa9f92ac29e13"
                    it("should be the expected tx data") {
                        expect(try? EthereumData(bytes: RLPEncoder().encode(tx.rlp())).hex()) == expectedTx
                    }

                    // *** TRANSFER FROM ***
                    var fromTx = try erc20.writing.transferFrom(
                        nonce: 0,
                        gasPrice: EthereumQuantity(quantity: 21.gwei),
                        gasLimit: 21000,
                        from: EthereumAddress(hex: "0xF92AB39A37CF96316132B50c8a85ED467A0deBE6", eip55: false),
                        to: EthereumAddress(hex: "0x78C758b3038afeF79Fc753FD7CcbFFf59a77Acc6", eip55: false),
                        value: 100000,
                        chainId: 3
                    )
                    try fromTx.sign(with: privateKey)

                    let expectedFromTx = "0xf8c9808504e3b29200825208940cf7e107881ac96c0c241326746bce2742575cf780b86423b872dd000000000000000000000000f92ab39a37cf96316132b50c8a85ed467a0debe600000000000000000000000078c758b3038afef79fc753fd7ccbfff59a77acc600000000000000000000000000000000000000000000000000000000000186a029a021c10f8813c410e43477e38da49c30cb41b68f97c1dcfb1b7ede2cf8e9f17273a0057de57ccbca69b2561e4e9dfe7c1954ba37b78af307d7d0bb7fdac788cf16bb"
                    it("should be the expected from tx data") {
                        expect(try? EthereumData(bytes: RLPEncoder().encode(fromTx.rlp())).hex()) == expectedFromTx
                    }

                    // *** APPROVE ***
                    var approveTx = try erc20.writing.approve(
                        nonce: 0,
                        gasPrice: EthereumQuantity(quantity: 21.gwei),
                        gasLimit: 21000,
                        spender: EthereumAddress(hex: "0x78C758b3038afeF79Fc753FD7CcbFFf59a77Acc6", eip55: false),
                        value: 100000,
                        chainId: 3
                    )
                    try approveTx.sign(with: privateKey)

                    let expectedApproveTx = "0xf8a9808504e3b29200825208940cf7e107881ac96c0c241326746bce2742575cf780b844095ea7b300000000000000000000000078c758b3038afef79fc753fd7ccbfff59a77acc600000000000000000000000000000000000000000000000000000000000186a029a0465011f2291c25d5fc6d7c6afd70accd21fecda01ccb6844981e8823effb2ae7a04e087e4bd636ecf747c4f1f6924d78567d9bd359994527f8c5b5841f321bf1e4"
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
