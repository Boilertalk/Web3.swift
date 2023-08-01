//
//  UInt+BytesRepresentable.swift
//  Web3
//
//  Created by Koray Koska on 01.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation

/*
extension UInt: BytesRepresentable {

    public func makeBytes() -> Bytes {
        var bytes: Bytes = Bytes()

        var tmpInt = self

        for _ in 0 ..< MemoryLayout<UInt>.size {
            bytes.insert(UInt8(tmpInt & 0xff), at: 0)
            tmpInt = tmpInt >> 8
        }

        return bytes
    }
}*/
