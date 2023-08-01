//
//  EthereumSyncStatusObjectTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 13.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
@testable import Web3

class EthereumSyncStatusObjectTests: QuickSpec {

    var encoder: JSONEncoder = JSONEncoder()
    var decoder: JSONDecoder = JSONDecoder()

    override func spec() {
        describe("ethereum sync status object tests") {
            context("encoding") {

                it("should encode sucessfully") {
                    let status = EthereumSyncStatusObject()

                    let encoded = try? self.encoder.encode([status])
                }
            }
        }
    }
}
