//
//  UInt+ETH.swift
//  Web3
//
//  Created by Koray Koska on 09.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
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

public extension UnsignedInteger {

    public var eth: BigUInt {
        return BigUInt(self).eth
    }

    public var gwei: BigUInt {
        return BigUInt(self).gwei
    }
}

public extension SignedInteger {

    public var eth: BigUInt {
        guard self >= 0 else {
            return 0
        }
        return BigUInt(self).eth
    }

    public var gwei: BigUInt {
        guard self >= 0 else {
            return 0
        }
        return BigUInt(self).gwei
    }
}
