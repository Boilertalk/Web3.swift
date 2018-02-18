//
//  EthereumSyncStatusObjectTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 13.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3
import BigInt
import Foundation

class EthereumSyncStatusObjectTests: QuickSpec {

    var encoder: JSONEncoder = JSONEncoder()
    var decoder: JSONDecoder = JSONDecoder()

    override func spec() {
        describe("ethereum sync status object tests") {
            context("encoding") {

                it("should encode successfully") {
                    let status = EthereumSyncStatusObject()

                    let encoded = try? self.encoder.encode([status])
                    expect(encoded).toNot(beNil())

                    expect(encoded?.makeBytes().makeString()) == "[false]"

                    let statusAlt = EthereumSyncStatusObject(startingBlock: 10000, currentBlock: 20000, highestBlock: 30000)

                    let encodedAlt = try? self.encoder.encode(statusAlt)
                    expect(encodedAlt).toNot(beNil())

                    expect(encodedAlt?.makeBytes().makeString()) == "{\"startingBlock\":\"0x2710\",\"currentBlock\":\"0x4e20\",\"highestBlock\":\"0x7530\"}"
                }
            }

            context("decoding") {

                it("should decode successfully") {
                    let string = "[false]"

                    let decoded = try? self.decoder.decode([EthereumSyncStatusObject].self, from: Data(string.makeBytes()))
                    expect(decoded).toNot(beNil())

                    expect(decoded?.count) == 1
                    expect(decoded?.first?.syncing) == false
                    expect(decoded?.first?.startingBlock).to(beNil())
                    expect(decoded?.first?.currentBlock).to(beNil())
                    expect(decoded?.first?.highestBlock).to(beNil())

                    let stringAlt = "{\"startingBlock\":\"0x2710\",\"currentBlock\":\"0x4e20\",\"highestBlock\":\"0x7530\"}"

                    let decodedAlt = try? self.decoder.decode(EthereumSyncStatusObject.self, from: Data(stringAlt.makeBytes()))
                    expect(decodedAlt).toNot(beNil())

                    expect(decodedAlt?.syncing) == true
                    expect(decodedAlt?.startingBlock?.quantity) == BigUInt(10000)
                    expect(decodedAlt?.currentBlock?.quantity) == BigUInt(20000)
                    expect(decodedAlt?.highestBlock?.quantity) == BigUInt(30000)
                }
            }
        }
    }
}
