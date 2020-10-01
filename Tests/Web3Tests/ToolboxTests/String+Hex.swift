//
//  String+Hex.swift
//  Web3_Tests
//
//  Created by Josh Pyles on 5/25/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3

class StringBytesTests: QuickSpec {
    
    override func spec() {
        describe("hex string to bytes conversions") {
            context("hex string to bytes") {
                it("should convert hex string with prefix") {
                    let string = "0xFF"
                    let stringBytes = try? string.hexBytes()
                    expect(stringBytes).notTo(beNil())
                    expect(stringBytes?.count) == 1
                    expect(stringBytes?[0]) == UInt8(255)
                }
                it("should convert hex string without prefix") {
                    let string = "FF"
                    let stringBytes = try? string.hexBytes()
                    expect(stringBytes).notTo(beNil())
                    expect(stringBytes?.count) == 1
                    expect(stringBytes?[0]) == UInt8(255)
                }
                it("should convert hex string without leading zero") {
                    let string = "ABA"
                    let stringBytes = try? string.hexBytes()
                    expect(stringBytes).notTo(beNil())
                    expect(stringBytes?.count) == 2
                    expect(stringBytes?[0]) == UInt8(10)
                }
                it("should convert hex string with prefix and without leading zero") {
                    let string = "0xABA"
                    let stringBytes = try? string.hexBytes()
                    expect(stringBytes).notTo(beNil())
                    expect(stringBytes?.count) == 2
                    expect(stringBytes?[0]) == UInt8(10)
                }
                it("should convert compact hex string without prefix") {
                    let string = "5"
                    let stringBytes = try? string.hexBytes()
                    expect(stringBytes).notTo(beNil())
                    expect(stringBytes?.count) == 1
                    expect(stringBytes?[0]) == UInt8(5)
                }
                it("should not convert invalid hex string") {
                    let string = ""
                    let stringBytes = try? string.hexBytes()
                    expect(stringBytes).notTo(beNil())
                    expect(stringBytes?.count) == 0
                }
            }
        }
    }
}

