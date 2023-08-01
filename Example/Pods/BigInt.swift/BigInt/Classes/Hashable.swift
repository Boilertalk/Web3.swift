//
//  Hashable.swift
//  BigInt
//
//  Created by Károly Lőrentey on 2016-01-03.
//  Copyright © 2016-2017 Károly Lőrentey.
//

import Foundation

extension BigUInt: Hashable {

    //MARK: Hashing

    public var hashValue: Int {
        let words = self.words.map({ Int(bitPattern: $0) })

        // DJB algorithm
        return words.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
}

extension BigInt: Hashable {

    public var hashValue: Int {
        var words = self.words.map({ Int(bitPattern: $0) })

        // Add sign
        switch sign {
        case .plus:
            words.append(0)
        case .minus:
            words.append(1)
        }

        // DJB algorithm
        return words.reduce(5381) {
            ($0 << 5) &+ $0 &+ Int($1)
        }
    }
}
