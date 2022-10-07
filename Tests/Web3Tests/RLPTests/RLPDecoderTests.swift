//
//  RLPDecoderTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 04.02.18.
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

                it("should be a signed transaction") {
                    let h = "f86d808504e3b29200825208943011f9a95fe30585ec5b3a555a62a51fab941b16890138400eca364a00008026a063b2edbba05d7b2e26d97174553478724b9c305323a67fee43fd333a1e336f06a0389874858c39fddf5437220d90531c649f0da592403df0c1915cb0f720535e0a".hexByteArray()
                    expect(h).toNot(beNil())
                    guard let hex = h else {
                        return
                    }

                    let i = try? decoder.decode(hex)
                    expect(i).toNot(beNil())
                    guard let item = i else {
                        return
                    }

                    expect(item.array?[safe: 0]?.bytes) == []
                    expect(item.array?[safe: 1]?.bytes) == [0x4, 0xe3, 0xb2, 0x92, 0x0]
                    expect(item.array?[safe: 2]?.bytes) == [0x52, 0x8]
                    expect(item.array?[safe: 3]?.bytes) == [0x30, 0x11, 0xf9, 0xa9, 0x5f, 0xe3, 0x5, 0x85, 0xec, 0x5b, 0x3a, 0x55, 0x5a, 0x62, 0xa5, 0x1f, 0xab, 0x94, 0x1b, 0x16]
                    expect(item.array?[safe: 4]?.bytes) == [0x1, 0x38, 0x40, 0xe, 0xca, 0x36, 0x4a, 0x0, 0x0]
                    expect(item.array?[safe: 5]?.bytes) == []
                    expect(item.array?[safe: 6]?.bytes) == [0x26]
                    expect(item.array?[safe: 7]?.bytes) == [0x63, 0xb2, 0xed, 0xbb, 0xa0, 0x5d, 0x7b, 0x2e, 0x26, 0xd9, 0x71, 0x74, 0x55, 0x34, 0x78, 0x72, 0x4b, 0x9c, 0x30, 0x53, 0x23, 0xa6, 0x7f, 0xee, 0x43, 0xfd, 0x33, 0x3a, 0x1e, 0x33, 0x6f, 0x6]
                    expect(item.array?[safe: 8]?.bytes) == [0x38, 0x98, 0x74, 0x85, 0x8c, 0x39, 0xfd, 0xdf, 0x54, 0x37, 0x22, 0xd, 0x90, 0x53, 0x1c, 0x64, 0x9f, 0xd, 0xa5, 0x92, 0x40, 0x3d, 0xf0, 0xc1, 0x91, 0x5c, 0xb0, 0xf7, 0x20, 0x53, 0x5e, 0xa]
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

                it("should be an array of long latin strings") {
                    let str = "Lorem ipsum dolor sit amet, consectetur adipisicing elit"
                    let strBytes = str.makeBytes()

                    var rlp: [UInt8] = [0xf8, 0x74]
                    for _ in 0..<2 {
                        rlp.append(0xb8)
                        rlp.append(0x38)

                        for b in strBytes {
                            rlp.append(b)
                        }
                    }

                    let item = try? decoder.decode(rlp)
                    expect(item).toNot(beNil())

                    expect(item?.array?[safe: 0]?.bytes) == strBytes
                    expect(item?.array?[safe: 0]?.string) == str

                    expect(item?.array?[safe: 1]?.bytes) == strBytes
                    expect(item?.array?[safe: 1]?.string) == str
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

fileprivate extension String {

    func hexByteArray() -> [UInt8]? {
        guard count % 2 == 0 else {
            return nil
        }
        var hex = [UInt8]()
        for i in stride(from: 0, to: count, by: 2) {
            let s = self.index(self.startIndex, offsetBy: i)
            let e = self.index(self.startIndex, offsetBy: i + 2)
            guard let byte = UInt8(String(self[s..<e]), radix: 16) else {
                return nil
            }
            hex.append(byte)
        }

        return hex
    }
}
