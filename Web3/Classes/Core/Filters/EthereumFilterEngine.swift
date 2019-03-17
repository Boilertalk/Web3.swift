//
//  EthereumFilterEngine.swift
//  Web3
//
//  Created by Yehor Popovych on 3/16/19.
//

import Foundation

public class EthereumFilterEngine {
    public enum Error: Swift.Error {
        case filterNotFound(EthereumQuantity)
    }
    
    private let provider: Web3Provider
    
    private var timer: DispatchSourceTimer?
    
    private var lastFilterId: UInt64
    
    private var blockFilters: Dictionary<UInt64, EthereumBlockFilterProtocol>
    private var pendingBlockFilters: Dictionary<UInt64, EthereumBlockFilterProtocol>
    private var logFilters: Dictionary<UInt64, EthereumLogsFilterProtocol>
    private let counter: AtomicCounter
    
    private var lastBlock: EthereumBlockObject?
    
    private var lock: NSLock
    
    private let checkInterval: TimeInterval = 4.0
    private let filterLifeTime: TimeInterval = 300.0
    
    public init(provider: Web3Provider, counter: AtomicCounter) {
        self.provider = provider
        self.timer = nil
        self.lastFilterId = 0
        self.blockFilters = [:]
        self.pendingBlockFilters = [:]
        self.logFilters = [:]
        self.lock = NSLock()
        self.counter = counter
        self.lastBlock = nil
    }
    
    public func addLogsFilter(filter: EthereumLogsFilterProtocol) -> EthereumQuantity {
        lock.lock()
        defer { lock.unlock() }
        lastFilterId += 1
        logFilters[lastFilterId] = filter
        _checkTimer()
        return EthereumQuantity(integerLiteral: lastFilterId)
    }
    
    public func addBlockFilter(filter: EthereumBlockFilterProtocol) -> EthereumQuantity {
        lock.lock()
        defer { lock.unlock() }
        lastFilterId += 1
        blockFilters[lastFilterId] = filter
        _checkTimer()
        return EthereumQuantity(integerLiteral: lastFilterId)
    }
    
    public func addPendingBlockFilter(filter: EthereumBlockFilterProtocol) -> EthereumQuantity {
        lock.lock()
        defer { lock.unlock() }
        lastFilterId += 1
        pendingBlockFilters[lastFilterId] = filter
        _checkTimer()
        return EthereumQuantity(integerLiteral: lastFilterId)
    }
    
    public func removeFilter(id: EthereumQuantity) -> Bool {
        lock.lock()
        defer { lock.unlock() }
        let intId = UInt64(id.quantity)
        let result = logFilters.removeValue(forKey: intId) != nil
            || blockFilters.removeValue(forKey: intId) != nil
            || pendingBlockFilters.removeValue(forKey: intId) != nil
        _checkTimer()
        return result
    }
    
    public func getFilterChages(id: EthereumQuantity) throws -> EthereumFilterChangesObject {
        lock.lock()
        defer { lock.unlock() }
        let intId = UInt64(id.quantity)
        if var filter = logFilters[intId] {
            let changes = filter.getFilterChanges()
            logFilters[intId] = filter
            return .logs(changes)
        } else if var filter = blockFilters[intId] {
            let changes = filter.getFilterChanges()
            blockFilters[intId] = filter
            return .hashes(changes)
        } else if var filter = pendingBlockFilters[intId] {
            let changes = filter.getFilterChanges()
            pendingBlockFilters[intId] = filter
            return .hashes(changes)
        }
        throw Error.filterNotFound(id)
    }
    
    public func getFilterLogs(
        id: EthereumQuantity,
        cb: @escaping (Swift.Error?, [EthereumLogObject]?) -> Void
    ) {
        lock.lock()
        defer { lock.unlock() }
        if let filter = logFilters[UInt64(id.quantity)] {
            let req = RPCRequest<[EthereumGetLogsParams]>(
                id: Int(counter.next()),
                jsonrpc: Web3.jsonrpc,
                method: "eth_getLogs",
                params: [EthereumGetLogsParams(
                    fromBlock: filter.fromBlock,
                    toBlock: filter.toBlock,
                    address: filter.address,
                    topics: filter.topics
                )]
            )
            provider.send(request: req) { (response: Web3Response<[EthereumLogObject]>) in
                switch response.status {
                case .failure(let err): cb(err, nil)
                case .success(let res): cb(nil, res)
                }
            }
        } else {
            DispatchQueue.global().async {
                cb(Error.filterNotFound(id), nil)
            }
        }
    }
    
    private func _checkTimer() {
        if let timer = self.timer {
            if logFilters.count + blockFilters.count + pendingBlockFilters.count == 0 {
                timer.cancel()
                self.timer = nil
            }
        } else {
            if logFilters.count + blockFilters.count + pendingBlockFilters.count > 0 {
                let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .utility))
                timer.setEventHandler { [weak self] in
                    self?._tick()
                }
                timer.schedule(deadline: .now() + .milliseconds(100) , repeating: 4.0)
                timer.resume()
                self.timer = timer
            }
        }
    }
    
    private func _clearOutdatedFilters() {
        let now = Date(timeIntervalSinceNow: 0.0)
        blockFilters = blockFilters.filter { _, filter in
            now.timeIntervalSince(filter.lastFetched) < self.filterLifeTime
        }
        logFilters = logFilters.filter { _, filter in
            now.timeIntervalSince(filter.lastFetched) < self.filterLifeTime
        }
        pendingBlockFilters = pendingBlockFilters.filter { _, filter in
            now.timeIntervalSince(filter.lastFetched) < self.filterLifeTime
        }
    }
    
    private func _tick() {
        lock.lock()
        defer { lock.unlock() }
        _clearOutdatedFilters()
        _checkTimer()
        
        if blockFilters.count + logFilters.count > 0 {
            _updateLastBlock()
        }
        if pendingBlockFilters.count > 0 {
            _updatePendingBlock()
        }
    }
    
    private func _updateLastBlock() {
        let req = BasicRPCRequest(
            id: Int(counter.next()),
            jsonrpc: Web3.jsonrpc,
            method: "eth_getBlockByNumber",
            params: [EthereumQuantityTag.latest, false]
        )
        provider.send(request: req) { (response: Web3Response<EthereumBlockObject>) in
            if let block = response.result {
                self.lock.lock()
                defer { self.lock.unlock() }
                self.blockFilters = self.blockFilters.mapValues { filter in
                    var mFilter = filter
                    mFilter.apply(block: block)
                    return mFilter
                }
                if self.logFilters.count > 0 {
                    self._updateLogs(block: block)
                }
            }
        }
    }
    
    private func _updatePendingBlock() {
        let req = BasicRPCRequest(
            id: Int(counter.next()),
            jsonrpc: Web3.jsonrpc,
            method: "eth_getBlockByNumber",
            params: [EthereumQuantityTag.pending, false]
        )
        provider.send(request: req) { (response: Web3Response<EthereumBlockObject>) in
            if let block = response.result {
                self.lock.lock()
                defer { self.lock.unlock() }
                self.pendingBlockFilters = self.pendingBlockFilters.mapValues { filter in
                    var mFilter = filter
                    mFilter.apply(block: block)
                    return mFilter
                }
            }
        }
    }
    
    private func _updateLogs(block: EthereumBlockObject) {
        lock.lock()
        defer { lock.unlock() }
        guard lastBlock == nil || lastBlock!.number!.quantity < block.number!.quantity else {
            return
        }
        lastBlock = block
        let req = RPCRequest<[EthereumGetLogsParams]>(
            id: Int(counter.next()),
            jsonrpc: Web3.jsonrpc,
            method: "eth_getLogs",
            params: [EthereumGetLogsParams(blockhash: block.hash!)]
        )
        provider.send(request: req) { (response: Web3Response<[EthereumLogObject]>) in
            if let logs = response.result {
                self.lock.lock()
                defer { self.lock.unlock() }
                self.logFilters = self.logFilters.mapValues { filter in
                    var mFilter = filter
                    mFilter.apply(block: block, logs: logs)
                    return mFilter
                }
            }
        }
    }
    
    deinit {
        self.timer?.cancel()
    }
}
