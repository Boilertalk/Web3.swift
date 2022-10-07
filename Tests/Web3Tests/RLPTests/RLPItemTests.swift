//
//  RLPItemTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 03.02.18.
//

import Quick
import Nimble
import BigInt
@testable import Web3

class RLPItemTests: QuickSpec {

    override func spec() {
        describe("rlp items") {
            context("reading / writing") {

                it("should be int 15") {
                    self.expectNumber(15)
                }

                it("should be int 1000") {
                    self.expectNumber(1000)
                }

                it("should be int 65537") {
                    self.expectNumber(65537)
                }

                it("should be int 0") {
                    self.expectNumber(0)
                }

                it("should be int Int.max") {
                    self.expectNumber(UInt(Int.max))
                }

                it("should be int UInt.max") {
                    self.expectNumber(UInt.max)
                }

                it("should be int 4_294_967_295") {
                    // 32 bit platform support...
                    self.expectNumber(4_294_967_295)
                }

                it("should be int 4 as big endian bytes") {
                    let i: RLPItem = .uint(0x8f2c6d9b)
                    expect(i.bytes) == [0x8f, 0x2c, 0x6d, 0x9b]
                }

                it("should be bigint 2 to the power of 156") {
                    let big = BigUInt(integerLiteral: 2).power(156)
                    let i: RLPItem = .bigUInt(big)

                    expect(i.bytes) == [
                        0x10, 0x00, 0x00, 0x00,
                        0x00, 0x00, 0x00, 0x00,
                        0x00, 0x00, 0x00, 0x00,
                        0x00, 0x00, 0x00, 0x00,
                        0x00, 0x00, 0x00, 0x00
                    ]

                    expect(i.bigUInt) == big
                    expect(i.uint).to(beNil())
                }

                it("should be a big bigint") {
                    let big: BigUInt = (0x10f000000000 << (6 * 8)) | (0xa0800402e00c)
                    let i: RLPItem = .bigUInt(big)

                    expect(i.bytes) == [
                        0x10, 0xf0, 0x00, 0x00,
                        0x00, 0x00, 0xa0, 0x80,
                        0x04, 0x02, 0xe0, 0x0c
                    ]
                    expect(i.bigUInt) == big
                    expect(i.uint).to(beNil())
                }
            }
        }
    }

    func expectNumber(_ uint: UInt) {
        let i: RLPItem = .uint(uint)
        let ret = i.uint
        expect(ret).toNot(beNil())
        guard let int = ret else {
            return
        }
        expect(int) == int
    }
}
