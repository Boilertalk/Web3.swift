//
//  BigDecimal.swift
//  BigInt.swift
//
//  Created by Koray Koska on 15.06.18.
//

import Foundation
import BigInt

/// Saves a decimal number in the following format
///
/// `s * v * 10^exp`
///
/// where `s` is the sign (- or +), `v` is the significand and `exp` is the exponent.
///
/// The significand can only be a integer number in this implementation.
/// But because it can be an arbitrarily large integer (BigInt), we don't lose any precision.
/// You just have to increase the significand and decrease the exponent in order to represent
/// decimals with more precision.
///
/// Doubles and Swift Decimals will be automatically normalized to this format.
public struct BigDecimal {

    /// The division precision for this decimal
    var precision: UInt

    /// The sign of this decimal
    let sign: FloatingPointSign

    /// The exponent of this decimal
    let exponent: Int

    /// The significand of this decimal
    let significand: BigUInt

    public init(sign: FloatingPointSign, exponent: Int, significand: BigUInt, precision: UInt = 10) {
        self.sign = sign
        self.exponent = exponent
        self.significand = significand
        self.precision = precision
    }

    public init(from: BigUDecimal) {
        self.init(sign: .plus, exponent: from.exponent, significand: from.significand, precision: from.precision)
    }
}

extension BigDecimal: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: Int) {
        self.init(value)
    }

    public init<T: SignedInteger>(_ int: T) {
        let sign = int.signum() == -1 ? FloatingPointSign.minus : FloatingPointSign.plus
        self.init(sign: sign, exponent: 0, significand: BigUInt(abs(int)))
    }

    public init<T: UnsignedInteger>(_ uint: T) {
        self.init(sign: .plus, exponent: 0, significand: BigUInt(uint))
    }
}

extension BigDecimal: ExpressibleByFloatLiteral {

    public init(floatLiteral value: Double) {
        self.init(Decimal(value))
    }

    public init(_ decimal: Decimal) {
        self.init(sign: decimal.sign, exponent: decimal.exponent, significand: BigUInt(abs(NSDecimalNumber(decimal: decimal.significand).intValue)))
    }
}

// MARK: - Arithmetic

public extension BigDecimal {

    public var magnitude: BigDecimal {
        return BigDecimal(sign: .plus, exponent: exponent, significand: significand)
    }

    public var negate: BigDecimal {
        let newSign: FloatingPointSign = sign == .minus ? .plus : .minus
        return BigDecimal(sign: newSign, exponent: exponent, significand: significand)
    }

    public static func * (_ lhs: BigDecimal, _ rhs: BigDecimal) -> BigDecimal {
        var sign = FloatingPointSign.plus
        if lhs.sign != rhs.sign {
            // minus only if exactly one sign is minus
            sign = .minus
        }
        // 10^e1 * 10^e2 = 10^(e1 + e2)
        let exponent = lhs.exponent + rhs.exponent
        let significand = lhs.significand * rhs.significand
        return BigDecimal.init(sign: sign, exponent: exponent, significand: significand)
    }

    public static func *= (_ lhs: inout BigDecimal, _ rhs: BigDecimal) {
        lhs = lhs * rhs
    }

    public static func + (_ lhs: BigDecimal, _ rhs: BigDecimal) -> BigDecimal {
        if rhs.sign == .minus {
            return lhs - BigDecimal(sign: .plus, exponent: rhs.exponent, significand: rhs.significand)
        } else if lhs.sign == .minus {
            return rhs - BigDecimal(sign: .plus, exponent: lhs.exponent, significand: lhs.significand)
        } else {
            let expDiff = abs(lhs.exponent - rhs.exponent)

            let exponent: Int
            let significand: BigUInt
            if lhs.exponent < rhs.exponent {
                exponent = lhs.exponent
                significand = lhs.significand + (rhs.significand * BigUInt(10).power(expDiff))
            } else {
                exponent = rhs.exponent
                significand = rhs.significand + (lhs.significand * BigUInt(10).power(expDiff))
            }

            return BigDecimal(sign: .plus, exponent: exponent, significand: significand)
        }
    }

    public static func - (_ lhs: BigDecimal, _ rhs: BigDecimal) -> BigDecimal {
        if rhs.sign == .minus {
            return lhs + BigDecimal(sign: .plus, exponent: rhs.exponent, significand: rhs.significand)
        } else if lhs.sign == .minus {
            // Right value is positive and left negative so (-v1 - v2) == (-(v1+v2))
            let abs = lhs.magnitude + rhs.magnitude
            return abs.negate
        } else {
            // Both values are positive. (v1 - v2)
            // after normalizing: if v1 >= v2: (v1 - v2)
            //                    else: (v1 - v2) == (- (v2 - v1))

            let expDiff = abs(lhs.exponent - rhs.exponent)

            let normLhs: BigDecimal
            let normRhs: BigDecimal

            if lhs.exponent < rhs.exponent {
                normLhs = lhs
                normRhs = BigDecimal(sign: rhs.sign, exponent: lhs.exponent, significand: rhs.significand * BigUInt(10).power(expDiff))
            } else {
                normRhs = rhs
                normLhs = BigDecimal(sign: lhs.sign, exponent: rhs.exponent, significand: lhs.significand * BigUInt(10).power(expDiff))
            }

            if normLhs.significand >= normRhs.significand {
                return BigDecimal(sign: .plus, exponent: normLhs.exponent, significand: normLhs.significand - normRhs.significand)
            } else {
                return BigDecimal(sign: .minus, exponent: normLhs.exponent, significand: normRhs.significand - normLhs.significand)
            }
        }
    }

    public static func += (_ lhs: inout BigDecimal, _ rhs: BigDecimal) {
        lhs = lhs + rhs
    }

    public static func -= (_ lhs: inout BigDecimal, _ rhs: BigDecimal) {
        lhs = lhs - rhs
    }

    public static func / (_ lhs: BigDecimal, _ rhs: BigDecimal) -> BigDecimal {
        let firstDividend: BigDecimal
        let divisor: BigDecimal

        let sign: FloatingPointSign = lhs.sign == rhs.sign ? .plus : .minus
        let precision = max(lhs.precision, rhs.precision)

        let expDiff = abs(lhs.exponent - rhs.exponent)

        if lhs.exponent < rhs.exponent {
            firstDividend = lhs
            divisor = BigDecimal(sign: rhs.sign, exponent: lhs.exponent, significand: rhs.significand * BigUInt(10).power(expDiff))
        } else {
            divisor = rhs
            firstDividend = BigDecimal(sign: lhs.sign, exponent: rhs.exponent, significand: lhs.significand * BigUInt(10).power(expDiff))
        }

        let (initialQuotient, initialRemainder) = firstDividend.significand.quotientAndRemainder(dividingBy: divisor.significand)
        if initialRemainder == 0 {
            return BigDecimal(sign: sign, exponent: 0, significand: initialQuotient, precision: precision)
        }

        var solution = initialQuotient

        var newExponent = 0
        var remainder = initialRemainder
        for _ in 0..<precision {
            let currentDividend = remainder * 10
            newExponent -= 1

            let (currentQuotient, currentRemainder) = currentDividend.quotientAndRemainder(dividingBy: divisor.significand)
            solution = solution * 10 + currentQuotient
            if currentRemainder == 0 {
                break
            }

            remainder = currentRemainder
        }

        return BigDecimal(sign: sign, exponent: newExponent, significand: solution, precision: precision)
    }

    public static func /= (_ lhs: inout BigDecimal, _ rhs: BigDecimal) {
        lhs = lhs / rhs
    }
}
