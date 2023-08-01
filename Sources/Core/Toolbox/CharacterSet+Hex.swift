//
//  CharacterSet+Hex.swift
//  Web3
//
//  Created by Koray Koska on 05.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

extension CharacterSet {

    static var hexadecimalNumbers: CharacterSet {
        return ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    }
    static var hexadecimalLetters: CharacterSet {
        return [
            "a", "b", "c", "d", "e", "f",
            "A", "B", "C", "D", "E", "F"
        ]
    }
    static var hexadecimals: CharacterSet {
        return hexadecimalNumbers.union(hexadecimalLetters)
    }
}
