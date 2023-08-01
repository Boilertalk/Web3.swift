//
//  RLPDecoderTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 04.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3

class RLPDecoderTests: QuickSpec {

    override func spec() {
        let decoder = RLPDecoder()

        describe("rlp decoding") {
            context("strings / bytes") {

                it("should be dog") {
                    let bytes: [UInt8] = [0x83, 0x64, 0x6f, 0x67]
                    let i = try? decoder.decode(bytes)
                    expect(i).toNot(beNil())
                    guard let item = i else {
                        return
                    }

                    expect(item.bytes) == [0x64, 0x6f, 0x67] as [UInt8]

                    expect(item.string) == "dog"
                }

                it("should be the empty string") {
                    let i = try? decoder.decode([0x80])
                    expect(i).toNot(beNil())
                    guard let item = i else {
                        return
                    }

                    expect(item.bytes) == [] as [UInt8]

                    expect(item.string) == ""
                }

                it("should be the byte 0x00") {
                    let i = try? decoder.decode([0x00])
                    expect(i).toNot(beNil())
                    guard let item = i else {
                        return
                    }

                    expect(item.bytes) == [0x00] as [UInt8]

                    expect(item.uint) == 0
                }

                it("should be the integer 15") {
                    let i = try? decoder.decode([0x0f])
                    expect(i).toNot(beNil())
                    guard let item = i else {
                        return
                    }

                    expect(item.bytes) == [0x0f] as [UInt8]

                    expect(item.uint) == 15
                }

                it("should be the integer 1024") {
                    let i = try? decoder.decode([0x82, 0x04, 0x00])
                    expect(i).toNot(beNil())
                    guard let item = i else {
                        return
                    }

                    expect(item.bytes) == UInt(1024).makeBytes().trimLeadingZeros()

                    expect(item.uint) == 1024
                }

                it("should be the long latin string") {
                    let str = "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
                    let strBytes = str.makeBytes()
                    var rlp: [UInt8] = [0xb8, 0x38]
                    for b in strBytes {
                        rlp.append(b)
                    }
                    let i = try? decoder.decode(rlp)

                    expect(i).toNot(beNil())
                    guard let item = i else {
                        return
                    }

                    expect(item.bytes) == strBytes

                    expect(item.string) == str
                }
            }

            context("list items") {

                it("should be cat and dog") {
                    let rlp: [UInt8] = [0xc8, 0x83, 0x63, 0x61, 0x74, 0x83, 0x64, 0x6f, 0x67]

                    let i = try? decoder.decode(rlp)
                    expect(i).toNot(beNil())
                    guard let item = i else {
                        return
                    }

                    let a = item.array
                    expect(a).toNot(beNil())
                    guard let arr = a else {
                        return
                    }

                    expect(arr.count) == 2
                    guard arr.count == 2 else {
                        return
                    }

                    expect(arr[0].bytes) == [0x63, 0x61, 0x74]
                    expect(arr[0].string) == "cat"
                    expect(arr[1].bytes) == [0x64, 0x6f, 0x67]
                    expect(arr[1].string) == "dog"
                }

                it("should be the empty list") {
                    let i = try? decoder.decode([0xc0])
                    expect(i).toNot(beNil())
                    guard let item = i else {
                        return
                    }

                    expect(item.array).toNot(beNil())
                    expect(item.array?.count) == 0
                }

                it("should be the set theoretical representation of three") {
                    let rlp: [UInt8] = [0xc7, 0xc0, 0xc1, 0xc0, 0xc3, 0xc0, 0xc1, 0xc0]
                    let i = try? decoder.decode(rlp)
                    expect(i).toNot(beNil())
                    guard let item = i else {
                        return
                    }

                    expect(item.array?.count) == 3

                    expect(item.array?[safe: 0]?.array?.count) == 0

                    expect(item.array?[safe: 1]?.array?.count) == 1
                    expect(item.array?[safe: 1]?.array?[safe: 0]?.array?.count) == 0

                    expect(item.array?[safe: 2]?.array?.count) == 2
                    expect(item.array?[safe: 2]?.array?[safe: 0]?.array?.count) == 0
                    expect(item.array?[safe: 2]?.array?[safe: 1]?.array?.count) == 1
                    expect(item.array?[safe: 2]?.array?[safe: 1]?.array?[safe: 0]?.array?.count) == 0
                }
            }
        }
    }
}

fileprivate extension Collection {

    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
