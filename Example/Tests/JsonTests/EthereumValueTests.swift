//
//  EthereumValueTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 13.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3

class EthereumValueTests: QuickSpec {

    var encoder: JSONEncoder = JSONEncoder()
    var decoder: JSONDecoder = JSONDecoder()

    override func spec() {
        describe("ethereum call params") {
            context("int values") {

                it("should encode successfully") {
                    let value: EthereumValue = 10
                    let value2: EthereumValue = .int(100)
                    let valueEdge0: EthereumValue = 0
                    let valueEdge1: EthereumValue = 1

                    let encoded = try? self.encoder.encode([value, value2, valueEdge0, valueEdge1])

                    expect(encoded).toNot(beNil())
                    expect(encoded?.makeBytes().makeString()) == "[10,100,0,1]"
                }

                it("should decode successfully") {
                    let encoded = "[10,100,0,1]"

                    let decoded = try? self.decoder.decode(EthereumValue.self, from: Data(encoded.makeBytes()))

                    expect(decoded).toNot(beNil())
                    expect(decoded?.array?.count) == 4
                    expect(decoded?.array?[safe: 0]?.int) == 10
                    expect(decoded?.array?[safe: 1]?.int) == 100

                    expect(decoded?.array?[safe: 2]?.bool).to(beNil())
                    expect(decoded?.array?[safe: 3]?.bool).to(beNil())
                    expect(decoded?.array?[safe: 2]?.int) == 0
                    expect(decoded?.array?[safe: 3]?.int) == 1
                }
            }

            context("bool values") {

                it("should encode successfully") {
                    let value: EthereumValue = true
                    let value2: EthereumValue = .bool(false)

                    let encoded = try? self.encoder.encode([value, value2])

                    expect(encoded).toNot(beNil())
                    expect(encoded?.makeBytes().makeString()) == "[true,false]"
                }

                it("should decode successfully") {
                    let encoded = "[true,false]"

                    let decoded = try? self.decoder.decode(EthereumValue.self, from: Data(encoded.makeBytes()))

                    expect(decoded).toNot(beNil())
                    expect(decoded?.array?.count) == 2
                    expect(decoded?.array?[safe: 0]?.bool) == true
                    expect(decoded?.array?[safe: 1]?.bool) == false

                    expect(decoded?.array?[safe: 0]?.int).to(beNil())
                    expect(decoded?.array?[safe: 0]?.array).to(beNil())
                    expect(decoded?.array?[safe: 0]?.string).to(beNil())
                }
            }

            context("nil values") {

                it("should encode successfully") {
                    let value = EthereumValue(valueType: .nil)

                    let encoded = try? self.encoder.encode([value, value])

                    expect(encoded).toNot(beNil())
                    expect(encoded?.makeBytes().makeString()) == "[null,null]"
                }

                it("should decode successfully") {
                    let encoded = "[null,null]"

                    let decoded = try? self.decoder.decode(EthereumValue.self, from: Data(encoded.makeBytes()))

                    expect(decoded?.array?.count) == 2
                    // TODO: Add nil checking...
                }
            }

            context("array values") {

                it("should encode successfully") {
                    let value: EthereumValue = .array(
                        [
                            [] as EthereumValue,
                            [] as EthereumValue,
                            [] as EthereumValue,
                            ["hello"] as EthereumValue,
                            [100] as EthereumValue,
                            false,
                            [true] as EthereumValue,
                            0,
                            1
                        ]
                    )

                    let json = try? self.encoder.encode(value)
                    expect(json).toNot(beNil())
                    expect(json?.makeBytes().makeString()) == "[[],[],[],[\"hello\"],[100],false,[true],0,1]"
                }

                it("should decode successfully") {
                    let json = "[[],[],[],[\"hello\"],[100],false,[true],0,1]"

                    let value = try? self.decoder.decode(EthereumValue.self, from: Data(json.makeBytes()))
                    expect(value).toNot(beNil())

                    expect(value?.array?.count) == 9

                    expect(value?.array?[safe: 0]?.array?.count) == 0
                    expect(value?.array?[safe: 1]?.array?.count) == 0
                    expect(value?.array?[safe: 2]?.array?.count) == 0

                    expect(value?.array?[safe: 3]?.array?.count) == 1
                    expect(value?.array?[safe: 3]?.array?[safe: 0]?.string) == "hello"

                    expect(value?.array?[safe: 4]?.array?.count) == 1
                    expect(value?.array?[safe: 4]?.array?[safe: 0]?.int) == 100

                    expect(value?.array?[safe: 5]?.array).to(beNil())
                    expect(value?.array?[safe: 5]?.bool) == false

                    expect(value?.array?[safe: 6]?.array?.count) == 1
                    expect(value?.array?[safe: 6]?.array?[safe: 0]?.bool) == true

                    expect(value?.array?[safe: 7]?.array).to(beNil())
                    expect(value?.array?[safe: 7]?.int) == 0

                    expect(value?.array?[safe: 8]?.array).to(beNil())
                    expect(value?.array?[safe: 8]?.int) == 1
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
