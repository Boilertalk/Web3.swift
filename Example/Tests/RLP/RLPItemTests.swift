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
                it("should be int 1000") {
                    let i: RLPItem = 15
                    let ret = i.uint
                    expect(ret).toNot(beNil())
                    guard let int = ret else {
                        return
                    }
                    expect(int) == 15
                }
            }
        }
    }
}
