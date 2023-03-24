import Foundation
import Dispatch
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import WebSocketKit
import NIOPosix

public class Web3WebSocketProvider: Web3Provider, Web3BidirectionalProvider {

    // MARK: - Properties

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    private let receiveQueue: DispatchQueue
    private let reconnectQueue: DispatchQueue

    public private(set) var closed: Bool = false

    public let wsUrl: URL

    public let timeoutNanoSeconds: UInt64

    private let wsEventLoopGroup: EventLoopGroup
    public private(set) var webSocket: WebSocket!

    // Stores ids and notification groups
    private let pendingRequests: SynchronizedDictionary<Int, (timeoutItem: DispatchWorkItem, responseCompletion: (_ response: String?) -> Void)> = [:]
    
    // Stores subscription ids and semaphores
    private let currentSubscriptions: SynchronizedDictionary<String, (onCancel: () -> Void, onNotification: (_ notification: String) -> Void)> = [:]

    // Maintain sync current id
    private let nextIdQueue = DispatchQueue(label: "Web3WebSocketProvider_nextIdQueue", attributes: .concurrent)
    private var currentId = 1
    private var nextId: Int {
        get {
            var retId: Int!

            nextIdQueue.sync(flags: .barrier) {
                retId = currentId

                if currentId < UInt16.max {
                    currentId += 1
                } else {
                    currentId = 1
                }
            }

            return retId
        }
    }

    public enum Error: Swift.Error {
        case invalidUrl

        case timeoutError
        case unexpectedResponse
        case webSocketClosedRetry

        case subscriptionCancelled
    }

    // MARK: - Initialization

    public init(wsUrl: String, timeout: DispatchTimeInterval = .seconds(120)) throws {
        // Concurrent queue for faster concurrent requests
        self.receiveQueue = DispatchQueue(label: "Web3WebSocketProvider_Receive", attributes: .concurrent)
        self.reconnectQueue = DispatchQueue(label: "Web3WebSocketProvider_Reconnect", attributes: .concurrent)

        guard let url = URL(string: wsUrl) else {
            throw Error.invalidUrl
        }
        self.wsUrl = url

        // Timeout in ns
        switch timeout {
        case .seconds(let int):
            self.timeoutNanoSeconds = UInt64(int * 1_000_000_000)
        case .milliseconds(let int):
            self.timeoutNanoSeconds = UInt64(int * 1_000_000)
        case .microseconds(let int):
            self.timeoutNanoSeconds = UInt64(int * 1_000)
        case .nanoseconds(let int):
            self.timeoutNanoSeconds = UInt64(int)
        default:
            self.timeoutNanoSeconds = UInt64(120 * 1_000_000_000)
        }

        self.wsEventLoopGroup = MultiThreadedEventLoopGroup(numberOfThreads: 4)

        // Initial connect
        try reconnect()
    }

    deinit {
        closed = true
        _ = webSocket.close(code: .goingAway)

        // As described in https://github.com/apple/swift-nio/issues/2371
        try? wsEventLoopGroup.syncShutdownGracefully()
    }

    // MARK: - Web3Provider

    public func send<Params, Result>(request: RPCRequest<Params>, response: @escaping Web3ResponseCompletion<Result>) {
        let replacedIdRequest = RPCRequest(id: self.nextId, jsonrpc: request.jsonrpc, method: request.method, params: request.params)

        let body: Data
        do {
            body = try self.encoder.encode(replacedIdRequest)
        } catch {
            let err = Web3Response<Result>(error: .requestFailed(error))
            response(err)
            return
        }

        // Generic failure sender
        let failure: (_ error: Error) -> () = { error in
            let err = Web3Response<Result>(error: .serverError(error))
            response(err)
            return
        }

        // The timeout
        let timeoutItem = DispatchWorkItem {
            self.pendingRequests[replacedIdRequest.id] = nil

            // Respond to user
            failure(Error.timeoutError)
        }
        self.receiveQueue.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + self.timeoutNanoSeconds), execute: timeoutItem)

        // The response
        let responseCompletion: (_ response: String?) -> Void = { responseString in
            defer {
                // Remove from pending requests
                self.pendingRequests[replacedIdRequest.id] = nil
            }

            timeoutItem.cancel()

            self.pendingRequests.getValueAsync(key: replacedIdRequest.id) { value in
                guard value != nil else {
                    // Timeout happened already. Rare. Timeout sent the timeout error. Do nothing.
                    return
                }

                self.receiveQueue.async {
                    guard let responseString = responseString else {
                        failure(Error.webSocketClosedRetry)
                        return
                    }

                    // Parse response
                    guard let responseData = responseString.data(using: .utf8), let decoded = try? self.decoder.decode(RPCResponse<Result>.self, from: responseData) else {
                        failure(Error.unexpectedResponse)
                        return
                    }
                    // Put back original request id
                    let idReplacedDecoded = RPCResponse<Result>(id: request.id, jsonrpc: decoded.jsonrpc, result: decoded.result, error: decoded.error)

                    // Return result
                    let res = Web3Response(rpcResponse: idReplacedDecoded)
                    response(res)
                }
            }
        }

        // Set the pending request
        self.pendingRequests[replacedIdRequest.id] = (timeoutItem: timeoutItem, responseCompletion: responseCompletion)

        // Response result for sending the message over the WebSocket
        let promise = self.wsEventLoopGroup.next().makePromise(of: Void.self)
        promise.futureResult.whenComplete { result in
            switch result {
            case .success(_):
                break
            case .failure(let error):
                let err = Web3Response<Result>(error: .requestFailed(error))
                response(err)
                return
            }
        }

        // Send Request through WebSocket once the Promise was set
        self.webSocket.send(String(data: body, encoding: .utf8) ?? "", promise: promise)
    }
    
    // MARK: - Web3BidirectionalProvider
    
    public func subscribe<Params, Result>(request: RPCRequest<Params>, response: @escaping Web3ResponseCompletion<String>, onEvent: @escaping Web3ResponseCompletion<Result>) {
        self.send(request: request) { (_ resp: Web3Response<String>) -> Void in
            guard let subscriptionId = resp.result else {
                let err = Web3Response<String>(error: .serverError(resp.error))
                response(err)
                return
            }

            // Return subscription id
            let res = Web3Response(status: .success(subscriptionId))
            response(res)

            let queue = self.receiveQueue

            // Subscription cancelled by us or the server, not the User.
            let onCancel: () -> Void = {
                queue.async {
                    // We are done, the subscription was cancelled. We don't care why
                    self.currentSubscriptions[subscriptionId] = nil

                    // Notify client
                    let err = Web3Response<Result>(error: .subscriptionCancelled(Error.subscriptionCancelled))
                    onEvent(err)
                }
            }

            let notificationReceived: (_ notification: String) -> Void = { notification in
                queue.async {
                    // Generic failure sender
                    let failure: (_ error: Error) -> () = { error in
                        let err = Web3Response<Result>(error: .serverError(error))
                        onEvent(err)
                        return
                    }

                    // Parse notification
                    guard let notificationData = notification.data(using: .utf8), let decoded = try? self.decoder.decode(RPCEventResponse<Result>.self, from: notificationData) else {
                        failure(Error.unexpectedResponse)
                        return
                    }

                    // Return result
                    let res = Web3Response(rpcEventResponse: decoded)
                    onEvent(res)
                }
            }

            // Now we need to register the subscription id to our internal subscription id register
            self.currentSubscriptions[subscriptionId] = (onCancel: onCancel, onNotification: notificationReceived)
        }
    }

    public func unsubscribe(subscriptionId: String, completion: @escaping (_ success: Bool) -> Void) {
        let unsubscribe = BasicRPCRequest(id: 1, jsonrpc: Web3.jsonrpc, method: "eth_unsubscribe", params: [subscriptionId])

        self.send(request: unsubscribe) { (_ resp: Web3Response<Bool>) -> Void in
            let success = resp.result ?? false
            if success {
                self.currentSubscriptions.getValueAsync(key: subscriptionId) { value in
                    self.receiveQueue.async {
                        value?.onCancel()
                    }
                }
            }

            completion(success)
        }
    }

    // MARK: - Helpers

    private struct WebSocketOnTextTmpCodable: Codable {
        let id: Int?

        let params: Params?

        fileprivate struct Params: Codable {
            let subscription: String
        }
    }

    private func registerWebSocketListeners() {
        // Receive response
        webSocket.onText { [weak self] ws, string in
            guard let self else {
                return
            }

            self.receiveQueue.async {
                guard let data = string.data(using: .utf8) else {
                    return
                }

                if let tmpCodable = try? self.decoder.decode(WebSocketOnTextTmpCodable.self, from: data) {
                    if let id = tmpCodable.id {
                        self.pendingRequests.getValueAsync(key: id) { value in
                            self.receiveQueue.async {
                                value?.responseCompletion(string)
                            }
                        }
                    } else if let params = tmpCodable.params {
                        self.currentSubscriptions.getValueAsync(key: params.subscription) { value in
                            self.receiveQueue.async {
                                value?.onNotification(string)
                            }
                        }
                    }
                }
            }
        }

        // Handle close
        webSocket.onClose.whenComplete { [weak self] result in
            guard let self else {
                return
            }

            if !self.closed && self.webSocket.isClosed {
                self.reconnectQueue.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + 100_000_000)) {
                    try? self.reconnect()
                }
            }
        }
    }

    private func reconnect() throws {
        // Delete all subscriptions
        for key in currentSubscriptions.dictionary.keys {
            currentSubscriptions.getValueAsync(key: key) { value in
                self.receiveQueue.async {
                    value?.onCancel()
                }
            }
        }
        for key in pendingRequests.dictionary.keys {
            pendingRequests.getValueAsync(key: key) { value in
                self.receiveQueue.async {
                    value?.responseCompletion(nil)
                }
            }
        }

        // Reconnect
        try WebSocket.connect(to: wsUrl, configuration: .init(maxFrameSize: Int(min(Int64(UInt32.max), Int64(Int.max)))), on: wsEventLoopGroup) { ws in
            self.webSocket = ws

            self.registerWebSocketListeners()
        }.wait()
    }
}
