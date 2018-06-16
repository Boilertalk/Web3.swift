//
//  BigUDecimal.swift
//  BigInt.swift
//
//  Created by Koray Koska on 15.06.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
import BigInt

/// An unsigned version of `BigDecimal` which only allows positive numbers.
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

    /**
     * Initializes this unsigned decimal with the given `exponent`, `significand` and optional `precision` for divisions.
     *
     * - parameter exponent: The exponent of this decimal.
     * - parameter significand: The significand of this decimal.
     * - parameter precision: The precision for decimal divisions, defaults to 10.
     */
    public init(exponent: Int, significand: BigUInt, precision: UInt = 10) {
        self.decimal = BigDecimal(sign: .plus, exponent: exponent, significand: significand, precision: precision)
    }

    /**
     * Initializes this unsigned decimal with the given instance of `BigDecimal`. Takes the absolute value of it.
     *
     * - parameter absolute: The `BigDecimal` from which to initialize this instance of `BigUDecimal`.
     */
    public init(absolute: BigDecimal) {
        self.decimal = absolute.magnitude
    }
}

extension BigUDecimal: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: UInt) {
        self.init(value)
    }

    /**
     * Initializes a new decimal with the given UnsignedInteger.
     *
     * - parameter uint: The unsigned int from which to initialize this instance of `BigDecimal`.
     */
    public init<T: UnsignedInteger>(_ uint: T) {
        self.init(exponent: 0, significand: BigUInt(uint))
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
