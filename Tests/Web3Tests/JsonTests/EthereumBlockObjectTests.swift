//
//  EthereumBlockObjectTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 12.02.18.
//

import Quick
import Nimble
@testable import Web3
import Foundation

class EthereumBlockObjectTests: QuickSpec {

    var encoder: JSONEncoder = JSONEncoder()
    var decoder: JSONDecoder = JSONDecoder()

    override func spec() {
        describe("ethereum block object tests") {
            context("encodable") {

                let block = try? EthereumBlockObject(
                    number: 5074024,
                    hash: .string("0x5413f2348b6669b9ec9cb4798800fbadedf1f1da890b472234fb82fc3154eba9"),
                    parentHash: .string("0x8ecc84ad7e31d530b95491e33f8f38045553fa8f3150251793bf8be39f011932"),
                    nonce: .string("0x56869aa000e98dae"),
                    sha3Uncles: .string("0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347"),
                    logsBloom: .string("0x020e10a820c102500600d8c0081034005790004c00268040204844025400000c00920320000007020004220602400c190302d1a040254a0c1680009884900001360400408000c100c9904e3c01a15a2106a2004208822000410308020220028284608a833248002224104070c6405a42005430248c3405004104027052a1824021d08c4980250504a8780a9048099251b98048546801c1b000022b82000020006902484080002b041008880030088246200121012004a03808e42290020021404c0100ce8004a200001510c2049031270022200411088461005f41902c01308000120142082090a14600080022102d1f180e2090003400062e019814800208a4"),
                    transactionsRoot: .string("0xcac05ecb2d0ef298070e24185b2fd77438765f77a0aee08bbea43c224ca95767"),
                    stateRoot: .string("0x22ce9cd8ba6486e817acae0b5c7d66fd88e80ed26e06dea4f4c2a93c101a628f"),
                    receiptsRoot: .string("0x1d24660fddfeb6903113adf09b5037d67fafca50237449d3dc90ba1b6ce425eb"),
                    miner: EthereumAddress(hex: "0xea674fdde714fd979de3edf0f56aa9716b898ec8", eip55: false),
                    difficulty: .string("0xa2c29ca5908c1"),
                    totalDifficulty: .string("0x87076c0957cde7ace3"),
                    extraData: .string("0x65746865726d696e652d6e6f6465"),
                    size: 0x8bb5,
                    gasLimit: .string("0x79f39e"),
                    gasUsed: .string("0x79d6f0"),
                    timestamp: .string("0x5a80e79f"),
                    transactions: [
                        EthereumBlockObject.Transaction(
                            object: EthereumTransactionObject(
                                hash: .string("0xe28aa8aeb6bdbd06f6a3e9ef498f5fd0b39c8bd5fb14b27a0d27d686c92d99bb"),
                                nonce: 0x7ec,
                                blockHash: .some(.string("0x5413f2348b6669b9ec9cb4798800fbadedf1f1da890b472234fb82fc3154eba9")),
                                blockNumber: .some(0x4d6c68),
                                transactionIndex: .some(0x0),
                                from: EthereumAddress(hex: "0x2607660f7922d2d651bc4ac45df7d3a310160cae", eip55: false),
                                to: EthereumAddress(hex: "0x8d12a197cb00d4747a1fe03395095ce2a5cc6819", eip55: false),
                                value: 0x0,
                                gasPrice: .string("0x2e90edd000"),
                                gas: 0x3d090,
                                input: .string("0x0a19b14a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001ce97c70706df20000000000000000000000000000419d0d8bdd9af5e606ae2232ed285aff190e711b000000000000000000000000000000000000000000000000000328708d2b380000000000000000000000000000000000000000000000000000000000004d931400000000000000000000000000000000000000000000000000000000cc56a16a0000000000000000000000006b01bb8b9f5d00a0f0fe8532d2beda1d5d1a42ce000000000000000000000000000000000000000000000000000000000000001c64402c21718134a6c59382663ea1f0eadd995581f1fb402c3b5f83586529e5bd70782295477707b527c40a050b7e7b2a81c4619bcad145a2e5ebfd83f78df5f9000000000000000000000000000000000000000000000002e425df9692720000")
                            )
                        )
                    ],
                    uncles: []
                )
                it("should not be nil") {
                    expect(block).toNot(beNil())
                }

                guard let b = block else {
                    return
                }

                let newBlock = try? self.decoder.decode(EthereumBlockObject.self, from: self.encoder.encode(b))
                it("should not be nil") {
                    expect(newBlock).toNot(beNil())
                }

                it("should be equal") {
                    expect(newBlock?.number?.quantity) == 5074024
                    expect(newBlock?.hash?.hex()) == "0x5413f2348b6669b9ec9cb4798800fbadedf1f1da890b472234fb82fc3154eba9"
                    expect(newBlock?.parentHash.hex()) == "0x8ecc84ad7e31d530b95491e33f8f38045553fa8f3150251793bf8be39f011932"
                    expect(newBlock?.nonce?.hex()) == "0x56869aa000e98dae"
                    expect(newBlock?.sha3Uncles.hex()) == "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347"
                    expect(newBlock?.logsBloom?.hex()) == "0x020e10a820c102500600d8c0081034005790004c00268040204844025400000c00920320000007020004220602400c190302d1a040254a0c1680009884900001360400408000c100c9904e3c01a15a2106a2004208822000410308020220028284608a833248002224104070c6405a42005430248c3405004104027052a1824021d08c4980250504a8780a9048099251b98048546801c1b000022b82000020006902484080002b041008880030088246200121012004a03808e42290020021404c0100ce8004a200001510c2049031270022200411088461005f41902c01308000120142082090a14600080022102d1f180e2090003400062e019814800208a4"
                    expect(newBlock?.transactionsRoot.hex()) == "0xcac05ecb2d0ef298070e24185b2fd77438765f77a0aee08bbea43c224ca95767"
                    expect(newBlock?.stateRoot.hex()) == "0x22ce9cd8ba6486e817acae0b5c7d66fd88e80ed26e06dea4f4c2a93c101a628f"
                    expect(newBlock?.receiptsRoot.hex()) == "0x1d24660fddfeb6903113adf09b5037d67fafca50237449d3dc90ba1b6ce425eb"
                    expect(newBlock?.miner.hex(eip55: false)) == "0xea674fdde714fd979de3edf0f56aa9716b898ec8"
                    expect(newBlock?.difficulty.hex()) == "0xa2c29ca5908c1"
                    expect(newBlock?.totalDifficulty?.hex()) == "0x87076c0957cde7ace3"
                    expect(newBlock?.extraData.hex()) == "0x65746865726d696e652d6e6f6465"
                    expect(newBlock?.size?.quantity) == 0x8bb5
                    expect(newBlock?.gasLimit.hex()) == "0x79f39e"
                    expect(newBlock?.gasUsed.hex()) == "0x79d6f0"
                    expect(newBlock?.timestamp.hex()) == "0x5a80e79f"

                    expect(newBlock?.transactions?.count) == 1

                    let tx = newBlock?.transactions?.first
                    expect(tx?.object).toNot(beNil())
                    expect(tx?.hash).to(beNil())
                    expect(tx?.object?.hash.hex()) == "0xe28aa8aeb6bdbd06f6a3e9ef498f5fd0b39c8bd5fb14b27a0d27d686c92d99bb"
                    expect(tx?.object?.nonce.quantity) == 0x7ec
                    expect(tx?.object?.blockHash?.hex()) == "0x5413f2348b6669b9ec9cb4798800fbadedf1f1da890b472234fb82fc3154eba9"
                    expect(tx?.object?.blockNumber?.quantity) == 0x4d6c68
                    expect(tx?.object?.transactionIndex?.quantity) == 0x0
                    expect(tx?.object?.from.hex(eip55: false)) == "0x2607660f7922d2d651bc4ac45df7d3a310160cae"
                    expect(tx?.object?.to?.hex(eip55: false)) == "0x8d12a197cb00d4747a1fe03395095ce2a5cc6819"
                    expect(tx?.object?.value.quantity) == 0x0
                    expect(tx?.object?.gasPrice.hex()) == "0x2e90edd000"
                    expect(tx?.object?.gas.quantity) == 0x3d090
                    expect(tx?.object?.input.hex()) == "0x0a19b14a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001ce97c70706df20000000000000000000000000000419d0d8bdd9af5e606ae2232ed285aff190e711b000000000000000000000000000000000000000000000000000328708d2b380000000000000000000000000000000000000000000000000000000000004d931400000000000000000000000000000000000000000000000000000000cc56a16a0000000000000000000000006b01bb8b9f5d00a0f0fe8532d2beda1d5d1a42ce000000000000000000000000000000000000000000000000000000000000001c64402c21718134a6c59382663ea1f0eadd995581f1fb402c3b5f83586529e5bd70782295477707b527c40a050b7e7b2a81c4619bcad145a2e5ebfd83f78df5f9000000000000000000000000000000000000000000000002e425df9692720000"
                }

                it("should be equatable") {
                    expect(block == newBlock) == true
                }

                it("should produce correct hashValues") {
                    expect(block?.hashValue) == newBlock?.hashValue
                }
            }

            context("decodable") {

                let blockString = "{\"uncles\":[],\"hash\":\"0x5413f2348b6669b9ec9cb4798800fbadedf1f1da890b472234fb82fc3154eba9\",\"miner\":\"0xea674fdde714fd979de3edf0f56aa9716b898ec8\",\"parentHash\":\"0x8ecc84ad7e31d530b95491e33f8f38045553fa8f3150251793bf8be39f011932\",\"extraData\":\"0x65746865726d696e652d6e6f6465\",\"nonce\":\"0x56869aa000e98dae\",\"receiptsRoot\":\"0x1d24660fddfeb6903113adf09b5037d67fafca50237449d3dc90ba1b6ce425eb\",\"gasLimit\":\"0x79f39e\",\"transactionsRoot\":\"0xcac05ecb2d0ef298070e24185b2fd77438765f77a0aee08bbea43c224ca95767\",\"timestamp\":\"0x5a80e79f\",\"size\":\"0x8bb5\",\"stateRoot\":\"0x22ce9cd8ba6486e817acae0b5c7d66fd88e80ed26e06dea4f4c2a93c101a628f\",\"number\":\"0x4d6c68\",\"difficulty\":\"0xa2c29ca5908c1\",\"logsBloom\":\"0x020e10a820c102500600d8c0081034005790004c00268040204844025400000c00920320000007020004220602400c190302d1a040254a0c1680009884900001360400408000c100c9904e3c01a15a2106a2004208822000410308020220028284608a833248002224104070c6405a42005430248c3405004104027052a1824021d08c4980250504a8780a9048099251b98048546801c1b000022b82000020006902484080002b041008880030088246200121012004a03808e42290020021404c0100ce8004a200001510c2049031270022200411088461005f41902c01308000120142082090a14600080022102d1f180e2090003400062e019814800208a4\",\"sha3Uncles\":\"0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347\",\"gasUsed\":\"0x79d6f0\",\"transactions\":[{\"from\":\"0x2607660f7922d2d651bc4ac45df7d3a310160cae\",\"hash\":\"0xe28aa8aeb6bdbd06f6a3e9ef498f5fd0b39c8bd5fb14b27a0d27d686c92d99bb\",\"gas\":\"0x3d090\",\"input\":\"0x0a19b14a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001ce97c70706df20000000000000000000000000000419d0d8bdd9af5e606ae2232ed285aff190e711b000000000000000000000000000000000000000000000000000328708d2b380000000000000000000000000000000000000000000000000000000000004d931400000000000000000000000000000000000000000000000000000000cc56a16a0000000000000000000000006b01bb8b9f5d00a0f0fe8532d2beda1d5d1a42ce000000000000000000000000000000000000000000000000000000000000001c64402c21718134a6c59382663ea1f0eadd995581f1fb402c3b5f83586529e5bd70782295477707b527c40a050b7e7b2a81c4619bcad145a2e5ebfd83f78df5f9000000000000000000000000000000000000000000000002e425df9692720000\",\"blockHash\":\"0x5413f2348b6669b9ec9cb4798800fbadedf1f1da890b472234fb82fc3154eba9\",\"blockNumber\":\"0x4d6c68\",\"transactionIndex\":\"0x0\",\"value\":\"0x0\",\"to\":\"0x8d12a197cb00d4747a1fe03395095ce2a5cc6819\",\"gasPrice\":\"0x2e90edd000\",\"nonce\":\"0x7ec\"}],\"totalDifficulty\":\"0x87076c0957cde7ace3\"}"
                let block = try? self.decoder.decode(EthereumBlockObject.self, from: Data(blockString.makeBytes()))
                it("should not be nil") {
                    expect(block).toNot(beNil())
                }

                it("should be equal") {
                    expect(block?.number?.quantity) == 5074024
                    expect(block?.hash?.hex()) == "0x5413f2348b6669b9ec9cb4798800fbadedf1f1da890b472234fb82fc3154eba9"
                    expect(block?.parentHash.hex()) == "0x8ecc84ad7e31d530b95491e33f8f38045553fa8f3150251793bf8be39f011932"
                    expect(block?.nonce?.hex()) == "0x56869aa000e98dae"
                    expect(block?.sha3Uncles.hex()) == "0x1dcc4de8dec75d7aab85b567b6ccd41ad312451b948a7413f0a142fd40d49347"
                    expect(block?.logsBloom?.hex()) == "0x020e10a820c102500600d8c0081034005790004c00268040204844025400000c00920320000007020004220602400c190302d1a040254a0c1680009884900001360400408000c100c9904e3c01a15a2106a2004208822000410308020220028284608a833248002224104070c6405a42005430248c3405004104027052a1824021d08c4980250504a8780a9048099251b98048546801c1b000022b82000020006902484080002b041008880030088246200121012004a03808e42290020021404c0100ce8004a200001510c2049031270022200411088461005f41902c01308000120142082090a14600080022102d1f180e2090003400062e019814800208a4"
                    expect(block?.transactionsRoot.hex()) == "0xcac05ecb2d0ef298070e24185b2fd77438765f77a0aee08bbea43c224ca95767"
                    expect(block?.stateRoot.hex()) == "0x22ce9cd8ba6486e817acae0b5c7d66fd88e80ed26e06dea4f4c2a93c101a628f"
                    expect(block?.receiptsRoot.hex()) == "0x1d24660fddfeb6903113adf09b5037d67fafca50237449d3dc90ba1b6ce425eb"
                    expect(block?.miner.hex(eip55: false)) == "0xea674fdde714fd979de3edf0f56aa9716b898ec8"
                    expect(block?.difficulty.hex()) == "0xa2c29ca5908c1"
                    expect(block?.totalDifficulty?.hex()) == "0x87076c0957cde7ace3"
                    expect(block?.extraData.hex()) == "0x65746865726d696e652d6e6f6465"
                    expect(block?.size?.quantity) == 0x8bb5
                    expect(block?.gasLimit.hex()) == "0x79f39e"
                    expect(block?.gasUsed.hex()) == "0x79d6f0"
                    expect(block?.timestamp.hex()) == "0x5a80e79f"

                    expect(block?.transactions?.count) == 1

                    let tx = block?.transactions?.first
                    expect(tx?.object).toNot(beNil())
                    expect(tx?.hash).to(beNil())
                    expect(tx?.object?.hash.hex()) == "0xe28aa8aeb6bdbd06f6a3e9ef498f5fd0b39c8bd5fb14b27a0d27d686c92d99bb"
                    expect(tx?.object?.nonce.quantity) == 0x7ec
                    expect(tx?.object?.blockHash?.hex()) == "0x5413f2348b6669b9ec9cb4798800fbadedf1f1da890b472234fb82fc3154eba9"
                    expect(tx?.object?.blockNumber?.quantity) == 0x4d6c68
                    expect(tx?.object?.transactionIndex?.quantity) == 0x0
                    expect(tx?.object?.from.hex(eip55: false)) == "0x2607660f7922d2d651bc4ac45df7d3a310160cae"
                    expect(tx?.object?.to?.hex(eip55: false)) == "0x8d12a197cb00d4747a1fe03395095ce2a5cc6819"
                    expect(tx?.object?.value.quantity) == 0x0
                    expect(tx?.object?.gasPrice.hex()) == "0x2e90edd000"
                    expect(tx?.object?.gas.quantity) == 0x3d090
                    expect(tx?.object?.input.hex()) == "0x0a19b14a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001ce97c70706df20000000000000000000000000000419d0d8bdd9af5e606ae2232ed285aff190e711b000000000000000000000000000000000000000000000000000328708d2b380000000000000000000000000000000000000000000000000000000000004d931400000000000000000000000000000000000000000000000000000000cc56a16a0000000000000000000000006b01bb8b9f5d00a0f0fe8532d2beda1d5d1a42ce000000000000000000000000000000000000000000000000000000000000001c64402c21718134a6c59382663ea1f0eadd995581f1fb402c3b5f83586529e5bd70782295477707b527c40a050b7e7b2a81c4619bcad145a2e5ebfd83f78df5f9000000000000000000000000000000000000000000000002e425df9692720000"
                }
            }

            context("hash only transaction") {

                it("should encode and decode successfully") {
                    let tx = try? EthereumBlockObject.Transaction(hash: .string("0xe28aa8aeb6bdbd06f6a3e9ef498f5fd0b39c8bd5fb14b27a0d27d686c92d99bb"))
                    expect(tx).toNot(beNil())

                    expect(tx?.object).to(beNil())
                    expect(tx?.hash?.hex()) == "0xe28aa8aeb6bdbd06f6a3e9ef498f5fd0b39c8bd5fb14b27a0d27d686c92d99bb"

                    let encoded = try? self.encoder.encode([tx])
                    expect(encoded?.makeBytes().makeString()) == "[\"0xe28aa8aeb6bdbd06f6a3e9ef498f5fd0b39c8bd5fb14b27a0d27d686c92d99bb\"]"

                    let decoded = try? self.decoder.decode([EthereumBlockObject.Transaction].self, from: Data("[\"0xe28aa8aeb6bdbd06f6a3e9ef498f5fd0b39c8bd5fb14b27a0d27d686c92d99bb\"]".makeBytes()))
                    expect(decoded).toNot(beNil())

                    expect(decoded?.count) == 1
                    expect(decoded?.first?.hash?.hex()) == "0xe28aa8aeb6bdbd06f6a3e9ef498f5fd0b39c8bd5fb14b27a0d27d686c92d99bb"
                    expect(decoded?.first?.object).to(beNil())
                }
            }
        }
    }
}
