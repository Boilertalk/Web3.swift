//
//  BigUDecimal.swift
//  BigInt.swift
//
//  Created by Koray Koska on 15.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import BigInt

public struct BigUDecimal {

    private var decimal: BigDecimal

    /// The division precision for this decimal
    var precision: UInt {
        get {
            return decimal.precision
        }
        set {
            decimal.precision = newValue
        }
    }

    /// The exponent of this decimal
    var exponent: Int {
        return decimal.exponent
    }

    /// The significand of this decimal
    var significand: BigUInt {
        return decimal.significand
    }

    public init(exponent: Int, significand: BigUInt, precision: UInt = 10) {
        self.decimal = BigDecimal(sign: .plus, exponent: exponent, significand: significand, precision: precision)
    }

    public init(absolute: BigDecimal) {
        self.decimal = absolute.magnitude
    }
}

// MARK: - Arithmetic

extension BigUDecimal {

    public static func * (_ lhs: BigUDecimal, _ rhs: BigUDecimal) -> BigUDecimal {
        return BigUDecimal(absolute: BigDecimal(from: lhs) * BigDecimal(from: rhs))
    }

    public static func *= (_ lhs: inout BigUDecimal, _ rhs: BigUDecimal) {
        lhs = lhs * rhs
    }

    public static func + (_ lhs: BigUDecimal, _ rhs: BigUDecimal) -> BigUDecimal {
        return BigUDecimal(absolute: BigDecimal(from: lhs) + BigDecimal(from: rhs))
    }

    public static func - (_ lhs: BigUDecimal, _ rhs: BigUDecimal) -> BigUDecimal {
        return BigUDecimal(absolute: BigDecimal(from: lhs) - BigDecimal(from: rhs))
    }

    public static func += (_ lhs: inout BigUDecimal, _ rhs: BigUDecimal) {
        lhs = lhs + rhs
    }

    public static func -= (_ lhs: inout BigUDecimal, _ rhs: BigUDecimal) {
        lhs = lhs - rhs
    }

    public static func / (_ lhs: BigUDecimal, _ rhs: BigUDecimal) -> BigUDecimal {
        return BigUDecimal(absolute: BigDecimal(from: lhs) / BigDecimal(from: rhs))
    }

    public static func /= (_ lhs: inout BigUDecimal, _ rhs: BigUDecimal) {
        lhs = lhs / rhs
    }
}
