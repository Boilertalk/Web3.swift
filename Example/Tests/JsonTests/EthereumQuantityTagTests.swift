//
//  EthereumQuantityTagTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 13.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
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
                    expect{ try EthereumQuantityTag(ethereumValue: true) }.to(throwError(EthereumValueInitializableError.notInitializable))
                    expect{ try EthereumQuantityTag(ethereumValue: ["latest"]) }.to(throwError(EthereumValueInitializableError.notInitializable))
                    expect{ try EthereumQuantityTag(ethereumValue: "latee") }.to(throwError(EthereumValueInitializableError.notInitializable))
                    expect{ try EthereumQuantityTag(ethereumValue: "0xxx0") }.to(throwError(EthereumValueInitializableError.notInitializable))
                    expect{ try EthereumQuantityTag(ethereumValue: 12345) }.to(throwError(EthereumValueInitializableError.notInitializable))
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
        }
    }
}
