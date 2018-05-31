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

    var contractDescriptionElements: [ContractDescriptionElement] {
        return [
            .function(description: ContractFunctionDescription(
                type: .function,
                name: "transfer",
                inputs: [
                    .init(name: "to", type: .address),
                    .init(name: "value", type: .uint(bits: 256))
                ],
                outputs: [
                    .init(name: "", type: .bool)
                ],
                payable: false,
                stateMutability: .nonpayable)
            )
        ]
    }

    func transfer(to: EthereumAddress, value: BigUInt) throws -> Bytes {
        return try createTransactionData(
            name: "transfer",
            inputs: [
                ContractType.address(to),
                ContractType.uint(value)
            ]
        )
    }
}

class ContractTests: QuickSpec {

    override func spec() {
        describe("contract tests") {

            context("erc20 tx data generation") {
                let erc20 = ERC20()

                let privateKey = try! EthereumPrivateKey(hexPrivateKey: "0xc144c24c9d75a46aad6517e4a864c13a5f302f1534b4bba39687e6d6af29d4fb")

                let data = try! EthereumData(bytes: erc20.transfer(
                    to: EthereumAddress(hex: "0xF92AB39A37CF96316132B50c8a85ED467A0deBE6", eip55: false),
                    value: BigUInt(integerLiteral: 100000).multiplied(by: BigUInt(10).power(8))
                ))

                var tx = try! EthereumTransaction(
                    nonce: 0,
                    gasPrice: EthereumQuantity(quantity: 21.gwei),
                    gasLimit: 21000,
                    to: EthereumAddress(hex: "0xb63b606ac810a52cca15e44bb630fd42d8d1d83d", eip55: false),
                    value: 0,
                    data: data,
                    chainId: 1
                )
                try! tx.sign(with: privateKey)

                let expectedTx = "0xf8a9808504e3b2920082520894b63b606ac810a52cca15e44bb630fd42d8d1d83d80b844a9059cbb000000000000000000000000f92ab39a37cf96316132b50c8a85ed467a0debe6000000000000000000000000000000000000000000000000000009184e72a00025a092ec410fee64c6cd09408116af9be112f0ccecdabc68e3d72acd173b4448c702a07134497ca7b5868b7cb1f170d6d80bfe2c898abb6d72d4a1a55cc55a8eeae9ad"
                expect(try? EthereumData(bytes: RLPEncoder().encode(tx.rlp())).hex()) == expectedTx
            }
        }
    }
}
