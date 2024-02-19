//
//  Web3HttpTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 14.01.18.
//

import Quick
import Nimble
@testable import Web3
import BigInt
import PromiseKit
#if canImport(Web3PromiseKit)
    @testable import Web3PromiseKit
#endif

class Web3HttpTests: QuickSpec {

    let infuraUrl = "https://mainnet.infura.io/v3/0058461a5a1e47d3992ac9470168bcc3"
    let infuraWsUrl = "wss://mainnet.infura.io/ws/v3/0058461a5a1e47d3992ac9470168bcc3"

    override func spec() {
        describe("http rpc requests") {

            let web3 = Web3(rpcURL: infuraUrl)
            let web3Ws: Web3! = try? Web3(wsUrl: infuraWsUrl)
            if web3Ws == nil {
                fail("should initialize ws web3")
            }

            context("web3 client version") {

                // HTTP
                waitUntil(timeout: .seconds(2)) { done in
                    web3.clientVersion { response in
                        it("should be status success") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }

                        // Tests done
                        done()
                    }
                }

                // WebSocket
                waitUntil(timeout: .seconds(2)) { done in
                    web3Ws.clientVersion { response in
                        it("should be status success") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }

                        // Tests done
                        done()
                    }
                }
            }

            context("net version") {

                // HTTP
                waitUntil(timeout: .seconds(2)) { done in
                    web3.net.version { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be mainnet chain id") {
                            expect(response.result) == "1"
                        }

                        // Tests done
                        done()
                    }
                }

                // WebSocket
                waitUntil(timeout: .seconds(2)) { done in
                    web3Ws.net.version { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be mainnet chain id") {
                            expect(response.result) == "1"
                        }

                        // Tests done
                        done()
                    }
                }
            }

            context("net peer count") {

                // HTTP
                waitUntil(timeout: .seconds(2)) { done in
                    web3.net.peerCount { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a quantity response") {
                            expect(response.result?.quantity).toNot(beNil())
                        }

                        // Tests done
                        done()
                    }
                }

                // WebSocket
                waitUntil(timeout: .seconds(2)) { done in
                    web3Ws.net.peerCount { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a quantity response") {
                            expect(response.result?.quantity).toNot(beNil())
                        }

                        // Tests done
                        done()
                    }
                }
            }

            context("eth protocol version") {

                // HTTP
                waitUntil(timeout: .seconds(2)) { done in
                    web3.eth.protocolVersion { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }

                        // Tests done
                        done()
                    }
                }

                // WebSocket
                waitUntil(timeout: .seconds(2)) { done in
                    web3.eth.protocolVersion { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }

                        // Tests done
                        done()
                    }
                }
            }

            context("eth syncing") {

                waitUntil(timeout: .seconds(2)) { done in
                    web3.eth.syncing { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a valid response") {
                            expect(response.result?.syncing).toNot(beNil())

                            if let b = response.result?.syncing, b {
                                expect(response.result?.startingBlock).toNot(beNil())
                                expect(response.result?.currentBlock).toNot(beNil())
                                expect(response.result?.highestBlock).toNot(beNil())
                            } else {
                                expect(response.result?.startingBlock).to(beNil())
                                expect(response.result?.currentBlock).to(beNil())
                                expect(response.result?.highestBlock).to(beNil())
                            }
                        }

                        // Tests done
                        done()
                    }
                }
            }

            

            context("eth gas price") {

                waitUntil(timeout: .seconds(2)) { done in
                    web3.eth.gasPrice { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a quantity response") {
                            // Infura won't mine at any time or something's gonna be wrong...
                            expect(response.result?.quantity).toNot(beNil())
                        }

                        // Tests done
                        done()
                    }
                }
            }

            context("eth accounts") {

                waitUntil(timeout: .seconds(2)) { done in
                    web3.eth.accounts { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be an array response") {
                            // Infura should not have any accounts...
                            expect(response.result?.count) == 0
                        }

                        // Tests done
                        done()
                    }
                }
            }

            context("eth block number") {

                waitUntil(timeout: .seconds(2)) { done in
                    web3.eth.blockNumber { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a quantity response") {
                            expect(response.result?.quantity).toNot(beNil())
                        }

                        // Tests done
                        done()
                    }
                }
            }

            context("eth get balance") {

                let e = try? EthereumAddress(hex: "0xEA674fdDe714fd979de3EdF0F56AA9716B898ec8", eip55: false)
                it("should not be nil") {
                    expect(e).toNot(beNil())
                }
                guard let ethereumAddress = e else {
                    return
                }

                waitUntil(timeout: .seconds(2)) { done in
                    web3.eth.getBalance(address: ethereumAddress, block: .block(4000000)) { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a quantity response") {
                            expect(response.result?.quantity) == BigUInt("1ea7ab3de3c2f1dc75", radix: 16)
                        }

                        // Tests done
                        done()
                    }
                }
            }

            context("eth get storage at") {

                let e = try? EthereumAddress(hex: "0x06012c8cf97BEaD5deAe237070F9587f8E7A266d", eip55: false)
                it("should not be nil") {
                    expect(e).toNot(beNil())
                }
                guard let ethereumAddress = e else {
                    return
                }

                waitUntil(timeout: .seconds(2)) { done in
                    web3.eth.getStorageAt(address: ethereumAddress, position: 0, block: .latest) { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a data response") {
                            expect(response.result?.hex()) == "0x000000000000000000000000af1e54b359b0897133f437fc961dd16f20c045e1"
                        }

                        // Tests done
                        done()
                    }
                }
            }

            context("eth get transaction count") {

                let e = try? EthereumAddress(hex: "0x464B0B37db1eE1b5Fbe27300aCFBf172fD5E4F53", eip55: false)
                it("should not be nil") {
                    expect(e).toNot(beNil())
                }
                guard let ethereumAddress = e else {
                    return
                }

                waitUntil(timeout: .seconds(2)) { done in
                    web3.eth.getTransactionCount(address: ethereumAddress, block: .block(4000000)) { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }
                        it("should be a quantity response") {
                            expect(response.result?.quantity) == 0xd8
                        }

                        // Tests done
                        done()
                    }
                }
            }

            context("eth get transaction count by hash") {
                waitUntil(timeout: .seconds(2)) { done in
                    do {
                        try web3.eth.getBlockTransactionCountByHash(blockHash: .string("0x596f2d863a893392c55b72b5ba29e9ba67bdaa13c31765f9119e850a62565960")) { response in
                            it("should be status ok") {
                                expect(response.status.isSuccess) == true
                            }
                            it("should not be nil") {
                                expect(response.result).toNot(beNil())
                            }
                            it("should be a quantity response") {
                                expect(response.result?.quantity) == 0xaa
                            }

                            // Tests done
                            done()
                        }
                    } catch {
                        it("should not throw an error") {
                            expect(false) == true
                        }
                        done()
                    }
                }
            }

            context("eth get transaction count by number") {
                waitUntil(timeout: .seconds(2)) { done in
                    firstly {
                        web3.eth.getBlockTransactionCountByNumber(block: .block(5397389))
                    }.done { count in
                        it("should be count 88") {
                            expect(count) == 88
                        }
                        done()
                    }.catch { error in
                        it("should not fail") {
                            expect(false) == true
                        }
                        done()
                    }
                }
            }

            context("eth get uncle count by block hash") {
                waitUntil(timeout: .seconds(2)) { done in
                    firstly {
                        try web3.eth.getUncleCountByBlockHash(blockHash: .string("0xd8cdd624c5b4c5323f0cb8536ca31de046e3e4a798a07337489bab1bb3d822f0"))
                    }.done { count in
                        it("should include one uncle") {
                            expect(count) == 1
                        }
                        done()
                    }.catch { error in
                        it("should not fail") {
                            expect(false) == true
                        }
                        done()
                    }
                }
            }

            context("eth get uncle count by block number") {
                waitUntil(timeout: .seconds(2)) { done in
                    firstly {
                        web3.eth.getUncleCountByBlockNumber(block: .block(5397429))
                    }.done { count in
                        it("should include one uncle") {
                            expect(count) == 1
                        }
                        done()
                    }.catch { error in
                        it("should not fail") {
                            expect(false) == true
                        }
                        done()
                    }
                }
            }

            context("eth get code") {
                waitUntil(timeout: .seconds(2)) { done in
                    firstly {
                        try web3.eth.getCode(address: EthereumAddress(hex: "0x2e704bF506b96adaC7aD1df0db461344146a4657", eip55: true), block: .block(5397525))
                    }.done { code in
                        it("should be the expected data") {
                            let data: EthereumData? = try? .string("0x60606040526004361061006c5763ffffffff7c0100000000000000000000000000000000000000000000000000000000600035041663022914a78114610071578063173825d9146100a457806341c0e1b5146100c55780637065cb48146100d8578063aa1e84de146100f7575b600080fd5b341561007c57600080fd5b610090600160a060020a036004351661015a565b604051901515815260200160405180910390f35b34156100af57600080fd5b6100c3600160a060020a036004351661016f565b005b34156100d057600080fd5b6100c36101b7565b34156100e357600080fd5b6100c3600160a060020a03600435166101ea565b341561010257600080fd5b61014860046024813581810190830135806020601f8201819004810201604051908101604052818152929190602084018383808284375094965061023595505050505050565b60405190815260200160405180910390f35b60006020819052908152604090205460ff1681565b600160a060020a03331660009081526020819052604090205460ff16151561019657600080fd5b600160a060020a03166000908152602081905260409020805460ff19169055565b600160a060020a03331660009081526020819052604090205460ff1615156101de57600080fd5b33600160a060020a0316ff5b600160a060020a03331660009081526020819052604090205460ff16151561021157600080fd5b600160a060020a03166000908152602081905260409020805460ff19166001179055565b6000816040518082805190602001908083835b602083106102675780518252601f199092019160209182019101610248565b6001836020036101000a0380198251168184511617909252505050919091019250604091505051809103902090509190505600a165627a7a7230582085affe2ee33a8eb3900e773ef5a0d7f1bc95448e61a845ef36e00e6d6b4872cf0029")
                            expect(code) == data
                        }
                        done()
                    }.catch { error in
                        it("should not fail") {
                            expect(false) == true
                        }
                        done()
                    }
                }
            }

            context("eth call") {
                waitUntil(timeout: .seconds(2)) { done in
                    firstly {
                        try EthereumCall(
                            from: nil,
                            to: EthereumAddress(hex: "0x2e704bf506b96adac7ad1df0db461344146a4657", eip55: false),
                            gas: nil,
                            gasPrice: nil,
                            value: nil,
                            data: EthereumData(
                                ethereumValue: "0xaa1e84de000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000046461766500000000000000000000000000000000000000000000000000000000"
                            )
                        ).promise
                    }.then { call in
                        web3.eth.call(call: call, block: .latest)
                    }.done { data in
                        let expectedData: EthereumData = try .string("0x5e2393c41c2785095aa424cf3e033319468b6dcebda65e61606ee2ae2a198a87")
                        it("should be the expected data") {
                            expect(data) == expectedData
                        }
                        done()
                    }.catch { error in
                        it("should not fail") {
                            expect(false) == true
                        }
                        done()
                    }
                }
            }

            context("eth estimate gas") {
                waitUntil(timeout: .seconds(2)) { done in
                    firstly {
                        try EthereumCall(
                            from: nil,
                            to: EthereumAddress(hex: "0x2e704bf506b96adac7ad1df0db461344146a4657", eip55: false),
                            gas: nil,
                            gasPrice: nil,
                            value: nil,
                            data: EthereumData(
                                ethereumValue: "0xaa1e84de000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000046461766500000000000000000000000000000000000000000000000000000000"
                            )
                        ).promise
                    }.then { call in
                        web3.eth.estimateGas(call: call)
                    }.done { quantity in
                        let expectedQuantity: EthereumQuantity = try .string("0x46d4")
                        it("should be the expected quantity") {
                            expect(quantity.quantity).to(beGreaterThan(expectedQuantity.quantity))
                        }
                        done()
                    }.catch { error in
                        it("should not fail") {
                            expect(false) == true
                        }
                        done()
                    }
                }
            }

            context("eth get logs") {
                // HTTP
                waitUntil(timeout: .seconds(2)) { done in
                    firstly {
                        try web3.eth.getLogs(
                            addresses: [EthereumAddress(hex: "0xdAC17F958D2ee523a2206206994597C13D831ec7", eip55: true)],
                            topics: [[EthereumData(ethereumValue: "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef")]],
                            fromBlock: .block(BigUInt(15884445)),
                            toBlock: .block(BigUInt(15884445))
                        )
                    }.done { logs in
                        for log in logs {
                            it("should only include logs with this topic") {
                                expect(log.topics[0].hex()) == "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"
                            }
                        }
                        it("should be the expected number of logs") {
                            expect(logs.count) == 22
                        }
                        done()
                    }.catch { error in
                        it("should not fail") {
                            expect(false) == true
                        }
                        done()
                    }
                }

                // WebSocket
                waitUntil(timeout: .seconds(2)) { done in
                    try! web3Ws.eth.getLogs(
                        addresses: [EthereumAddress(hex: "0xdAC17F958D2ee523a2206206994597C13D831ec7", eip55: true)],
                        topics: [[EthereumData(ethereumValue: "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef")]],
                        fromBlock: .block(BigUInt(15884445)),
                        toBlock: .block(BigUInt(15884445))
                    ) { response in
                        it("should be status ok") {
                            expect(response.status.isSuccess) == true
                        }
                        it("should not be nil") {
                            expect(response.result).toNot(beNil())
                        }

                        for log in response.result ?? [] {
                            it("should only include logs with this topic") {
                                expect(log.topics[0].hex()) == "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"
                            }
                        }
                        it("should be the expected number of logs") {
                            expect(response.result?.count) == 22
                        }

                        // Tests done
                        done()
                    }
                }
            }
        }
    }
}
