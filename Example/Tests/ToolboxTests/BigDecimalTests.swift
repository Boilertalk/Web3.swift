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
                    expect(decimalMult) == BigDecimal(sign: .plus, exponent: -34, significand: 2067901215935925)

                    let minusMult = BigDecimal(-10) * BigDecimal(-12)
                    expect(minusMult) == BigDecimal(120)

                    var altMult = BigDecimal(22.1234)
                    altMult *= BigDecimal(-2.8888)
                    expect(altMult) == BigDecimal(22.1234) * BigDecimal(-2.8888)
                }

                it("should add correctly") {

                    let simpleAddition = BigDecimal(sign: .plus, exponent: 2, significand: 160000) + 120000
                    expect(simpleAddition) == BigDecimal(16120000)
                }
            }
        }
    }
}
