//
//  UInt+BytesRepresentableTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 01.02.18.
//

import Quick
import Nimble
@testable import Web3

class UIntBytesRepresentableTests: QuickSpec {

    override func spec() {
        describe("int bytes representable") {
            context("special cases") {
                it("should be zero") {
                    let zero = UInt(0).makeBytes()

                    expect(zero.count) == MemoryLayout<UInt>.size

                    guard zero.count == MemoryLayout<UInt>.size else {
                        // We already expect that
                        return
                    }

                    for i in 0 ..< MemoryLayout<UInt>.size {
                        expect(zero[i]) == 0x00
                    }
                }

                it("should be int max") {
                    let max = UInt.max.makeBytes()

                    expect(max.count) == MemoryLayout<UInt>.size

                    guard max.count == MemoryLayout<UInt>.size else {
                        return
                    }

                    // For uint max value is 1111 1111 ....
                    for i in 0 ..< MemoryLayout<UInt>.size {
                        expect(max[i]) == 0xff
                    }
                }
            }

            context("two bytes") {
                it("should be 0x0400") {
                    let two = UInt(1024).makeBytes()

                    expect(two.count) == MemoryLayout<UInt>.size

                    guard two.count == MemoryLayout<UInt>.size else {
                        return
                    }

                    for i in 0 ..< MemoryLayout<UInt>.size - 2 {
                        expect(two[i]) == 0x00
                    }

                    expect(two[MemoryLayout<UInt>.size - 2]) == 0x04
                    expect(two[MemoryLayout<UInt>.size - 1]) == 0x00
                }
            }
        }
    }
}
