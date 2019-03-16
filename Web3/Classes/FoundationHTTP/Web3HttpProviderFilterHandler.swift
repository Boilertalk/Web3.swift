//
//  Web3HttpProviderFilterHandler.swift
//  Web3
//
//  Created by Yehor Popovych on 3/15/19.
//

import Foundation

public struct Web3HttpProviderFilterHandler: Web3Provider {
    private let _provider: Web3Provider
    private let _counter: AtomicCounter
    private let _filterEngine: EthereumFilterEngine
    
    public init(_ web3Provider: Web3Provider, counter: AtomicCounter) {
        _provider = web3Provider
        _counter = counter
        _filterEngine = EthereumFilterEngine(provider: web3Provider, counter: counter)
    }
    
    public func send<Params, Result>(request: RPCRequest<Params>, response: @escaping Web3ResponseCompletion<Result>) {
        switch request.method {
        case "eth_newFilter":
            let req = request as! RPCRequest<[EthereumNewFilterParams]>
            guard req.params.count > 0 else {
                response(Web3Response(id: req.id, error: .requestFailed(nil)))
                return
            }
            let filterId = _filterEngine
                .addLogsFilter(filter: EthereumLogsFilter(
                    address: req.params[0].address, topics: req.params[0].topics ?? []
                )
            )
            response(Web3Response(id: request.id, value: filterId) as! Web3Response<Result>)
        case "eth_newBlockFilter":
            let filterId = _filterEngine.addBlockFilter(filter: EthereumBlockFilter())
            response(Web3Response(id: request.id, value: filterId) as! Web3Response<Result>)
        case "eth_newPendingTransactionFilter":
            let filterId = _filterEngine.addPendingBlockFilter(filter: EthereumPendingTransactionFilter())
            response(Web3Response(id: request.id, value: filterId) as! Web3Response<Result>)
        case "eth_uninstallFilter":
            let params = (request as! RPCRequest<EthereumValue>).params.array
            guard params != nil, params!.count > 0, let id = params![0].ethereumQuantity else {
                response(Web3Response(id: request.id, error: .requestFailed(nil)))
                return
            }
            let result = _filterEngine.removeFilter(id: id)
            response(Web3Response(id: request.id, value: result) as! Web3Response<Result>)
        case "eth_getFilterChanges":
            let params = (request as! RPCRequest<EthereumValue>).params.array
            guard params != nil, params!.count > 0, let id = params![0].ethereumQuantity else {
                response(Web3Response(id: request.id, error: .requestFailed(nil)))
                return
            }
            do {
                let changes = try _filterEngine.getFilterChages(id: id)
                response(Web3Response(id: request.id, value: changes) as! Web3Response<Result>)
            } catch(let err) {
                response(Web3Response(id: request.id, error: err))
            }
        case "eth_getFilterLogs":
            let params = (request as! RPCRequest<EthereumValue>).params.array
            guard params != nil, params!.count > 0, let id = params![0].ethereumQuantity else {
                response(Web3Response(id: request.id, error: .requestFailed(nil)))
                return
            }
            _filterEngine.getFilterLogs(id: id) { err, res in
                if let err = err {
                    response(Web3Response(id: request.id, error: err))
                    return
                }
                response(Web3Response(id: request.id, value: res!) as! Web3Response<Result>)
            }
        default:
            _provider.send(request: request, response: response)
        }
    }
}
