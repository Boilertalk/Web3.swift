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

    let execQueue: DispatchQueue
    let webSocketSendQueue: DispatchQueue

    public private(set) var closed: Bool = false

    public let wsUrl: URL

    public let timeoutNanoSeconds: UInt64

    private let wsEventLoopGroup: EventLoopGroup
    public private(set) var webSocket: WebSocket!

    // Stores ids and notification groups
    private let pendingRequests: SynchronizedDictionary<Int, DispatchSemaphore> = [:]
    // Stores responses as strings
    private let pendingResponses: SynchronizedDictionary<Int, String> = [:]
    
    // Stores subscription ids and semaphores
    private let currentSubscriptions: SynchronizedDictionary<String, DispatchSemaphore> = [:]
    // Stores subscription responses
    private let pendingSubscriptionResponses: SynchronizedDictionary<String, SynchronizedArray<String>> = [:]
    // A key for cancelling subscriptions
    private let cancelSubscriptionValue = "::::\(UUID().uuidString)::::"

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

        case subscriptionCancelled
    }

    // MARK: - Initialization

    public init(wsUrl: String, timeout: DispatchTimeInterval = .seconds(120)) throws {
        // Concurrent queue for faster concurrent requests
        self.execQueue = DispatchQueue(label: "Web3WebSocketProvider", attributes: .concurrent)
        self.webSocketSendQueue = DispatchQueue(label: "Web3WebSocketProvider", attributes: .concurrent)

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
    }

    // MARK: - Web3Provider

    public func send<Params, Result>(request: RPCRequest<Params>, response: @escaping Web3ResponseCompletion<Result>) {
        execQueue.async {
            let replacedIdRequest = RPCRequest(id: self.nextId, jsonrpc: request.jsonrpc, method: request.method, params: request.params)

            let body: Data
            do {
                body = try self.encoder.encode(replacedIdRequest)
            } catch {
                let err = Web3Response<Result>(error: .requestFailed(error))
                response(err)
                return
            }

            let responseSemaphore = DispatchSemaphore(value: 0)
            self.pendingRequests[replacedIdRequest.id] = responseSemaphore

            let promise = self.wsEventLoopGroup.next().makePromise(of: Void.self)
            promise.futureResult.whenComplete { result in
                switch result {
                case .success(_):
                    self.execQueue.async {
                        let result = responseSemaphore.wait(timeout: DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + self.timeoutNanoSeconds))

                        defer {
                            // Remove from pending requests
                            self.pendingRequests[replacedIdRequest.id] = nil

                            // Delete pending responses
                            self.pendingResponses[replacedIdRequest.id] = nil
                        }

                        // Generic failure sender
                        let failure: (_ error: Error) -> () = { error in
                            let err = Web3Response<Result>(error: .serverError(error))
                            response(err)
                            return
                        }

                        switch result {
                        case .success:
                            // This is the response as a string
                            let responseString = self.pendingResponses[replacedIdRequest.id]

                            // Parse response
                            guard let responseData = responseString?.data(using: .utf8), let decoded = try? self.decoder.decode(RPCResponse<Result>.self, from: responseData) else {
                                failure(Error.unexpectedResponse)
                                return
                            }
                            // Put back original request id
                            let idReplacedDecoded = RPCResponse<Result>(id: request.id, jsonrpc: decoded.jsonrpc, result: decoded.result, error: decoded.error)

                            // Return result
                            let res = Web3Response(rpcResponse: idReplacedDecoded)
                            response(res)
                        case .timedOut:
                            failure(Error.timeoutError)
                            break
                        }
                    }
                case .failure(let error):
                    let err = Web3Response<Result>(error: .requestFailed(error))
                    response(err)
                    return
                }
            }

            // Send Request through WebSocket once the Promise was set
            self.webSocketSendQueue.async(flags: .barrier) {
                self.webSocket.send(String(data: body, encoding: .utf8) ?? "", promise: promise)
            }
        }
    }
    
    // MARK: - Web3BidirectionalProvider
    
    public func subscribe<Params, Result>(request: RPCRequest<Params>, response: @escaping Web3ResponseCompletion<String>, onEvent: @escaping Web3ResponseCompletion<Result>) {
        execQueue.async {
            self.send(request: request) { (_ resp: Web3Response<String>) -> Void in
                guard let subscriptionId = resp.result else {
                    let err = Web3Response<String>(error: .serverError(resp.error))
                    response(err)
                    return
                }
                
                // Return subscription id
                let res = Web3Response(status: .success(subscriptionId))
                response(res)
                
                // Now we need to register the subscription id to our internal subscription id register
                let subscriptionSemaphore = DispatchSemaphore(value: 0)
                self.pendingSubscriptionResponses[subscriptionId] = SynchronizedArray(array: [])
                self.currentSubscriptions[subscriptionId] = subscriptionSemaphore
                
                self.execQueue.async {
                    while true {
                        subscriptionSemaphore.wait()

                        guard let notification = self.pendingSubscriptionResponses[subscriptionId]?.removeFirst() else {
                            continue
                        }

                        if notification == self.cancelSubscriptionValue {
                            // We are done, the subscription was cancelled. We don't care why
                            self.currentSubscriptions[subscriptionId] = nil
                            self.pendingSubscriptionResponses[subscriptionId] = nil

                            // Notify client
                            let err = Web3Response<Result>(error: .subscriptionCancelled(Error.subscriptionCancelled))
                            onEvent(err)

                            break
                        }

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
            }
        }
    }

    public func unsubscribe(subscriptionId: String, completion: @escaping (_ success: Bool) -> Void) {
        let unsubscribe = BasicRPCRequest(id: 1, jsonrpc: Web3.jsonrpc, method: "eth_unsubscribe", params: [subscriptionId])

        self.send(request: unsubscribe) { (_ resp: Web3Response<Bool>) -> Void in
            let success = resp.result ?? false
            if success {
                self.pendingSubscriptionResponses[subscriptionId]?.append(self.cancelSubscriptionValue)
                self.currentSubscriptions[subscriptionId]?.signal()
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
        webSocket.onText { ws, string in
            guard let data = string.data(using: .utf8) else {
                return
            }

            if let tmpCodable = try? self.decoder.decode(WebSocketOnTextTmpCodable.self, from: data) {
                if let id = tmpCodable.id {
                    self.pendingResponses[id] = string
                    self.pendingRequests[id]?.signal()
                } else if let params = tmpCodable.params {
                    self.pendingSubscriptionResponses[params.subscription]?.append(string)
                    self.currentSubscriptions[params.subscription]?.signal()
                }
            }
        }

        // Handle close
        webSocket.onClose.whenComplete { result in
            if !self.closed && self.webSocket.isClosed {
                self.execQueue.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + 100_000_000)) {
                    try? self.reconnect()
                }
            }
        }
    }

    private func reconnect() throws {
        // Delete all subscriptions
        for key in currentSubscriptions.dictionary.keys {
            pendingSubscriptionResponses[key]?.append(cancelSubscriptionValue)
            currentSubscriptions[key]?.signal()
        }

        // Reconnect
        try WebSocket.connect(to: wsUrl, on: wsEventLoopGroup) { ws in
            self.webSocket = ws
        }.wait()

        registerWebSocketListeners()
    }
}
