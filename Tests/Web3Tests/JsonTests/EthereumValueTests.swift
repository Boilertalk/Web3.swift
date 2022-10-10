//
//  EthereumValueTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 13.02.18.
//

import Quick
import Nimble
@testable import Web3
import Foundation

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

                it("should produce correct hashValue") {
                    let value: EthereumValue = 10
                    expect(value.hashValue) == EthereumValue(integerLiteral: 10).hashValue
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

                it("should produce correct hashValue") {
                    let value: EthereumValue = true
                    expect(value.hashValue) == EthereumValue(booleanLiteral: true).hashValue

                    let value2: EthereumValue = false
                    expect(value2.hashValue) == EthereumValue(booleanLiteral: false).hashValue
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

                it("should produce correct hashValue") {
                    let value = EthereumValue(valueType: .nil)
                    expect(value.hashValue) == EthereumValue(valueType: .nil).hashValue
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

                it("should produce correct hashValue") {
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
                    let value2: EthereumValue = .array(
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
                    expect(value.hashValue) == value2.hashValue
                }
            }

            context("ethereum value convertible") {

                it("should initialize itself") {
                    let ethereumValue = try? EthereumValue(ethereumValue: 10)
                    expect(ethereumValue?.int) == 10
                }

                it("should return itself") {
                    let ethereumValue: EthereumValue = EthereumValue.bool(true).ethereumValue()
                    expect(ethereumValue.bool) == true
                }
            }

            context("types ethereum value convertible") {

                it("should initialize and return bool") {
                    let value = true.ethereumValue()
                    let value2 = false.ethereumValue()

                    expect(value.bool) == true
                    expect(value2.bool) == false

                    let returnValue = try? Bool(ethereumValue: value)
                    let returnValue2 = try? Bool(ethereumValue: value2)

                    expect(returnValue).toNot(beNil())
                    expect(returnValue) == true

                    expect(returnValue2).toNot(beNil())
                    expect(returnValue2) == false

                    do {
                        let q = try Bool(ethereumValue: 28)
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try Bool(ethereumValue: [true, false])
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try Bool(ethereumValue: "haha,lol")
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }
                }

                it("should initialize and return string") {
                    let value = "xD".ethereumValue()
                    let value2 = "0x0123456789abcdef".ethereumValue()

                    expect(value.string) == "xD"
                    expect(value2.string) == "0x0123456789abcdef"

                    let returnValue = try? String(ethereumValue: value)
                    let returnValue2 = try? String(ethereumValue: value2)

                    expect(returnValue).toNot(beNil())
                    expect(returnValue) == "xD"

                    expect(returnValue2).toNot(beNil())
                    expect(returnValue2) == "0x0123456789abcdef"

                    do {
                        let q = try String(ethereumValue: 97)
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try String(ethereumValue: [true, false])
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try String(ethereumValue: true)
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try String(ethereumValue: false)
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }
                }

                it("should initialize and return int") {
                    let value = 19.ethereumValue()
                    let value2 = 22.ethereumValue()

                    expect(value.int) == 19
                    expect(value2.int) == 22

                    let returnValue = try? Int(ethereumValue: value)
                    let returnValue2 = try? Int(ethereumValue: value2)

                    expect(returnValue).toNot(beNil())
                    expect(returnValue) == 19

                    expect(returnValue2).toNot(beNil())
                    expect(returnValue2) == 22

                    do {
                        let q = try Int(ethereumValue: "...-/-...")
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try Int(ethereumValue: [true, false])
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try Int(ethereumValue: true)
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }

                    do {
                        let q = try Int(ethereumValue: false)
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumValueInitializableError.notInitializable))
                    }
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
