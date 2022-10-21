//
//  ABITests.swift
//  Web3_Tests
//
//  Created by Josh Pyles on 6/13/18.
//

import Quick
import Nimble
@testable import Web3
import BigInt
import Foundation
#if canImport(Web3ContractABI)
    @testable import Web3ContractABI
#endif

class ABITests: QuickSpec {
    
    override func spec() {
        
        describe("Solidity Examples") {
            
            context("when executed with Web3.swift ABI module") {
                
                it("should match example 1") {
                    let uint = UInt32(69)
                    let bool = true
                    let signature = "0xcdcd77c0"
                    do {
                        let encoded = try ABI.encodeParameters([.uint(uint), .bool(bool)])
                        let result = signature + encoded.replacingOccurrences(of: "0x", with: "")
                        let expected = "0xcdcd77c000000000000000000000000000000000000000000000000000000000000000450000000000000000000000000000000000000000000000000000000000000001"
                        expect(result).to(equal(expected))
                    } catch {
                        fail()
                    }
                }
                
                it("should match example 2") {
                    let bytes = [
                        Data("abc".utf8),
                        Data("def".utf8)
                    ]
                    let signature = "0xfce353f6"
                    do {
                        let encoded = try ABI.encodeParameters([.fixedArray(bytes, elementType: .bytes(length: 3), length: 2)])
                        let result = signature + encoded.replacingOccurrences(of: "0x", with: "")
                        let expected = "0xfce353f661626300000000000000000000000000000000000000000000000000000000006465660000000000000000000000000000000000000000000000000000000000"
                        expect(result).to(equal(expected))
                    } catch {
                        fail()
                    }
                }
                
                it("should match example 3") {
                    let data = Data("dave".utf8)
                    let bool = true
                    let array = [BigInt(1), BigInt(2), BigInt(3)]
                    let signature = "0xa5643bf2"
                    do {
                        let encoded = try ABI.encodeParameters(types: [.bytes(length: nil), .bool, .array(type: .uint, length: nil)], values: [data, bool, array])
                        let result = signature + encoded.replacingOccurrences(of: "0x", with: "")
                        let expected = "0xa5643bf20000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000464617665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003"
                        expect(result).to(equal(expected))
                    } catch {
                        fail()
                    }
                }
                
            }
            
        }
        
        describe("ABI encoder") {
            
            context("when encoding single values") {
                let expected = "0x0000000000000000000000000000000000000000000000000000000000000001"
                let number = BigUInt(1)
                
                it("should encode wrapped values") {
                    do {
                        let encodedWrapped = try ABI.encodeParameter(.uint(number))
                        expect(encodedWrapped).to(equal(expected))
                    } catch {
                        fail()
                    }
                }
                
                it("should encode type and value pairs") {
                    do {
                        let encoded = try ABI.encodeParameter(type: .uint, value: number)
                        expect(encoded).to(equal(expected))
                    } catch {
                        fail()
                    }
                }
                
            }
            
            describe("encoding arrays") {
                
                context("when encoding as dynamic array") {
                    it("should encode array of non dynamic objects") {
                        do {
                            let array = [
                                try EthereumAddress(hex: "0xD11Aa575f9C6f30bEDF392872726b2B157C83131", eip55: false),
                                try EthereumAddress(hex: "0x9F2c4Ea0506EeAb4e4Dc634C1e1F4Be71D0d7531", eip55: false)
                            ]
                            let test = try ABI.encodeParameters([.array(array)])
                            let expected = "0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000002000000000000000000000000d11aa575f9c6f30bedf392872726b2b157c831310000000000000000000000009f2c4ea0506eeab4e4dc634c1e1f4be71d0d7531"
                            expect(test).to(equal(expected))
                        } catch {
                            fail(error.localizedDescription)
                        }
                    }
                    
                    it("should encode array of dynamic objects") {
                        do {
                            let array = ["abc", "def", "ghi", "jkl", "mno"]
                            let test = try ABI.encodeParameters([.array(array)])
                            let expected = "0x0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000036162630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000364656600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003676869000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000036a6b6c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000036d6e6f0000000000000000000000000000000000000000000000000000000000"
                            
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                    
                    it("should encode array of bool") {
                        do {
                            let array = [true, false, true, false]
                            let test = try ABI.encodeParameters([.array(array)])
                            let expected = "0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000"
                            
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                    
                    it("should encode fixed values") {
                        do {
                            let array = [BigInt(1), BigInt(-1), BigInt(2), BigInt(-2)]
                            let test = try ABI.encodeParameters([.array(array)])
                            let expected = "0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000001ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000002fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe"
                            
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                    
                    it("should encode nested array") {
                        do {
                            let array: [[UInt32]] = [[1,2,3], [4,5,6]]
                            let test = try ABI.encodeParameters([.array(array)])
                            let expected = "0x0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000006"
                            
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                }
                
                context("when encoding as fixed array") {
                    
                    it("should encode dynamic values") {
                        do {
                            let array = ["abc", "def", "ghi", "jkl", "mno"]
                            let test = try ABI.encodeParameters([.fixedArray(array)])
                            let expected = "0x0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000036162630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000364656600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003676869000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000036a6b6c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000036d6e6f0000000000000000000000000000000000000000000000000000000000"
                            
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                    
                    it("should encode nested dynamic array") {
                        do {
                            let array: [[UInt32]] = [[1,2,3], [4,5,6]]
                            let test = try ABI.encodeParameters([.fixedArray(array, elementType: .array(type: .uint32, length: nil), length: 2)])
                            let expected = "0x0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000006"
                            
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                    
                    it("should encode nested fixed array") {
                        do {
                            let array: [[UInt32]] = [[1,2,3], [4,5,6]]
                            let test = try ABI.encodeParameters([.fixedArray(array, elementType: .array(type: .uint64, length: 3), length: 2)])
                            let expected = "0x000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000006"
                            
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                }
                
                
            }
            
            it("should encode a tuple") {
                let expected = """
                    0x\
                    0000000000000000000000000000000000000000000000000000000000000020\
                    0000000000000000000000000000000000000000000000000000000000000040\
                    0000000000000000000000000000000000000000000000000000000000000008\
                    000000000000000000000000000000000000000000000000000000000000000b\
                    68656c6c6f20776f726c64000000000000000000000000000000000000000000
                    """
                do {
                    let encoded = try ABI.encodeParameters([.tuple(.string("hello world"), .uint(BigUInt(8)))])
                    expect(encoded).to(equal(expected))
                } catch {
                    fail()
                }
            }
            
        }
        
        describe("ABI decoder") {
            
            it("should decode a single value") {
                let encoded = "0x0000000000000000000000000000000000000000000000000000000000000001"
                do {
                    let decoded = try ABI.decodeParameter(type: .uint, from: encoded)
                    expect(decoded as? BigUInt).to(equal(1))
                } catch {
                    fail()
                }
            }
            
            describe("arrays") {
                context("when decoding dynamic arrays") {
                    
                    it("should decode array of dynamic elements") {
                        do {
                            let string = "0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000500000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000000000000016000000000000000000000000000000000000000000000000000000000000001a000000000000000000000000000000000000000000000000000000000000000036162630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000364656600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003676869000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000036a6b6c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000036d6e6f0000000000000000000000000000000000000000000000000000000000"
                            let test: [String]? = try ABI.decodeParameters(types: [.array(type: .string, length: nil)], from: string).first as? [String]
                            let expected: [String] = ["abc", "def", "ghi", "jkl", "mno"]
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                    
                    it("should decode array of static elements") {
                        do {
                            let string = "000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000001ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000002fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe"
                            let test: [BigInt]? = try ABI.decodeParameters(types: [.array(type: .int256, length: nil)], from: string).first as? [BigInt]
                            let expected: [BigInt] = [BigInt(1), BigInt(-1), BigInt(2), BigInt(-2)]
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                    
                    it("should decode nested array") {
                        do {
                            let string = "00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000006"
                            let test: [[UInt32]]? = try ABI.decodeParameters(types: [.array(type: .array(type: .uint32, length: nil), length: nil)], from: string).first as? [[UInt32]]
                            let expected: [[UInt32]] = [[1,2,3], [4,5,6]]
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                    
                    it("should decode empty dynamic arrays") {
                        do {
                            let string = "00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000000"
                            let test = try ABI.decodeParameters(types: [.array(type: .string, length: nil)], from: string).first as? [String]
                            let expected = [String]()
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                    
                }
                
                context("when decoding fixed arrays") {
                    
                    it("should decode fixed array of dynamic type") {
                        do {
                            let string = "000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000000000000000000000000000000000000000120000000000000000000000000000000000000000000000000000000000000016000000000000000000000000000000000000000000000000000000000000001a000000000000000000000000000000000000000000000000000000000000000036162630000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000364656600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003676869000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000036a6b6c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000036d6e6f0000000000000000000000000000000000000000000000000000000000"
                            let test = try ABI.decodeParameters(types: [.array(type: .string, length: 5)], from: string).first as? [String]
                            let expected = ["abc", "def", "ghi", "jkl", "mno"]
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                    
                    it("should decode nested dynamic array") {
                        do {
                            let string = "0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000030000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000006"
                            let test: [[UInt32]]? = try ABI.decodeParameters(types: [.array(type: .array(type: .uint32, length: nil), length: 2)], from: string).first as? [[UInt32]]
                            let expected: [[UInt32]] = [[1,2,3], [4,5,6]]
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                    
                    it("should decode nested fixed array") {
                        do {
                            let string = "000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000050000000000000000000000000000000000000000000000000000000000000006"
                            let test = try ABI.decodeParameters(types: [.array(type: .array(type: .uint32, length: 3), length: 2)], from: string).first as? [[UInt32]]
                            let expected: [[UInt32]] = [[1,2,3], [4,5,6]]
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                    
                    it("should decode empty arrays") {
                        do {
                            let string = ""
                            let test = try ABI.decodeParameters(types: [.array(type: .uint, length: 0)], from: string).first as? [String]
                            let expected = [String]()
                            expect(test).to(equal(expected))
                        } catch {
                            fail()
                        }
                    }
                }
            }
            
            it("should decode various values") {
                do {
                    let string = "00000000000000000000000000000000000000000000000000000000000000450000000000000000000000000000000000000000000000000000000000000001"
                    let decoded = try ABI.decodeParameters(types: [.uint32, .bool], from: string)
                    expect(decoded.first as? UInt32).to(equal(69))
                    expect(decoded[1] as? Bool).to(equal(true))
                } catch {
                    fail()
                }
            }
            
            it("should decode more various values") {
                let example3 = "0000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a0000000000000000000000000000000000000000000000000000000000000000464617665000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003"
                do {
                    let decodedValues = try ABI.decodeParameters(types: [.string, .bool, .array(type: .uint256, length: nil)], from: example3)
                    expect(decodedValues.count).to(equal(3))
                    expect(decodedValues[0] as? String).to(equal("dave"))
                    expect(decodedValues[1] as? Bool).to(equal(true))
                    expect(decodedValues[2] as? [BigUInt]).to(equal([1, 2, 3]))
                } catch {
                    fail()
                }
            }
            
            describe("bytes") {
                let bytes = Data("Hi!".utf8)
                context("when encoding with fixed bytes") {
                    it("should encode and decode") {
                        do {
                            let encodedFixed = try ABI.encodeParameters([.fixedBytes(bytes)])
                            let decodedFixed = try ABI.decodeParameters(types: [.bytes(length: UInt(bytes.count))], from: encodedFixed)
                            expect(decodedFixed[0] as? Data).to(equal(bytes))
                        } catch {
                            fail()
                        }
                    }
                }
                
                context("when encoding with dynamic bytes") {
                    it("should encode and decode") {
                        do {
                            let encoded = try ABI.encodeParameters([.bytes(bytes)])
                            let decoded = try ABI.decodeParameters(types: [.bytes(length: nil)], from: encoded)
                            expect(decoded[0] as? Data).to(equal(bytes))
                        } catch {
                            fail()
                        }
                    }
                }
            }
            
            it("should decode a tuple") {
                let encoded = """
                    0000000000000000000000000000000000000000000000000000000000000020\
                    0000000000000000000000000000000000000000000000000000000000000040\
                    0000000000000000000000000000000000000000000000000000000000000008\
                    000000000000000000000000000000000000000000000000000000000000000b\
                    68656c6c6f20776f726c64000000000000000000000000000000000000000000
                    """
                do {
                    let decoded = try ABI.decodeParameters(types: [.tuple([.string, .int])], from: encoded)
                    let tupleValue = decoded.first as? [Any]
                    expect(tupleValue?.count).to(equal(2))
                    expect(tupleValue?.first as? String).to(equal("hello world"))
                    expect(tupleValue?[1] as? BigInt).to(equal(8))
                } catch {
                    fail()
                }
            }
            
            it("should throw an error when parsing wrong type") {
                let response = "0x454f530000000000000000000000000000000000000000000000000000000000"
                do {
                    let _ = try ABI.decodeParameters(types: [.string], from: response)
                    fail("Decoder should throw an error")
                } catch {
                    expect(error).toNot(beNil())
                }
            }
        }
        
    }
}
