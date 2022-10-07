//
//  EthereumDataTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 13.02.18.
//

import Quick
import Nimble
@testable import Web3

class EthereumDataTests: QuickSpec {

    override func spec() {
        describe("ethereum data tests") {
            context("initialization") {

                let data = EthereumData([0xab, 0xcf, 0x45, 0x01])
                it("should initialize correctly") {
                    expect(data.bytes) == [0xab, 0xcf, 0x45, 0x01]
                    expect(data.makeBytes()) == [0xab, 0xcf, 0x45, 0x01]
                }

                let data2 = EthereumData([0xab, 0xcf, 0x45, 0x01])

                it("should be equatable") {
                    expect(data == data2) == true
                }

                it("should produce correct hashValues") {
                    expect(data.hashValue) == data2.hashValue
                }
            }

            context("ethereum value convertible") {

                it("should initialize correctly") {
                    let data = try? EthereumData(ethereumValue: "0x01020304ff")
                    expect(data).toNot(beNil())
                    expect(data?.bytes) == [0x01, 0x02, 0x03, 0x04, 0xff]
                    expect(data?.hex()) == "0x01020304ff"

                    let data2 = try? EthereumData(ethereumValue: "0x")
                    expect(data2).toNot(beNil())
                    expect(data2?.bytes) == []
                    expect(data2?.hex()) == "0x"

                    do {
                        let q = try EthereumData(ethereumValue: true)
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try EthereumData(ethereumValue: 123)
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try EthereumData(ethereumValue: [true, false])
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try EthereumData(ethereumValue: "//()...")
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(StringHexBytesError.hexStringMalformed))
                    }
                }

                it("should return correct data") {
                    let data = EthereumValue.string("0xabffcc").ethereumData
                    expect(data).toNot(beNil())
                    expect(data?.hex()) == "0xabffcc"
                    expect(data?.bytes) == [0xab, 0xff, 0xcc]
                }
            }
        }
    }
}
