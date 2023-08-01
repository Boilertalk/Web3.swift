//
//  RPCRequestJsonTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 31.12.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3
import Foundation

class RPCRequestJsonTests: QuickSpec {

    var encoder: JSONEncoder = JSONEncoder()
    var decoder: JSONDecoder = JSONDecoder()

    override func spec() {
        describe("rpc requests") {

            beforeEach {
                self.encoder = JSONEncoder()
                self.decoder = JSONDecoder()
            }

            context("primitive values") {

                let rawClientVersion = """
                    {
                        "jsonrpc":"2.0",
                        "method":"web3_clientVersion",
                        "params":[],
                        "id":28
                    }
                """.data(using: .utf8)
                it("should not be nil") {
                    expect(rawClientVersion).toNot(beNil())
                }

                let req: RPCRequest! = try? self.decoder.decode(BasicRPCRequest.self, from: rawClientVersion!)
                it("should decode successfully") {
                    expect(req).toNot(beNil())
                }

                it("should be jsonrpc version 2.0") {
                    expect(req.jsonrpc) == "2.0"
                }

                it("should be method web3_clientVersion") {
                    expect(req.method) == "web3_clientVersion"
                }

                it("should be an array") {
                    expect(req.params.array).toNot(beNil())
                }
                it("should have no params") {
                    expect(req.params.array?.count) == 0
                }

                it("should have the id 28") {
                    expect(req.id) == 28
                }
            }
        }
    }
}
