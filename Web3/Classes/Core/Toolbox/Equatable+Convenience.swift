//
//  Equatable+Convenience.swift
//  Web3
//
//  Created by Koray Koska on 13.03.18.
//

import Foundation

func equal<T: Equatable>(_ eq: (T, T)) -> Bool {
    return eq.0 == eq.1
}

func equal<T: Equatable>(_ arr: [(T, T)]) -> Bool {
    return arr.reduce(false, { $1.0 == $1.1 })
}

precedencegroup AlternativePrecedence {
    associativity: left
    higherThan: LogicalConjunctionPrecedence
    lowerThan: ComparisonPrecedence
}

precedencegroup ApplicativePrecedence {
    associativity: left
    higherThan: AlternativePrecedence
    lowerThan: NilCoalescingPrecedence
}

infix operator <*> : ApplicativePrecedence

func <*><T, U>(_ fun: (T) -> U, _ val: [T]) -> [U] {
    return val.map(fun)
}
