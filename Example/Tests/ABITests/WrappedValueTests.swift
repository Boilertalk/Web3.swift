//
//  WrappedValueTests.swift
//  Web3_Tests
//
//  Created by Josh Pyles on 6/7/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import BigInt
import Web3
#if canImport(Web3ContractABI)
    @testable import Web3ContractABI
#endif

class SolidityWrappedValueTests: XCTestCase {
    
    func testUInt() {
        let uint8 = UInt8(0)
        let uint16 = UInt16(0)
        let uint32 = UInt32(0)
        let uint64 = UInt64(0)
        let uint256 = BigUInt(0)
        
        XCTAssertEqual(SolidityWrappedValue.uint(uint8).type, .uint8)
        XCTAssertEqual(SolidityWrappedValue.uint(uint16).type, .uint16)
        XCTAssertEqual(SolidityWrappedValue.uint(uint32).type, .uint32)
        XCTAssertEqual(SolidityWrappedValue.uint(uint64).type, .uint64)
        XCTAssertEqual(SolidityWrappedValue.uint(uint256).type, .uint256)
    }
    
    func testInt() {
        let int8 = Int8(0)
        let int16 = Int16(0)
        let int32 = Int32(0)
        let int64 = Int64(0)
        let int256 = BigInt(0)
        
        XCTAssertEqual(SolidityWrappedValue.int(int8).type, .int8)
        XCTAssertEqual(SolidityWrappedValue.int(int16).type, .int16)
        XCTAssertEqual(SolidityWrappedValue.int(int32).type, .int32)
        XCTAssertEqual(SolidityWrappedValue.int(int64).type, .int64)
        XCTAssertEqual(SolidityWrappedValue.int(int256).type, .int256)
    }
    
    func testString() {
        let string = SolidityWrappedValue.string("hi!")
        XCTAssertEqual(string.type, .string)
    }
    
    func testBytes() {
        let bytes = Data("hi!".utf8)
        XCTAssertEqual(SolidityWrappedValue.bytes(bytes).type, .bytes(length: nil))
        XCTAssertEqual(SolidityWrappedValue.fixedBytes(bytes).type, .bytes(length: UInt(bytes.count)))
    }
    
    func testArray() {
        let array = ["one", "two", "three"]
        XCTAssertEqual(SolidityWrappedValue.array(array).type, .array(type: .string, length: nil))
        XCTAssertEqual(SolidityWrappedValue.fixedArray(array).type, .array(type: .string, length: 3))
    }
    
    func testNestedArray() {
        let array = [["one", "two"], ["three"]]
        let deepNestedArray = [[["one"], ["two"]], [["three"]]]
        XCTAssertEqual(SolidityWrappedValue.array(array).type, .array(type: .array(type: .string, length: nil), length: nil))
        XCTAssertEqual(SolidityWrappedValue.array(deepNestedArray).type, .array(type: .array(type: .array(type: .string, length: nil), length: nil), length: nil))
    }
    
    func testAddress() {
        let address = EthereumAddress.testAddress
        XCTAssertEqual(SolidityWrappedValue.address(address).type, .address)
    }
    
    func testBool() {
        let bool = false
        XCTAssertEqual(SolidityWrappedValue.bool(bool).type, .bool)
    }
    
}
