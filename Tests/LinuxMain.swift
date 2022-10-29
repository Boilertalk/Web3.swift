//
//  LinuxMain.swift
//  Web3
//
//  Created by Koray Koska on 16.02.18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

#if os(Linux)

import XCTest
import Quick
@testable import Web3Tests

@main struct Main {
    static func main() {
        QCKMain([
            // ABITests
            ABIConvertibleTests.self,
            ABITests.self,
            // SolidityTypeTests.self, --> TODO: Switch to QuickSpec
            // SolidityWrappedValueTests.self, --> TODO: Switch to QuickSpec

            // ContractTests
            ContractTests.self,
            DynamicContractTests.self,

            // JsonTests
            EthereumBlockObjectTests.self,
            EthereumCallParamsTests.self,
            EthereumDataTests.self,
            EthereumQuantityTagTests.self,
            EthereumQuantityTests.self,
            EthereumSyncStatusObjectTests.self,
            EthereumValueTests.self,
            RPCRequestJsonTests.self,

            // RLPTests
            RLPDecoderTests.self,
            RLPEncoderTests.self,
            RLPItemTests.self,

            // ToolboxTests
            IntETHTests.self,
            StringBytesTests.self,
            UIntBytesRepresentableTests.self,

            // TransactionTests
            EthereumAddressTests.self,
            EthereumPrivateKeyTests.self,
            EthereumPublicKeyTests.self,
            TransactionTests.self,

            // Web3Tests
            Web3HttpTests.self,
            Web3EventsTests.self
        ], configurations: [], testCases: [
//            SolidityTypeTests.self,
//            SolidityWrappedValueTests.self
        ])
    }
}

#endif
