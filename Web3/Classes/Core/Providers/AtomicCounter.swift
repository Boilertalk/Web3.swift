//
//  AtomicCounter.swift
//  Web3
//
//  Created by Yehor Popovych on 3/16/19.
//

import Foundation

public class AtomicCounter {
    private var _value: Int32
    private let _lock: NSLock
    
    public init() {
        self._value = 0
        self._lock = NSLock()
    }
    
    public func next() -> Int32 {
        _lock.lock()
        defer { _lock.unlock() }
        _value = _value == Int32.max ? 1 : _value + 1
        return _value
    }
}
