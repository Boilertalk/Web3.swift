//
//  UInt+ETH.swift
//  Web3
//
//  Created by Koray Koska on 09.02.18.
//

import Foundation
import BigInt

public extension BigUInt {

    public var eth: BigUInt {
        return self * BigUInt(10).power(18)
    }

    public var gwei: BigUInt {
        return self * BigUInt(10).power(9)
    }
}

public extension UInt {

    public var eth: BigUInt {
        return BigUInt(integerLiteral: UInt64(self)).eth
    }

    public var gwei: BigUInt {
        return BigUInt(integerLiteral: UInt64(self)).gwei
    }
}
