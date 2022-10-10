//
//  EthereumQuantityTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 13.02.18.
//

import Quick
import Nimble
@testable import Web3
import BigInt

class EthereumQuantityTests: QuickSpec {

    override func spec() {
        describe("ethereum quantity tests") {
            context("initialization") {

                it("should initialize correctly") {
                    let q = EthereumQuantity.bytes([0x25, 0xcc, 0xe9, 0xf5])
                    expect(q.quantity) == BigUInt(634186229)

                    let q2 = EthereumQuantity(quantity: BigUInt(100000000))
                    expect(q2.quantity) == BigUInt(100000000)

                    let q3: EthereumQuantity = 2024
                    expect(q3.quantity) == BigUInt(2024)

                    let q4 = try? EthereumQuantity.string("0x1234")
                    expect(q4).toNot(beNil())
                    expect(q4?.quantity) == BigUInt(0x1234)

                    let q5 = try? EthereumQuantity(ethereumValue: "0x12345")
                    expect(q5).toNot(beNil())
                    expect(q5?.quantity) == BigUInt(0x12345)
                }

                it("should not initialize") {
                    do {
                        let q = try EthereumQuantity(ethereumValue: true)
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try EthereumQuantity(ethereumValue: [1, 2, true, false])
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try EthereumQuantity(ethereumValue: "0x0x0x0x")
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(StringHexBytesError.hexStringMalformed))
                    }
                }
            }

            context("conversions") {

                it("should convert correctly from ethereum value") {
                    let q = EthereumValue.string("0x1234").ethereumQuantity
                    expect(q).toNot(beNil())
                    expect(q?.quantity) == BigUInt(0x1234)

                    expect(EthereumValue.bool(true).ethereumQuantity).to(beNil())
                }

                it("should produce minimized hex strings") {
                    let q = try? EthereumQuantity.string("0x")
                    expect(q).toNot(beNil())
                    expect(q?.hex()) == "0x0"

                    let q2 = try? EthereumQuantity.string("0x0")
                    expect(q2).toNot(beNil())
                    expect(q2?.hex()) == "0x0"

                    let q3 = try? EthereumQuantity.string("0x0123456")
                    expect(q3).toNot(beNil())
                    expect(q3?.hex()) == "0x123456"

                    let q4 = try? EthereumQuantity.string("0x000abcdef")
                    expect(q4).toNot(beNil())
                    expect(q4?.hex()) == "0xabcdef"
                }
            }

            context("hashable") {
                it("should produce correct hashValues") {
                    let q = EthereumQuantity.bytes([0x25, 0xcc, 0xe9, 0xf5])
                    expect(q.hashValue) == EthereumQuantity.bytes([0x25, 0xcc, 0xe9, 0xf5]).hashValue

                    let q2 = EthereumQuantity(quantity: BigUInt(100000000))
                    expect(q2.hashValue) == EthereumQuantity(quantity: BigUInt(100000000)).hashValue

                    let q3: EthereumQuantity = 2024
                    expect(q3.hashValue) == EthereumQuantity(integerLiteral: 2024).hashValue
                }
            }
        }
    }
}
