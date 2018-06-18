//
//  BigDecimalTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 18.06.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3
import BigInt

class BigDecimalTests: QuickSpec {

    override func spec() {
        describe("big decimal tests") {

            context("arithmetic") {

                it("should multiply correctly") {

                    let simpleMult = BigDecimal(sign: .minus, exponent: 10, significand: 160000) * 120000
                    expect(simpleMult) == BigDecimal(BigInt(160000) * BigInt(10).power(10) * 120000 * -1)

                    let decimalMult = BigDecimal(sign: .plus, exponent: -22, significand: BigUInt(integerLiteral: 1234567890111)) * BigDecimal(sign: .plus, exponent: -12, significand: 1675)
                }
            }
        }
    }
}
