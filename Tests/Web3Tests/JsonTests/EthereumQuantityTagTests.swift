//
//  EthereumQuantityTagTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 13.02.18.
//

import Quick
import Nimble
@testable import Web3

class EthereumQuantityTagTests: QuickSpec {

    override func spec() {
        describe("ethereum quantity tag tests") {
            context("initialization") {

                it("should initialize correctly") {
                    let t: EthereumQuantityTag = .latest
                    expect(t.tagType == .latest) == true

                    let t2: EthereumQuantityTag = .earliest
                    expect(t2.tagType == .earliest) == true

                    let t3: EthereumQuantityTag = .pending
                    expect(t3.tagType == .pending) == true

                    let t4: EthereumQuantityTag = .block(100)
                    expect(t4.tagType == .block(100)) == true

                    let t5: EthereumQuantityTag? = try? .string("latest")
                    expect(t5?.tagType == .latest) == true

                    let t6: EthereumQuantityTag? = try? .string("earliest")
                    expect(t6?.tagType == .earliest) == true

                    let t7: EthereumQuantityTag? = try? .string("pending")
                    expect(t7?.tagType == .pending) == true

                    let t8: EthereumQuantityTag? = try? .string("0x12345")
                    expect(t8?.tagType == .block(0x12345)) == true
                }

                it("should not initialize") {
                    do {
                        let q = try EthereumQuantityTag(ethereumValue: true)
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try EthereumQuantityTag(ethereumValue: ["latest"])
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try EthereumQuantityTag(ethereumValue: "latee")
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try EthereumQuantityTag(ethereumValue: "0xxx0")
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try EthereumQuantityTag(ethereumValue: 12345)
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }
                }
            }

            context("conversion") {

                it("should convert to ethereum value") {
                    expect(EthereumQuantityTag.latest.ethereumValue().string) == "latest"
                    expect(EthereumQuantityTag.earliest.ethereumValue().string) == "earliest"
                    expect(EthereumQuantityTag.pending.ethereumValue().string) == "pending"
                    expect(EthereumQuantityTag.block(124000).ethereumValue().string) == "0x1e460"
                }
            }

            context("equatable") {
                it("should be equal") {
                    expect(EthereumQuantityTag.TagType.latest == .latest) == true
                    expect(EthereumQuantityTag.TagType.earliest == .earliest) == true
                    expect(EthereumQuantityTag.TagType.pending == .pending) == true
                    expect(EthereumQuantityTag.TagType.block(1024) == .block(1024)) == true
                }

                it("should not be equal") {
                    expect(EthereumQuantityTag.TagType.latest == .earliest) == false
                    expect(EthereumQuantityTag.TagType.earliest == .latest) == false
                    expect(EthereumQuantityTag.TagType.pending == .block(128)) == false
                    expect(EthereumQuantityTag.TagType.block(256) == .pending) == false
                    expect(EthereumQuantityTag.TagType.block(256) == .block(255)) == false
                }
            }

            context("hashable") {
                it("should produce correct hashValues") {
                    let t: EthereumQuantityTag = .latest
                    expect(t.hashValue) == EthereumQuantityTag.latest.hashValue

                    let t2: EthereumQuantityTag = .earliest
                    expect(t2.hashValue) == EthereumQuantityTag.earliest.hashValue

                    let t3: EthereumQuantityTag = .pending
                    expect(t3.hashValue) == EthereumQuantityTag.pending.hashValue

                    let t4: EthereumQuantityTag = .block(100)
                    expect(t4.hashValue) == EthereumQuantityTag.block(100).hashValue
                }
            }
        }
    }
}
