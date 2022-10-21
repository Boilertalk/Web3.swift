//
//  SolidityTypeTests.swift
//  Web3_Tests
//
//  Created by Josh Pyles on 6/2/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import XCTest
import Web3
import BigInt
#if canImport(Web3ContractABI)
    @testable import Web3ContractABI
#endif

class SolidityTypeTests: XCTestCase {
    
    func testDecodingStringType() {
        XCTAssertEqual(try? SolidityType("string"), .string, "String type should be parsed")
        XCTAssertEqual(SolidityType.string.stringValue, "string", "Should return the correct string representation")
    }
    
    func testDecodingBoolType() {
        XCTAssertEqual(try? SolidityType("bool"), .bool, "Bool type should be parsed")
        XCTAssertEqual(SolidityType.bool.stringValue, "bool", "Should return the correct string representation")
    }
    
    func testDecodingAddressType() {
        XCTAssertEqual(try? SolidityType("address"), .address, "Address type should be parsed")
        XCTAssertEqual(SolidityType.address.stringValue, "address", "Should return the correct string representation")
    }
    
    func testDecodingBytesType() {
        XCTAssertEqual(try? SolidityType("bytes"), .bytes(length: nil), "Bytes type should be parsed")
        XCTAssertEqual(SolidityType.bytes(length: nil).stringValue, "bytes", "Should return the correct string representation")
        XCTAssertEqual(try? SolidityType("bytes5"), .bytes(length: 5), "Bytes5 type should be parsed")
        XCTAssertEqual(SolidityType.bytes(length: 5).stringValue, "bytes5", "Should return the correct string representation")
    }
    
    func testDecodingNumberTypes() {
        // uint
        XCTAssertEqual(try? SolidityType("uint"), .uint, "Uint type should be parsed")
        XCTAssertEqual(SolidityType.uint.stringValue, "uint256", "Should return the correct string representation")
        XCTAssertEqual(try? SolidityType("uint8"), .uint8, "Uint8 type should be parsed")
        XCTAssertEqual(SolidityType.uint8.stringValue, "uint8", "Should return the correct string representation")
        XCTAssertEqual(try? SolidityType("uint16"), .uint16, "Uint16 type should be parsed")
        XCTAssertEqual(SolidityType.uint16.stringValue, "uint16", "Should return the correct string representation")
        // int
        XCTAssertEqual(try? SolidityType("int"), .int, "Int type should be parsed")
        XCTAssertEqual(SolidityType.int.stringValue, "int256", "Should return the correct string representation")
        XCTAssertEqual(try? SolidityType("int8"), .int8, "Int8 type should be parsed")
        XCTAssertEqual(SolidityType.int8.stringValue, "int8", "Should return the correct string representation")
        XCTAssertEqual(try? SolidityType("int16"), .int16, "Int16 type should be parsed")
        XCTAssertEqual(SolidityType.int16.stringValue, "int16", "Should return the correct string representation")
    }
    
    func testDecodingArrayType() {
        XCTAssertEqual(try? SolidityType("string[]"), .array(type: .string, length: nil), "dynamic array type should be parsed")
        XCTAssertEqual(try? SolidityType("int32[]"), .array(type: .int32, length: nil), "dynamic array type should be parsed")
        XCTAssertEqual(try? SolidityType("string[4]"), .array(type: .string, length: 4), "fixed array type should be parsed")
        XCTAssertEqual(try? SolidityType("bytes3[10]"), .array(type: .bytes(length: 3), length: 10), "fixed array type should be parsed")
        XCTAssertEqual(try? SolidityType("string[][]"), .array(type: .array(type: .string, length: nil), length: nil), "dynamic nested array should be parsed")
        XCTAssertEqual(try? SolidityType("string[3][]"), .array(type: .array(type: .string, length: 3), length: nil), "dynamic array of fixed array should be parsed")
        XCTAssertEqual(try? SolidityType("string[][7]"), .array(type: .array(type: .string, length: nil), length: 7), "fixed array of dynamic array should be parsed")
        XCTAssertEqual(try? SolidityType("string[1][2]"), .array(type: .array(type: .string, length: 1), length: 2), "fixed nested array should be parsed")
        XCTAssertEqual(try? SolidityType("string[][][2]"), .array(type: .array(type: .array(type: .string, length: nil), length: nil), length: 2), "dynamic nested array should be parsed")
    }

    func testMultidimensionalTupleType() {
        let singleTupleType = SolidityType(
            "tuple[]",
            subTypes: [.int16, .int16, .int24, .int24, .uint24, .uint160, .uint128]
        )
        XCTAssertEqual(singleTupleType, .array(type: .tuple([.int16, .int16, .int24, .int24, .uint24, .uint160, .uint128]), length: nil))

        let deepTuple = SolidityType(
            "tuple[]",
            subTypes: [.int16, .int16, .int24, .tuple([.tuple([.uint24]), .tuple([.int16]), .string]), .uint24, .uint160, .uint128, .tuple([.bytes(length: nil)])]
        )
        XCTAssertEqual(deepTuple, .array(type: .tuple([.int16, .int16, .int24, .tuple([.tuple([.uint24]), .tuple([.int16]), .string]), .uint24, .uint160, .uint128, .tuple([.bytes(length: nil)])]), length: nil))

        let twoDTuple = SolidityType(
            "tuple[][]",
            subTypes: [.int16, .int16, .int24, .tuple([.tuple([.uint24]), .tuple([.int16]), .string]), .uint24, .uint160, .uint128, .tuple([.bytes(length: nil)])]
        )
        XCTAssertEqual(twoDTuple, .array(type:
                .array(type:
                        .tuple([
                            .int16,
                            .int16,
                            .int24,
                            .tuple([.tuple([.uint24]), .tuple([.int16]), .string]),
                            .uint24,
                            .uint160,
                            .uint128,
                            .tuple([.bytes(length: nil)])
                        ]),
                       length: nil), length: nil))

        let threeDFixedTupleArray = SolidityType(
            "tuple[3][2][10]",
            subTypes: [.int16, .int16, .int24, .tuple([.tuple([.uint24]), .tuple([.int16]), .string]), .uint24, .uint160, .uint128, .tuple([.bytes(length: nil)])]
        )
        XCTAssertEqual(threeDFixedTupleArray, .array(type: .array(type:
                .array(type:
                        .tuple([
                            .int16,
                            .int16,
                            .int24,
                            .tuple([.tuple([.uint24]), .tuple([.int16]), .string]),
                            .uint24,
                            .uint160,
                            .uint128,
                            .tuple([.bytes(length: nil)])
                        ]),
                       length: 3), length: 2), length: 10))
    }
}
