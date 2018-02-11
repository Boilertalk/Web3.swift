//
//  EthereumCallParamsTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 11.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3
import BigInt

class EthereumCallParamsTests: QuickSpec {

    var encoder: JSONEncoder = JSONEncoder()
    var decoder: JSONDecoder = JSONDecoder()

    override func spec() {
        describe("ethereum call params") {

            beforeEach {
                self.encoder = JSONEncoder()
                self.decoder = JSONDecoder()
            }

            context("encoding") {

                it("should encode successfully") {
                    let e = try? EthereumCallParams(
                        from: EthereumAddress(hex: "0x52bc44d5378309EE2abF1539BF71dE1b7d7bE3b5", eip55: true),
                        to: EthereumAddress(hex: "0x829BD824B016326A401d083B33D092293333A830", eip55: true),
                        gas: 21000,
                        gasPrice: EthereumQuantity(quantity: UInt(21).gwei),
                        value: 10,
                        data: EthereumData(bytes: [0x00, 0xff]),
                        block: .latest
                    )
                    expect(e).toNot(beNil())

                    let str = "[{\"value\":\"0xa\",\"to\":\"0x829bd824b016326a401d083b33d092293333a830\",\"gas\":\"0x5208\",\"data\":\"0x00ff\",\"gasPrice\":\"0x4e3b29200\",\"from\":\"0x52bc44d5378309ee2abf1539bf71de1b7d7be3b5\"},\"latest\"]"

                    expect(try? self.encoder.encode(e!).makeString()) == str
                }
            }

            context("decoding") {

                it("should decode successfully") {
                    let str = "[{\"value\":\"0xa\",\"to\":\"0x829bd824b016326a401d083b33d092293333a830\",\"gas\":\"0x5208\",\"data\":\"0x00ff\",\"gasPrice\":\"0x4e3b29200\",\"from\":\"0x52bc44d5378309ee2abf1539bf71de1b7d7be3b5\"},\"latest\"]"
                    let e = try? self.decoder.decode(EthereumCallParams.self, from: Data(bytes: str.makeBytes()))
                    expect(e).toNot(beNil())

                    expect(e?.block.tagType) == EthereumQuantityTag.TagType.latest
                    expect(e?.to.hex(eip55: true)) == "0x829BD824B016326A401d083B33D092293333A830"
                    expect(e?.gas?.quantity) == BigUInt(21000)
                }
            }
        }
    }
}
