//
//  Bytes+SecureRandom.swift
//  Alamofire
//
//  Created by Koray Koska on 18.02.18.
//  Copyright © 2018 Boilertalk. All rights reserved.
//

import Foundation
#if os(Linux) || os(FreeBSD)
    import Glibc
#else
    import Darwin
#endif

extension Array where Element == UInt8 {

    static func secureRandom(count: Int) -> [UInt8]? {
        var array = [UInt8](repeating: 0, count: count)

        let fd = open("/dev/urandom", O_RDONLY)
        guard fd != -1 else {
            return nil
        }
        defer {
            close(fd)
        }

        let ret = read(fd, &array, MemoryLayout<UInt8>.size * array.count)
        guard ret > 0 else {
            return nil
        }

        return array
    }
}
