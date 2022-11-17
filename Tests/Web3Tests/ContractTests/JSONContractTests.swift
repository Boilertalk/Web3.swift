//
//  JSONContractTests.swift
//  Web3_Tests
//
//  Created by Josh Pyles on 6/4/18.
//

import Quick
import Nimble
@testable import Web3
import PromiseKit
import BigInt
import Foundation
#if canImport(Web3ContractABI)
    @testable import Web3ContractABI
#endif

extension EthereumAddress {
    static let testAddress = try! EthereumAddress(hex: "0x0000000000000000000000000000000000000000", eip55: false)
}

class DynamicContractTests: QuickSpec {

    func stubResponses(provider: MockWeb3Provider) {
        if let callData = loadStub(named: "call_getBalance") {
            provider.addStub(method: "eth_call", data: callData)
        }
        if let transactionData = loadStub(named: "sendTransaction") {
            provider.addStub(method: "eth_sendTransaction", data: transactionData)
        }
    }

    override func spec() {

        describe("JSON generated contract") {
            do {
                let provider = MockWeb3Provider()
                stubResponses(provider: provider)
                let web3 = Web3(provider: provider)
                guard let data = loadStub(named: "ERC721") else { return assertionFailure("Could not find stub for contract") }
                let contract = try web3.eth.Contract(json: data, abiKey: "abi", address: .testAddress)

                it("should be decoded properly") {
                    expect(contract.methods.count).to(equal(8))
                }

                describe("Constructor methods") {
                    do {
                        let rawByteCode =  "0x608060405234801561001057600080fd5b506040516020806115db8339810180604052810190808051906020019092919050505080600881905550506115918061004a6000396000f3006080604052600436106100e6576000357c0100000000000000000000000000000000000000000000000000000000900463ffffffff16806306fdde03146100eb578063081812fc1461017b578063095ea7b3146101e85780631051db341461023557806318160ddd1461026457806323b872dd1461028f5780632f745c59146102fc5780636352211e1461035d5780636914db60146103ca57806370a082311461047057806395d89b41146104c7578063996517cf14610557578063a0712d6814610582578063a9059cbb146105af578063af129dc2146105fc578063d63d4af014610627575b600080fd5b3480156100f757600080fd5b506101006106bf565b6040518080602001828103825283818151815260200191508051906020019080838360005b83811015610140578082015181840152602081019050610125565b50505050905090810190601f16801561016d5780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561018757600080fd5b506101a660048036038101908080359060200190929190505050610761565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b3480156101f457600080fd5b50610233600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610773565b005b34801561024157600080fd5b5061024a610920565b604051808215151515815260200191505060405180910390f35b34801561027057600080fd5b50610279610929565b6040518082815260200191505060405180910390f35b34801561029b57600080fd5b506102fa600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610933565b005b34801561030857600080fd5b50610347600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610afe565b6040518082815260200191505060405180910390f35b34801561036957600080fd5b5061038860048036038101908080359060200190929190505050610b12565b604051808273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200191505060405180910390f35b3480156103d657600080fd5b506103f560048036038101908080359060200190929190505050610b24565b6040518080602001828103825283818151815260200191508051906020019080838360005b8381101561043557808201518184015260208101905061041a565b50505050905090810190601f1680156104625780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561047c57600080fd5b506104b1600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610bd9565b6040518082815260200191505060405180910390f35b3480156104d357600080fd5b506104dc610c25565b6040518080602001828103825283818151815260200191508051906020019080838360005b8381101561051c578082015181840152602081019050610501565b50505050905090810190601f1680156105495780820380516001836020036101000a031916815260200191505b509250505060405180910390f35b34801561056357600080fd5b5061056c610cc7565b6040518082815260200191505060405180910390f35b34801561058e57600080fd5b506105ad60048036038101908080359060200190929190505050610ccd565b005b3480156105bb57600080fd5b506105fa600480360381019080803573ffffffffffffffffffffffffffffffffffffffff16906020019092919080359060200190929190505050610e06565b005b34801561060857600080fd5b50610611610f8e565b6040518082815260200191505060405180910390f35b34801561063357600080fd5b50610668600480360381019080803573ffffffffffffffffffffffffffffffffffffffff169060200190929190505050610f94565b6040518080602001828103825283818151815260200191508051906020019060200280838360005b838110156106ab578082015181840152602081019050610690565b505050509050019250505060405180910390f35b606060008054600181600116156101000203166002900480601f0160208091040260200160405190810160405280929190818152602001828054600181600116156101000203166002900480156107575780601f1061072c57610100808354040283529160200191610757565b820191906000526020600020905b81548152906001019060200180831161073a57829003601f168201915b5050505050905090565b600061076c82610fa6565b9050919050565b80600073ffffffffffffffffffffffffffffffffffffffff1661079582610b12565b73ffffffffffffffffffffffffffffffffffffffff16141515156107b857600080fd5b6107c182610b12565b73ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161415156107fa57600080fd5b8273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161415151561083557600080fd5b600073ffffffffffffffffffffffffffffffffffffffff1661085683610fa6565b73ffffffffffffffffffffffffffffffffffffffff161415806108a65750600073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1614155b1561091b576108b58383610fe3565b8273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a35b505050565b60006001905090565b6000600254905090565b80600073ffffffffffffffffffffffffffffffffffffffff1661095582610b12565b73ffffffffffffffffffffffffffffffffffffffff161415151561097857600080fd5b3373ffffffffffffffffffffffffffffffffffffffff1661099883610761565b73ffffffffffffffffffffffffffffffffffffffff161415156109ba57600080fd5b8373ffffffffffffffffffffffffffffffffffffffff166109da83610b12565b73ffffffffffffffffffffffffffffffffffffffff161415156109fc57600080fd5b600073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1614151515610a3857600080fd5b610a43848484611039565b60008473ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a38273ffffffffffffffffffffffffffffffffffffffff168473ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a350505050565b6000610b0a8383611065565b905092915050565b6000610b1d826110c6565b9050919050565b6060600560008381526020019081526020016000208054600181600116156101000203166002900480601f016020809104026020016040519081016040528092919081815260200182805460018160011615610100020316600290048015610bcd5780601f10610ba257610100808354040283529160200191610bcd565b820191906000526020600020905b815481529060010190602001808311610bb057829003601f168201915b50505050509050919050565b6000600660008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020805490509050919050565b606060018054600181600116156101000203166002900480601f016020809104026020016040519081016040528092919081815260200182805460018160011615610100020316600290048015610cbd5780601f10610c9257610100808354040283529160200191610cbd565b820191906000526020600020905b815481529060010190602001808311610ca057829003601f168201915b5050505050905090565b60085481565b80600073ffffffffffffffffffffffffffffffffffffffff166003600083815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16141515610d3c57600080fd5b600854600660003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002080549050101515610d8e57600080fd5b610d988233611103565b610da23383611159565b610db8600160025461122390919063ffffffff16565b600281905550813373ffffffffffffffffffffffffffffffffffffffff167f0f6798a560793a54c3bcfe86a93cde1e73087d944c0ea20544137d412139688560405160405180910390a35050565b80600073ffffffffffffffffffffffffffffffffffffffff16610e2882610b12565b73ffffffffffffffffffffffffffffffffffffffff1614151515610e4b57600080fd5b3373ffffffffffffffffffffffffffffffffffffffff16610e6b83610b12565b73ffffffffffffffffffffffffffffffffffffffff16141515610e8d57600080fd5b600073ffffffffffffffffffffffffffffffffffffffff168373ffffffffffffffffffffffffffffffffffffffff1614151515610ec957600080fd5b610ed4338484611039565b60003373ffffffffffffffffffffffffffffffffffffffff167f8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925846040518082815260200191505060405180910390a38273ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff167fddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef846040518082815260200191505060405180910390a3505050565b60025481565b6060610f9f82611241565b9050919050565b60006004600083815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050919050565b816004600083815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055505050565b611042816112d8565b61104c838261132e565b6110568183611103565b6110608282611159565b505050565b6000600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020828154811015156110b357fe5b9060005260206000200154905092915050565b60006003600083815260200190815260200160002060009054906101000a900473ffffffffffffffffffffffffffffffffffffffff169050919050565b806003600084815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff1602179055505050565b600660008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208190806001815401808255809150509060018203906000526020600020016000909192909190915055506001600660008473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020805490500360076000838152602001908152602001600020819055505050565b600080828401905083811015151561123757fe5b8091505092915050565b6060600660008373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208054806020026020016040519081016040528092919081815260200182805480156112cc57602002820191906000526020600020905b8154815260200190600101908083116112b8575b50505050509050919050565b60006004600083815260200190815260200160002060006101000a81548173ffffffffffffffffffffffffffffffffffffffff021916908373ffffffffffffffffffffffffffffffffffffffff16021790555050565b6000806000600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002080549050925060076000858152602001908152602001600020549150600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600184038154811015156113dd57fe5b9060005260206000200154905080600660008773ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000208381548110151561143757fe5b9060005260206000200181905550816007600083815260200190815260200160002081905550600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff168152602001908152602001600020600184038154811015156114ac57fe5b9060005260206000200160009055600660008673ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002080548091906001900361150c9190611514565b505050505050565b81548183558181111561153b5781836000526020600020918201910161153a9190611540565b5b505050565b61156291905b8082111561155e576000816000905550600101611546565b5090565b905600a165627a7a723058207688f4bdd24340cc70ce22e63119085ece9749191d9fef2c9e4b1ad9eb438f600029"

                        let byteCode = try EthereumData(ethereumValue: rawByteCode)

                        guard let invocation = contract.deploy(byteCode: byteCode, parameters: BigUInt(5)) else {
                            return
                        }

                        it("should have constructor method") {
                            expect(contract.constructor).notTo(beNil())
                        }

                        it("should have correct invocation") {
                            expect(invocation.parameters.count).to(equal(1))
                            expect(invocation.byteCode).to(equal(byteCode))
                        }

                        it("should be able to create a valid transaction") {
                            let transaction = invocation.createTransaction(gasPrice: 0, gasLimit: 0, from: .testAddress)
                            let generatedHexString = transaction?.data.hex()
                            expect(generatedHexString).notTo(beNil())
                        }

                        it("should deploy") {
                            let expectedHash = try? EthereumData(ethereumValue: "0x0e670ec64341771606e55d6b4ca35a1a6b75ee3d5145a99d05921026d1527331")
                            waitUntil { done in
                                invocation.send(gasPrice: nil, gasLimit: 15000, from: .testAddress) { (hash, error) in
                                    expect(error).to(beNil())
                                    expect(hash).to(equal(expectedHash))
                                    done()
                                }
                            }
                        }

                        it("should fail to deploy when including a value") {
                            waitUntil { done in
                                invocation.send(
                                    nonce: nil,
                                    gasPrice: nil,
                                    maxFeePerGas: nil,
                                    maxPriorityFeePerGas: nil,
                                    gasLimit: 15000,
                                    from: .testAddress,
                                    value: EthereumQuantity(quantity: 1.eth),
                                    accessList: [:],
                                    transactionType: .legacy
                                ) { (hash, error) in
                                    expect(error as? InvocationError).to(equal(.invalidInvocation))
                                    done()
                                }
                            }
                        }
                    } catch {
                        fail(error.localizedDescription)
                    }
                }

                describe("Calls") {

                    it("should be able to call constant method") {
                        waitUntil { done in
                            contract["balanceOf"]?(EthereumAddress.testAddress).call() { response, error in
                                if let response = response, let balance = response["_balance"] as? BigUInt {
                                    expect(balance).to(equal(1))
                                    done()
                                } else {
                                    fail(error?.localizedDescription ?? "Empty response")
                                }
                            }
                        }
                    }

                    it("should be able to create an EthereumCall") {
                        guard let call = contract["balanceOf"]?(EthereumAddress.testAddress).createCall() else {
                            fail("Could not generate call")
                            return
                        }
                        waitUntil { done in
                            web3.eth.call(call: call, block: .latest) { response in
                                switch response.status {
                                case .success:
                                    done()
                                case .failure(let error):
                                    fail(error.localizedDescription)
                                }
                            }
                        }
                    }
                }

                describe("Sends") {

                    it("should be able to send non-payable method") {
                        guard let transaction = contract["transfer"]?(EthereumAddress.testAddress, BigUInt(1)).createTransaction(
                            nonce: 0,
                            gasPrice: nil,
                            maxFeePerGas: nil,
                            maxPriorityFeePerGas: nil,
                            gasLimit: 12000,
                            from: .testAddress,
                            value: nil,
                            accessList: [:],
                            transactionType: .legacy
                        ) else {
                            fail("Could not generate transaction")
                            return
                        }
                        waitUntil { done in
                            web3.eth.sendTransaction(transaction: transaction) { response in
                                switch response.status {
                                case .success:
                                    done()
                                case .failure(let error):
                                    fail(error.localizedDescription)
                                }
                            }
                        }
                    }
                }
            } catch {
                fail(error.localizedDescription)
            }
        }

        describe("struct or tuple type return values") {

            let provider = MockWeb3Provider()

            guard let data = loadStub(named: "TupleExamples") else { return assertionFailure("Could not load stub") }
            let web3 = Web3(provider: provider)

            // SIMPLE TUPLE RETURN EXAMPLE

            do {
                let contract = try web3.eth.Contract(json: data, abiKey: nil, address: .testAddress)

                it("should represent structs with tuples") {
                    waitUntil { done in
                        if let tupleCallData = self.loadStub(named: "TupleExamples_returnSimpleStaticTuple") {
                            provider.removeStub(method: "eth_call")
                            provider.addStub(method: "eth_call", data: tupleCallData)
                        }
                        firstly {
                            contract["returnSimpleStaticTuple"]!().call()
                        }.done { outputs in
                            guard let t = outputs["returnTuple"] as? [String: Any] else {
                                fail("returned tuple should be decoded")
                                return
                            }
                            expect(t["x"] as? BigUInt).to(equal(128))
                            expect(t["y"] as? BigUInt).to(equal(256))
                            done()
                        }.catch { error in
                            fail(error.localizedDescription)
                        }
                    }
                }
            } catch {
                fail(error.localizedDescription)
            }

            // NOT SO SIMPLE TUPLE RETURN EXAMPLE

            do {
                let contract = try web3.eth.Contract(json: data, abiKey: nil, address: .testAddress)

                it("should represent structs with tuples") {
                    waitUntil { done in
                        if let tupleCallData = self.loadStub(named: "TupleExamples_returnComplexStaticTuple") {
                            provider.removeStub(method: "eth_call")
                            provider.addStub(method: "eth_call", data: tupleCallData)
                        }
                        firstly {
                            contract["returnComplexStaticTuple"]!().call()
                        }.done { outputs in
                            guard let t = outputs["returnTuple"] as? [String: Any] else {
                                fail("returned tuple should be decoded")
                                return
                            }
                            expect(t["x"] as? Int16).to(equal(128))
                            expect(t["yArr"] as? [BigUInt]).to(equal([256, 512, 1024, 2048]))
                            expect(t["addr"] as? EthereumAddress).to(equal(try EthereumAddress(hex: "0x000000000000000000000000000000000000dEaD", eip55: true)))
                            expect((t["b"] as? Data)?.toHexString()).to(equal("00000000001234567890"))
                            done()
                        }.catch { error in
                            fail(error.localizedDescription)
                        }
                    }
                }
            } catch {
                fail(error.localizedDescription)
            }
        }

        describe("struct array or tuple array type return values") {

            let provider = MockWeb3Provider()

            guard let data = loadStub(named: "TupleExamples") else { return assertionFailure("Could not load stub") }
            let web3 = Web3(provider: provider)

            // SIMPLE TUPLE ARRAY RETURN EXAMPLE

            do {
                let contract = try web3.eth.Contract(json: data, abiKey: nil, address: .testAddress)

                it("should represent structs arrays with tuples arrays") {
                    waitUntil { done in
                        if let tupleCallData = self.loadStub(named: "TupleExamples_returnSimpleStaticTupleArray") {
                            provider.removeStub(method: "eth_call")
                            provider.addStub(method: "eth_call", data: tupleCallData)
                        }
                        firstly {
                            contract["returnSimpleStaticTupleArray"]!().call()
                        }.done { outputs in
                            guard let t = outputs["returnTupleArray"] as? [[String: Any]], t.count == 4 else {
                                fail("returned tuple array should be decoded and count should be 4")
                                return
                            }
                            for el in t {
                                expect(el["x"] as? BigUInt).to(equal(128))
                                expect(el["y"] as? BigUInt).to(equal(256))
                            }
                            done()
                        }.catch { error in
                            fail(error.localizedDescription)
                        }
                    }
                }
            } catch {
                fail(error.localizedDescription)
            }

            // NOT SO SIMPLE TUPLE ARRAY RETURN EXAMPLE

            do {
                let contract = try web3.eth.Contract(json: data, abiKey: nil, address: .testAddress)

                it("should represent structs with tuples") {
                    waitUntil { done in
                        if let tupleCallData = self.loadStub(named: "TupleExamples_returnComplexStaticTupleArray") {
                            provider.removeStub(method: "eth_call")
                            provider.addStub(method: "eth_call", data: tupleCallData)
                        }
                        firstly {
                            contract["returnComplexStaticTupleArray"]!().call()
                        }.done { outputs in
                            guard let t = outputs["returnTupleArray"] as? [[String: Any]], t.count == 4 else {
                                fail("returned tuple array should be decoded and count should be 4")
                                return
                            }
                            for el in t {
                                expect(el["x"] as? Int16).to(equal(128))
                                expect(el["yArr"] as? [BigUInt]).to(equal([256, 512, 1024, 2048]))
                                expect(el["addr"] as? EthereumAddress).to(equal(try EthereumAddress(hex: "0x000000000000000000000000000000000000dEaD", eip55: true)))
                                expect((el["b"] as? Data)?.toHexString()).to(equal("00000000001234567890"))
                            }
                            done()
                        }.catch { error in
                            fail(error.localizedDescription)
                        }
                    }
                }
            } catch {
                fail(error.localizedDescription)
            }
        }

        describe("dynamic struct or tuple type return values") {

            let provider = MockWeb3Provider()

            guard let data = loadStub(named: "TupleExamples") else { return assertionFailure("Could not load stub") }
            let web3 = Web3(provider: provider)

            // SIMPLE DYNAMIC TUPLE RETURN EXAMPLE

            do {
                let contract = try web3.eth.Contract(json: data, abiKey: nil, address: .testAddress)

                it("should represent dynamic structs with tuples") {
                    waitUntil { done in
                        if let tupleCallData = self.loadStub(named: "TupleExamples_returnSimpleDynamicTuple") {
                            provider.removeStub(method: "eth_call")
                            provider.addStub(method: "eth_call", data: tupleCallData)
                        }
                        firstly {
                            contract["returnSimpleDynamicTuple"]!().call()
                        }.done { outputs in
                            guard let t = outputs["returnTuple"] as? [String: Any] else {
                                fail("returned tuple should be decoded")
                                return
                            }
                            expect(t["s"] as? String).to(equal("abcdef123456"))
                            expect((t["b"] as? Data)?.toHexString()).to(equal("00000000000000000000000000000000000000000000d3c21bcecceda1000000"))
                            done()
                        }.catch { error in
                            fail(error.localizedDescription)
                        }
                    }
                }
            } catch {
                fail(error.localizedDescription)
            }

            // NOT SO SIMPLE DYNAMIC TUPLE RETURN EXAMPLE

            do {
                let contract = try web3.eth.Contract(json: data, abiKey: nil, address: .testAddress)

                it("should represent structs with tuples") {
                    waitUntil { done in
                        if let tupleCallData = self.loadStub(named: "TupleExamples_returnComplexDynamicTuple") {
                            provider.removeStub(method: "eth_call")
                            provider.addStub(method: "eth_call", data: tupleCallData)
                        }
                        firstly {
                            contract["returnComplexDynamicTuple"]!().call()
                        }.done { outputs in
                            guard let t = outputs["returnTuple"] as? [String: Any] else {
                                fail("returned tuple should be decoded")
                                return
                            }
                            expect(t["s"] as? String).to(equal("abcdef123456"))
                            expect(t["xArr"] as? [BigUInt]).to(equal([256, 512, 1024, 2048]))
                            expect(t["addr"] as? EthereumAddress).to(equal(try EthereumAddress(hex: "0x000000000000000000000000000000000000dEaD", eip55: true)))
                            expect((t["b"] as? Data)?.toHexString()).to(equal("00000000001234567890"))
                            done()
                        }.catch { error in
                            fail(error.localizedDescription)
                        }
                    }
                }
            } catch {
                fail(error.localizedDescription)
            }
        }

        describe("dynamic struct array or tuple array type return values") {

            let provider = MockWeb3Provider()

            guard let data = loadStub(named: "TupleExamples") else { return assertionFailure("Could not load stub") }
            let web3 = Web3(provider: provider)

            // SIMPLE TUPLE ARRAY RETURN EXAMPLE

            do {
                let contract = try web3.eth.Contract(json: data, abiKey: nil, address: .testAddress)

                it("should represent structs arrays with tuples arrays") {
                    waitUntil { done in
                        if let tupleCallData = self.loadStub(named: "TupleExamples_returnSimpleDynamicTupleArray") {
                            provider.removeStub(method: "eth_call")
                            provider.addStub(method: "eth_call", data: tupleCallData)
                        }
                        firstly {
                            contract["returnSimpleDynamicTupleArray"]!().call()
                        }.done { outputs in
                            guard let t = outputs["returnTupleArray"] as? [[String: Any]], t.count == 4 else {
                                fail("returned tuple array should be decoded and count should be 4")
                                return
                            }
                            for el in t {
                                expect(el["s"] as? String).to(equal("abcdef123456"))
                                expect((el["b"] as? Data)?.toHexString()).to(equal("00000000000000000000000000000000000000000000d3c21bcecceda1000000"))
                            }
                            done()
                        }.catch { error in
                            fail(error.localizedDescription)
                        }
                    }
                }
            } catch {
                fail(error.localizedDescription)
            }

            // NOT SO SIMPLE TUPLE ARRAY RETURN EXAMPLE

            do {
                let contract = try web3.eth.Contract(json: data, abiKey: nil, address: .testAddress)

                it("should represent dynamic struct arrays with tuples") {
                    waitUntil { done in
                        if let tupleCallData = self.loadStub(named: "TupleExamples_returnComplexDynamicTupleArray") {
                            provider.removeStub(method: "eth_call")
                            provider.addStub(method: "eth_call", data: tupleCallData)
                        }
                        firstly {
                            contract["returnComplexDynamicTupleArray"]!().call()
                        }.done { outputs in
                            guard let t = outputs["returnTupleArray"] as? [[String: Any]], t.count == 4 else {
                                fail("returned tuple array should be decoded and count should be 4")
                                return
                            }
                            for el in t {
                                expect(el["s"] as? String).to(equal("abcdef123456"))
                                expect(el["xArr"] as? [BigUInt]).to(equal([256, 512, 1024, 2048]))
                                expect(el["addr"] as? EthereumAddress).to(equal(try EthereumAddress(hex: "0x000000000000000000000000000000000000dEaD", eip55: true)))
                                expect((el["b"] as? Data)?.toHexString()).to(equal("00000000001234567890"))
                            }
                            done()
                        }.catch { error in
                            fail(error.localizedDescription)
                        }
                    }
                }
            } catch {
                fail(error.localizedDescription)
            }

            // SIMPLE MULTIDIMENSIONAL STATIC CONTENT ARRAY RETURN EXAMPLE

            do {
                let contract = try web3.eth.Contract(json: data, abiKey: nil, address: .testAddress)

                it("should represent static content dynamic length multidimensional arrays") {
                    waitUntil(timeout: DispatchTimeInterval.seconds(2000)) { done in
                        if let tupleCallData = self.loadStub(named: "TupleExamples_returnSimpleMultidimensionalArray") {
                            provider.removeStub(method: "eth_call")
                            provider.addStub(method: "eth_call", data: tupleCallData)
                        }
                        firstly {
                            contract["returnSimpleMultidimensionalArray"]!().call()
                        }.done { outputs in
                            guard let t = outputs["returnArray"] as? [[BigUInt]], t.count == 2 else {
                                fail("returned array should be decoded and count should be 2")
                                return
                            }

                            expect(t[0]).to(equal([1, 2, 3]))
                            expect(t[1]).to(equal([4, 5, 6]))

                            done()
                        }.catch { error in
                            fail(error.localizedDescription)
                        }
                    }
                }
            } catch {
                fail(error.localizedDescription)
            }

            // NOT SO SIMPLE MULTIDIMENSIONAL TUPLE ARRAY RETURN EXAMPLE

            do {
                let contract = try web3.eth.Contract(json: data, abiKey: nil, address: .testAddress)

                it("should represent dynamic struct multidimensional arrays with tuples") {
                    waitUntil(timeout: DispatchTimeInterval.seconds(2000)) { done in
                        if let tupleCallData = self.loadStub(named: "TupleExamples_returnComplexStaticTupleMultidimensionalArray") {
                            provider.removeStub(method: "eth_call")
                            provider.addStub(method: "eth_call", data: tupleCallData)
                        }
                        firstly {
                            contract["returnComplexStaticTupleMultidimensionalArray"]!().call()
                        }.done { outputs in
                            guard let t = outputs["returnTupleArray"] as? [[[String: Any]]], t.count == 12 else {
                                fail("returned tuple array should be decoded and count should be 12")
                                return
                            }
                            for i in 0..<t.count {
                                let inner = t[i]
                                if i < 4 {
                                    expect(inner.count).to(equal(4))

                                    for j in 0..<inner.count {
                                        let el = inner[j]
                                        expect(el["s"] as? String).to(equal("abcdef123456"))
                                        expect(el["xArr"] as? [BigUInt]).to(equal([256, 512, 1024, 2048]))
                                        expect(el["addr"] as? EthereumAddress).to(equal(try EthereumAddress(hex: "0x000000000000000000000000000000000000dEaD", eip55: true)))
                                        expect((el["b"] as? Data)?.toHexString()).to(equal("00000000001234567890"))
                                    }
                                } else {
                                    expect(inner.count).to(equal(0))
                                }
                            }
                            done()
                        }.catch { error in
                            fail(error.localizedDescription)
                        }
                    }
                }
            } catch {
                fail(error.localizedDescription)
            }
        }

        describe("JSON Contract with fallback function") {
            let provider = MockWeb3Provider()
            stubResponses(provider: provider)
            let web3 = Web3(provider: provider)
            guard let data = loadStub(named: "Fallback") else { fail("Could not find stub for contract"); return }
            do {
                let contract = try web3.eth.Contract(json: data, abiKey: "abi", address: .testAddress)
                expect(contract).toNot(beNil())
            } catch {
                fail(error.localizedDescription)
            }
        }

    }
}
