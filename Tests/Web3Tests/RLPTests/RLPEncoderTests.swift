//
//  RLPEncoderTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 03.02.18.
//

import Quick
import Nimble
@testable import Web3

class RLPEncoderTests: QuickSpec {

    override func spec() {
        let encoder = RLPEncoder()

        describe("rlp encoding") {
            context("strings / bytes") {

                it("should be dog as rlp") {
                    let r = try? encoder.encode("dog")
                    guard let rlp = self.expectCount(r, count: 4) else {
                        return
                    }

                    expect(rlp[0]) == 0x83
                    expect(rlp[1]) == 0x64
                    expect(rlp[2]) == 0x6f
                    expect(rlp[3]) == 0x67
                }

                it("should be the empty string") {
                    let r = try? encoder.encode("")
                    guard let rlp = self.expectCount(r, count: 1) else {
                        return
                    }

                    expect(rlp[0]) == 0x80
                }

                it("should be the encoded byte 0x00") {
                    let r = try? encoder.encode(.bytes(0x00))
                    guard let rlp = self.expectCount(r, count: 1) else {
                        return
                    }

                    expect(rlp[0]) == 0x00
                }

                it("should be the integer 15") {
                    let r = try? encoder.encode(15)
                    guard let rlp = self.expectCount(r, count: 1) else {
                        return
                    }

                    expect(rlp[0]) == 0x0f
                }

                it("should be the integer 1024") {
                    let r = try? encoder.encode(1024)
                    guard let rlp = self.expectCount(r, count: 3) else {
                        return
                    }

                    expect(rlp[0]) == 0x82
                    expect(rlp[1]) == 0x04
                    expect(rlp[2]) == 0x00
                }

                it("should be the long latin string") {
                    let str = "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
                    let r = try? encoder.encode(.string(str))
                    guard let rlp = self.expectCount(r, count: 58) else {
                        return
                    }

                    expect(rlp[0]) == 0xb8
                    expect(rlp[1]) == 0x38
                    let rlpString = Array(rlp[2..<58])
                    self.expectGeneralRLPString(string: str, rlp: rlpString)
                }
            }

            context("list items") {

                it("should be cat and dog as rlp list") {
                    let r = try? encoder.encode(["cat", "dog"])
                    guard let rlp = self.expectCount(r, count: 9) else {
                        return
                    }

                    expect(rlp[0]) == 0xc8

                    let cat = Array(rlp[1..<5])
                    self.expectBasicRLPString(prefix: 0x83, string: "cat", rlp: cat)

                    let dog = Array(rlp[5..<9])
                    self.expectBasicRLPString(prefix: 0x83, string: "dog", rlp: dog)
                }

                it("should be the empty list") {
                    let r = try? encoder.encode([])
                    guard let rlp = self.expectCount(r, count: 1) else {
                        return
                    }

                    expect(rlp[0]) == 0xc0
                }

                it("should be the set theoretical representation of three") {
                    let r = try? encoder.encode([ [], [[]], [ [], [[]] ] ])
                    guard let rlp = self.expectCount(r, count: 8) else {
                        return
                    }

                    expect(rlp[0]) == 0xc7
                    expect(rlp[1]) == 0xc0
                    expect(rlp[2]) == 0xc1
                    expect(rlp[3]) == 0xc0
                    expect(rlp[4]) == 0xc3
                    expect(rlp[5]) == 0xc0
                    expect(rlp[6]) == 0xc1
                    expect(rlp[7]) == 0xc0
                }

                it("should be an array of long latin strings") {
                    let str = "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
                    let r = try? encoder.encode([.string(str), .string(str)])
                    guard let rlp = self.expectCount(r, count: 118) else {
                        return
                    }

                    expect(rlp[0]) == 0xf8
                    expect(rlp[1]) == 0x74

                    expect(rlp[2]) == 0xb8
                    expect(rlp[3]) == 0x38
                    let rlpStringOne = Array(rlp[4..<60])
                    self.expectGeneralRLPString(string: str, rlp: rlpStringOne)

                    expect(rlp[60]) == 0xb8
                    expect(rlp[61]) == 0x38
                    let rlpStringTwo = Array(rlp[62..<118])
                    self.expectGeneralRLPString(string: str, rlp: rlpStringTwo)
                }
            }
        }
    }

    func expectCount(_ rlp: [UInt8]?, count: Int) -> [UInt8]? {
        expect(rlp).toNot(beNil())
        guard let r = rlp else {
            return nil
        }
        expect(r.count) == count
        guard r.count == count else {
            return nil
        }

        return r
    }

    func expectBasicRLPString(prefix: UInt8, string: String, rlp: [UInt8]) {
        let stringBytes = string.makeBytes()
        expect(stringBytes.count) == rlp.count - 1
        guard stringBytes.count == rlp.count - 1 else {
            return
        }

        expect(prefix) == rlp[0]
        for i in 1 ..< rlp.count {
            expect(rlp[i]) == stringBytes[i - 1]
        }
    }

    func expectGeneralRLPString(string: String, rlp: [UInt8]) {
        let stringBytes = string.makeBytes()
        expect(stringBytes.count) == rlp.count
        guard stringBytes.count == rlp.count else {
            return
        }

        for i in 0 ..< rlp.count {
            expect(rlp[i]) == stringBytes[i]
        }
    }
}
