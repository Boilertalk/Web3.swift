//
//  Int+ETH.swift
//  Web3_Tests
//
//  Created by Koray Koska on 14.03.18.
//

import Quick
import Nimble
@testable import Web3
import BigInt

class IntETHTests: QuickSpec {

    override func spec() {
        describe("int eth conversions") {
            context("eth to wei") {
                it("should be pow(10, 18)") {
                    let one = UInt(1).eth

                    expect(one) == BigUInt(10).power(18)

                    let oneSigned = 1.eth

                    expect(oneSigned) == BigUInt(10).power(18)
                }

                it("should be 0") {
                    let zero = (-1000).eth

                    expect(zero) == BigUInt(0)

                    expect(0.eth) == BigUInt(0)
                }

                it("should be 1234 * pow(10, 18)") {
                    let big = UInt(1234).eth

                    expect(big) == BigUInt(1234) * BigUInt(10).power(18)

                    let signedBig = 1234.eth

                    expect(signedBig) == BigUInt(1234) * BigUInt(10).power(18)
                }
            }

            context("gwei to wei") {
                it("should be pow(10, 9)") {
                    let one = UInt(1).gwei

                    expect(one) == BigUInt(10).power(9)

                    let oneSigned = 1.gwei

                    expect(oneSigned) == BigUInt(10).power(9)
                }

                it("should be 0") {
                    let gweiZero = (-1818).gwei

                    expect(gweiZero) == BigUInt(0)

                    expect(0.gwei) == BigUInt(0)
                }

                it("should be 1234 * pow(10, 9)") {
                    let big = UInt(1234).gwei

                    expect(big) == BigUInt(1234) * BigUInt(10).power(9)

                    let signedBig = 1234.gwei

                    expect(signedBig) == BigUInt(1234) * BigUInt(10).power(9)
                }
            }
        }
    }
}
