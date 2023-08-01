//
//  UnsignedInteger+Shifting.swift
//  Web3
//
//  Created by Koray Koska on 06.04.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

extension UnsignedInteger {

    /**
     * Returns true iff mask is included in self
     */
    public func containsMask(_ mask: Self) -> Bool {
        return (self & mask) == mask
    }
}

extension UnsignedInteger {

    /**
     * Shift right
     */
    mutating func shiftRight(_ places: Int) {
        for _ in 0..<places {
            self /= 2
        }
    }

    /**
     * Shift left
     */
    mutating func shiftLeft(_ places: Int) {
        for _ in 0..<places {
            self *= 2
        }
    }
}
