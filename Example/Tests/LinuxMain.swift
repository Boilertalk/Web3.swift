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
@testable import Web3

QCKMain([
    RLPEncoderTests.self,
    RLPDecoderTests.self
])

#endif
