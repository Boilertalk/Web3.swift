//
//  RLPItemTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 03.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
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

                it("should be int 4_294_967_297") {
                    self.expectNumber(4_294_967_297)
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
