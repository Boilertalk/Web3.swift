//
//  ContractABITypeTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 28.05.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3
import Foundation

class ContractABITypeTests: QuickSpec {

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    override func spec() {
        describe("contract abi tests") {

            context("equatable") {

                it("should be equal static types") {
                    expect(ContractABIType.address) == .address
                    expect(ContractABIType.bool) == .bool
                    expect(ContractABIType.dynamicBytes) == .dynamicBytes
                    expect(ContractABIType.dynamicString) == .dynamicString
                }

                it("shoult not be equal static types") {
                    expect(ContractABIType.address) != .dynamicString
                    expect(ContractABIType.bool) != .dynamicBytes
                    expect(ContractABIType.dynamicBytes) != .bool
                    expect(ContractABIType.dynamicString) != .address
                }

                it("should be equal dynamic types") {
                    expect(ContractABIType.uint(bits: 32)) == .uint(bits: 32)
                    expect(ContractABIType.uint(bits: 64)) == .uint(bits: 64)

                    expect(ContractABIType.fixed(bits: 128, dividerExponent: 16)) == .fixed(bits: 128, dividerExponent: 16)
                    expect(ContractABIType.ufixed(bits: 128, dividerExponent: 16)) == .ufixed(bits: 128, dividerExponent: 16)

                    expect(ContractABIType.bytes(count: 32)) == .bytes(count: 32)

                    expect(ContractABIType.array(type: .address, count: 1292)) == .array(type: .address, count: 1292)
                    expect(ContractABIType.array(type: .array(type: .dynamicBytes, count: 100), count: 1292)) == .array(type: .array(type: .dynamicBytes, count: 100), count: 1292)

                    expect(ContractABIType.dynamicArray(type: .bool)) == .dynamicArray(type: .bool)
                    expect(ContractABIType.dynamicArray(type: .array(type: .dynamicArray(type: .dynamicString), count: 200))) == ContractABIType.dynamicArray(type: .array(type: .dynamicArray(type: .dynamicString), count: 200))

                    expect(ContractABIType.tuple(types: [.tuple(types: [.tuple(types: [.address, .bool])]), .dynamicString])) == .tuple(types: [.tuple(types: [.tuple(types: [.address, .bool])]), .dynamicString])
                }

                it("should not be equal dynamic types") {
                    expect(ContractABIType.uint(bits: 32)) != .uint(bits: 33)
                    expect(ContractABIType.uint(bits: 64)) != .uint(bits: 63)

                    expect(ContractABIType.fixed(bits: 128, dividerExponent: 16)) != .fixed(bits: 127, dividerExponent: 16)
                    expect(ContractABIType.ufixed(bits: 128, dividerExponent: 16)) != .ufixed(bits: 128, dividerExponent: 15)

                    expect(ContractABIType.bytes(count: 32)) != .bytes(count: 16)

                    expect(ContractABIType.array(type: .address, count: 1292)) != .array(type: .bool, count: 1292)
                    expect(ContractABIType.array(type: .address, count: 1292)) != .array(type: .address, count: 1200)
                    expect(ContractABIType.array(type: .array(type: .dynamicBytes, count: 100), count: 1292)) != .array(type: .array(type: .dynamicString, count: 100), count: 1292)
                    expect(ContractABIType.array(type: .array(type: .dynamicBytes, count: 100), count: 1292)) != .array(type: .array(type: .dynamicString, count: 99), count: 1292)

                    expect(ContractABIType.dynamicArray(type: .bool)) != .dynamicArray(type: .address)
                    expect(ContractABIType.dynamicArray(type: .bool)).toNot(be(ContractABIType.dynamicArray(type: .bytes(count: 32))))
                    expect(ContractABIType.dynamicArray(type: .array(type: .dynamicArray(type: .dynamicString), count: 200))) != ContractABIType.dynamicArray(type: .array(type: .dynamicArray(type: .dynamicString), count: 100))
                    expect(ContractABIType.dynamicArray(type: .array(type: .dynamicArray(type: .dynamicString), count: 200))) != ContractABIType.dynamicArray(type: .array(type: .dynamicArray(type: .bool), count: 200))

                    expect(ContractABIType.tuple(types: [.tuple(types: [.tuple(types: [.address, .bool])]), .dynamicString])) != .tuple(types: [.tuple(types: [.tuple(types: [.address, .address])]), .dynamicString])
                }
            }

            context("decodable") {

                it("should decode types") {

                    let typesStr = "[\"uint256\",\"uint\",\"uint32\",\"int\",\"fixed\",\"fixed32x12\",\"ufixed16x6\",\"bytes[][][5]\",\"bytes32[][10]\",\"string\",\"bytes\",\"(bool[][10][],bytes[5][10][])\"]".data(using: .utf8)
                    expect(typesStr).toNot(beNil())

                    let types = try? self.decoder.decode([ContractABIType].self, from: typesStr!)
                    expect(types).toNot(beNil())

                    expect(types?.count) == 12

                    expect(types?[0]) == .uint(bits: 256)
                    expect(types?[1]) == .uint(bits: 256)
                    expect(types?[2]) == .uint(bits: 32)
                    expect(types?[3]) == .int(bits: 256)
                    expect(types?[4]) == .fixed(bits: 128, dividerExponent: 18)
                    expect(types?[5]) == .fixed(bits: 32, dividerExponent: 12)
                    expect(types?[6]) == .ufixed(bits: 16, dividerExponent: 6)
                    expect(types?[7]) == .array(type: .dynamicArray(type: .dynamicArray(type: .dynamicBytes)), count: 5)
                    expect(types?[8]) == .array(type: .dynamicArray(type: .bytes(count: 32)), count: 10)
                    expect(types?[9]) == .dynamicString
                    expect(types?[10]) == .dynamicBytes
                    expect(types?[11]) == .tuple(types: [.dynamicArray(type: .array(type: .dynamicArray(type: .bool), count: 10)), .dynamicArray(type: .array(type: .array(type: .dynamicBytes, count: 5), count: 10))])
                }
            }

            context("encodable") {

                it("should encode types") {

                    expect(try? self.encoder.encode([ContractABIType.uint(bits: 256)])) == "[\"uint256\"]".data(using: .utf8)
                    expect(try? self.encoder.encode([ContractABIType.fixed(bits: 128, dividerExponent: 18)])) == "[\"fixed128x18\"]".data(using: .utf8)

                    expect(try? self.encoder.encode([ContractABIType.array(type: .dynamicArray(type: .dynamicArray(type: .dynamicBytes)), count: 12)])) == "[\"bytes[][][12]\"]".data(using: .utf8)
                    expect(try? self.encoder.encode([ContractABIType.array(type: .dynamicArray(type: .bytes(count: 32)), count: 10)])) == "[\"bytes32[][10]\"]".data(using: .utf8)

                    expect(try? self.encoder.encode([ContractABIType.tuple(types: [.dynamicArray(type: .array(type: .dynamicArray(type: .bool), count: 10)), .dynamicArray(type: .array(type: .array(type: .dynamicBytes, count: 5), count: 10))])])) == "[\"(bool[][10][],bytes[5][10][])\"]".data(using: .utf8)
                }
            }
        }
    }
}
