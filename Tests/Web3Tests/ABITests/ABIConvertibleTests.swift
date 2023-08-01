//
//  ABIConvertibleTests.swift
//  Web3_Tests
//
//  Created by Josh Pyles on 5/29/18.
//

import Quick
import Nimble
@testable import Web3
import BigInt
import Foundation
#if canImport(Web3ContractABI)
    @testable import Web3ContractABI
#endif

class ABIConvertibleTests: QuickSpec {
    
    override func spec() {
        
        describe("Solidity Representable") {
            
            it("should work with String") {
                expect(String.solidityType).to(equal(SolidityType.type(.string)))
            }
            
            it("should work with Bool") {
                expect(Bool.solidityType).to(equal(SolidityType.type(.bool)))
            }
            
            it("should work with Unsigned Integers") {
                expect(UInt16.solidityType).to(equal(SolidityType.type(.uint16)))
                expect(BigUInt.solidityType).to(equal(SolidityType.type(.uint256)))
            }
            
            it("should work with Signed Integers") {
                expect(BigInt.solidityType).to(equal(SolidityType.type(.int256)))
                expect(Int8.solidityType).to(equal(SolidityType.type(.int8)))
            }
            
            it("should work with EthereumAddress") {
                expect(EthereumAddress.solidityType).to(equal(SolidityType.type(.address)))
            }
            
        }
        
        describe("Unsigned Integers") {
            
            it("should be encoded properly from hex") {
                let test1 = UInt8(255)
                let test2 = UInt16(255)
                let test3 = UInt32(255)
                let test4 = UInt64(255)
                let test5 = BigUInt(255)
                
                let encoded1 = test1.abiEncode(dynamic: false)
                let encoded2 = test2.abiEncode(dynamic: false)
                let encoded3 = test3.abiEncode(dynamic: false)
                let encoded4 = test4.abiEncode(dynamic: false)
                let encoded5 = test5.abiEncode(dynamic: false)
                
                let expected = "00000000000000000000000000000000000000000000000000000000000000ff"
                
                expect(encoded1).to(equal(expected))
                expect(encoded2).to(equal(expected))
                expect(encoded3).to(equal(expected))
                expect(encoded4).to(equal(expected))
                expect(encoded5).to(equal(expected))
            }
            
            it("should be decoded properly to hex") {
                let hexString = "00000000000000000000000000000000000000000000000000000000000000ff"
                expect(UInt8(hexString: hexString)).to(equal(255))
                expect(UInt16(hexString: hexString)).to(equal(255))
                expect(BigUInt(hexString: hexString)).to(equal(255))
            }
            
        }
        
        describe("Integers") {
            
            context("when working with twos complement") {
                //-01111111 => 10000000
                let int = Int8(-128)
                let positive = Int8(120)
                it("should have correct twos complement representation") {
                    expect(int.twosComplementRepresentation).to(equal(0))
                    expect(positive.twosComplementRepresentation).to(equal(positive))
                }
                
                it("should be able to be converted from twos string") {
                    expect(Int8(twosComplementString: "10000000")).to(equal(int))
                    expect(Int8(twosComplementString: "01111111")).to(equal(127))
                }
                
                it("should fail to decode invalid strings") {
                    expect(Int8(twosComplementString: "FF")).to(beNil())
                    expect(BigInt(twosComplementString: "XYZZ")).to(beNil())
                }
            }
            
            context("when encoding to hex") {
                it("should encode negative various integer types") {
                    let test1 = Int32(-1200).abiEncode(dynamic: false)
                    let expected1 = "fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb50"
                    expect(test1).to(equal(expected1))
                    
                    let test2 = Int64(-600).abiEncode(dynamic: false)
                    let expected2 = "fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffda8"
                    expect(test2).to(equal(expected2))
                }
                
                it("should encode positive various integer types") {
                    let test = Int(32).abiEncode(dynamic: false)
                    let expected = "0000000000000000000000000000000000000000000000000000000000000020"
                    expect(test).to(equal(expected))
                }
                
                it("should encode negative BigInt") {
                    let test = BigInt(-1).abiEncode(dynamic: false)
                    let expected = "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
                    expect(test).to(equal(expected))
                }
                
                it("should encode positive BigInt") {
                    let test = BigInt(240000000).abiEncode(dynamic: false)
                    let expected = "000000000000000000000000000000000000000000000000000000000e4e1c00"
                    expect(test).to(equal(expected))
                }
            }
            
            context("when decoding from hex string") {
                it("should decode Int") {
                    let string = "0000000000000000000000000000000000000000000000000000000000000020"
                    expect(Int(hexString: string)).to(equal(32))
                }
                
                it("should decode negative values") {
                    let string = "fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb50"
                    let string2 = "fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffda8"
                    expect(Int32(hexString: string)).to(equal(-1200))
                    expect(Int64(hexString: string2)).to(equal(-600))
                }
                
                it("should decode BigInt values") {
                    let string = "000000000000000000000000000000000000000000000000000000000e4e1c00"
                    expect(BigInt(hexString: string)).to(equal(BigInt(240000000)))
                }
                
                it("should decode negative BigInt values") {
                    let string = "ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
                    expect(BigInt(hexString: string)).to(equal(BigInt(-1)))
                }
            }
            
        }
        
        describe("Bool values") {
            
            context("when encoding to hex") {
                
                it("should encode true") {
                    let test = true.abiEncode(dynamic: false)
                    let expected = "0000000000000000000000000000000000000000000000000000000000000001"
                    expect(test).to(equal(expected))
                }
                
                it("should encode false") {
                    let test = false.abiEncode(dynamic: false)
                    let expected = "0000000000000000000000000000000000000000000000000000000000000000"
                    expect(test).to(equal(expected))
                }
                
            }
            
            context("when decoding from hex string") {
                
                it("should decode true") {
                    let test = Bool(hexString: "0000000000000000000000000000000000000000000000000000000000000001")
                    expect(test).to(equal(true))
                }
                
                it("should decode false") {
                    let test = Bool(hexString: "0000000000000000000000000000000000000000000000000000000000000000")
                    expect(test).to(equal(false))
                }
                
                it("should not decode non hex strings") {
                    let test = Bool(hexString: "HI")
                    expect(test).to(beNil())
                }
            }
            
        }
        
        describe("String values") {
            
            context("when encoding to hex") {
                
                it("encodes 'Hello World!'") {
                    let test = "Hello World!".abiEncode(dynamic: true)
                    let expected = "000000000000000000000000000000000000000000000000000000000000000c48656c6c6f20576f726c64210000000000000000000000000000000000000000"
                    expect(test).to(equal(expected))
                }
                
                it("encodes 'Whats happening?'") {
                    let test = "What‘s happening?".abiEncode(dynamic: true)
                    let expected = "000000000000000000000000000000000000000000000000000000000000001357686174e28098732068617070656e696e673f00000000000000000000000000"
                    expect(test).to(equal(expected))
                }
                
            }
            
            context("when decoding from hex string") {
                
                it("decodes 'Hello World!'") {
                    let string = "000000000000000000000000000000000000000000000000000000000000000c48656c6c6f20576f726c64210000000000000000000000000000000000000000"
                    expect(String(hexString: string)).to(equal("Hello World!"))
                }
                
                it("decodes 'Whats happening?'") {
                    let string = "000000000000000000000000000000000000000000000000000000000000001357686174e28098732068617070656e696e673f00000000000000000000000000"
                    expect(String(hexString: string)).to(equal("What‘s happening?"))
                }
                
                it("does not decode invalid data") {
                    expect(String(hexString: "00000")).to(beNil())
                }
                
            }
            
        }
        
        describe("Address values") {
            
            it("should be able to be encoded to hex") {
                let test = try! EthereumAddress(hex: "0x9F2c4Ea0506EeAb4e4Dc634C1e1F4Be71D0d7531", eip55: false).abiEncode(dynamic: false)
                let expected = "0000000000000000000000009f2c4ea0506eeab4e4dc634c1e1f4be71d0d7531"
                expect(test).to(equal(expected))
            }
            
            it("should be able to be decoded from hex") {
                let test = EthereumAddress(hexString: "0000000000000000000000009f2c4ea0506eeab4e4dc634c1e1f4be71d0d7531")
                let expected = try! EthereumAddress(hex: "0x9F2c4Ea0506EeAb4e4Dc634C1e1F4Be71D0d7531", eip55: false)
                expect(test).to(equal(expected))
                
            }
            
            it("should not decode invalid data") {
                let test = EthereumAddress(hexString: "0000000000000000000000009f2c4ea0506eeab4e4dc634c1e1f4be71d0d75XX")
                expect(test).to(beNil())
            }
            
        }
        
        describe("Data values") {
            
            context("when encoding to hex string") {
                it("should encode Data to dynamic bytes") {
                    let bytes = Data([1, 2, 3, 4, 5, 6, 7, 8, 9])
                    let test = try? ABI.encodeParameters([.bytes(bytes)])
                    let expected = "0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000090102030405060708090000000000000000000000000000000000000000000000"
                    expect(test).to(equal(expected))
                }
                
                it("should encode Data to fixed bytes") {
                    let bytes = Data([0, 111, 222])
                    let test = try? ABI.encodeParameters([.fixedBytes(bytes)])
                    let expected = "0x006fde0000000000000000000000000000000000000000000000000000000000"
                    expect(test).to(equal(expected))
                }
            }
            
            context("when decoding from hex string") {
                it("should decode Data from dynamic bytes") {
                    let expected = Data([1, 2, 3, 4, 5, 6, 7, 8, 9])
                    let test = "00000000000000000000000000000000000000000000000000000000000000090102030405060708090000000000000000000000000000000000000000000000"
                    expect(Data(hexString: test)).to(equal(expected))
                }
                
                it("should decode Data from fixed bytes") {
                    let expected = Data([0, 111, 222])
                    let test = "006fde0000000000000000000000000000000000000000000000000000000000"
                    expect(Data(hexString: test, length: 3)).to(equal(expected))
                }
                
            }
            
        }
        
        describe("Array values") {
            
            context("when encoding to hex") {
                let array: [Int64] = [0, 1, 2, 3]
                
                it("should encode as fixed array") {
                    let test = array.abiEncode(dynamic: false)
                    let expected = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003"
                    expect(test).to(equal(expected))
                }
                
                it("should encode as dynamic array") {
                    let test = array.abiEncode(dynamic: true)
                    let expected = "00000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003"
                    expect(test).to(equal(expected))
                }
            }
            
            context("when decoding to hex") {
                let expected: [Int64] = [0, 1, 2, 3]
                
                it("should decode a fixed array") {
                    let string = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003"
                    let test = [Int64].init(hexString: string, length: 4)
                    expect(test).to(equal(expected))
                }
                
                it("should not decode a fixed array without a length") {
                    let string = "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003"
                    let test: [Int64]? = [Int64].init(hexString: string)
                    expect(test).to(beNil())
                }
                
                it("should decode a dynamic array") {
                    let string = "00000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000003"
                    let test: [Int64]? = [Int64].init(hexString: string)
                    expect(test).to(equal(expected))
                }
                
                it("should not decode a fixed array with wrong amount of bytes") {
                    let test: [Int64]? = [Int64].init(hexString: "00000000000000", length: 100)
                    expect(test).to(beNil())
                }
                
            }
            
        }
    }
}
