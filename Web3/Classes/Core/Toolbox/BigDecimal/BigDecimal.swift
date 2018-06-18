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

    /**
     * Initializes this decimal with the given `sign`, `exponent`, `significand` and optional `precision` for divisions.
     *
     * - parameter sign: The sign of this decimal.
     * - parameter exponent: The exponent of this decimal.
     * - parameter significand: The significand of this decimal.
     * - parameter precision: The precision for decimal divisions, defaults to 10.
     */
    public init(sign: FloatingPointSign, exponent: Int, significand: BigUInt, precision: UInt = 10) {
        self.sign = sign
        self.exponent = exponent
        self.significand = significand
        self.precision = precision
    }

    /**
     * Initializes a `BigDecimal` from the given `BigUDecimal`.
     *
     * - parameter from: The unsigned decimal from which to initialize this instance of `BigDecimal`.
     */
    public init(from: BigUDecimal) {
        self.init(sign: .plus, exponent: from.exponent, significand: from.significand, precision: from.precision)
    }
}

extension BigDecimal: ExpressibleByIntegerLiteral {

    public init(integerLiteral value: Int) {
        self.init(value)
    }

    /**
     * Initializes a new decimal with the given SignedInteger.
     *
     * - parameter int: The int from which to initialize this instance of `BigDecimal`.
     */
    public init<T: SignedInteger>(_ int: T) {
        let sign = int.signum() == -1 ? FloatingPointSign.minus : FloatingPointSign.plus
        self.init(sign: sign, exponent: 0, significand: BigUInt(abs(int)))
    }

    /**
     * Initializes a new decimal with the given UnsignedInteger.
     *
     * - parameter uint: The unsigned int from which to initialize this instance of `BigDecimal`.
     */
    public init<T: UnsignedInteger>(_ uint: T) {
        self.init(sign: .plus, exponent: 0, significand: BigUInt(uint))
    }
}

extension BigDecimal: ExpressibleByFloatLiteral {

    public init(floatLiteral value: Double) {
        self.init(Decimal(value))
    }

    /**
     * Initializes a new decimal with the given double.
     *
     * - parameter double: The double from which to initialize this instance of `BigDecimal`.
     */
    public init(_ double: Double) {
        self.init(floatLiteral: double)
    }

    /**
     * Initializes a new decimal with the given Swift decimal.
     *
     * - parameter decimal: The decimal from which to initialize this instance of `BigDecimal`.
     */
    public init(_ decimal: Decimal) {
        self.init(sign: decimal.sign, exponent: decimal.exponent, significand: BigUInt(abs(NSDecimalNumber(decimal: decimal.significand).intValue)))
    }
}

// MARK: - Arithmetic

public extension BigDecimal {

    /// The magnitude of this decimal.
    public var magnitude: BigDecimal {
        return BigDecimal(sign: .plus, exponent: exponent, significand: significand)
    }

    /// The negation of this decimal
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

// MARK: - Equatable

extension BigDecimal: Equatable {

    public static func == (lhs: BigDecimal, rhs: BigDecimal) -> Bool {
        let value = lhs - rhs
        return value.significand == 0
    }
}

// MARK: - Comparable

extension BigDecimal: Comparable {

    public static func < (lhs: BigDecimal, rhs: BigDecimal) -> Bool {
        if lhs.sign != rhs.sign {
            return lhs.sign == .minus ? true : false
        } else if lhs == rhs {
            return false
        } else {
            if lhs.sign == .minus {
                // Both negative -> (abs(lhs) - (abs(rhs))): positive => return true, negative => return false
                let value = lhs.magnitude - rhs.magnitude
                return value.sign == .plus ? true : false
            } else {
                // Both positive, normal subtraction
                let value = lhs - rhs
                return value.sign == .plus ? false : true
            }
        }
    }
}

// MARK: - Hashable

extension BigDecimal: Hashable {

    public var hashValue: Int {
        return hashValues(BigUInt(UInt(bitPattern: exponent)), significand, sign == .plus ? Byte(0x00) : Byte(0x01))
    }
}

// MARK: - CustomStringConvertible

extension BigDecimal: CustomStringConvertible {

    public var description: String {
        var desc = String(significand, radix: 10)

        if exponent >= 0 {
            let zeros = String(repeating: "0", count: exponent)
            desc.append(zeros)
        } else {
            if desc.count <= abs(exponent) {
                // We need leading zeros
                let count = abs(exponent) - desc.count + 1
                let zeros = String(repeating: "0", count: count)
                desc.insert(contentsOf: zeros, at: desc.startIndex)
            }

            let pointIndex = desc.index(desc.endIndex, offsetBy: exponent)
            desc.insert(".", at: pointIndex)
        }

        if sign == .minus {
            desc.insert("-", at: desc.startIndex)
        }

        return desc
    }
}
