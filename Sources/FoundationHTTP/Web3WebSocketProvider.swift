import Foundation
import Dispatch
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import WebSocketKit
import NIOPosix

public class Web3WebSocketProvider: Web3Provider {

    // MARK: - Properties

    let encoder = JSONEncoder()
    let decoder = JSONDecoder()

    let queue: DispatchQueue

    public private(set) var closed: Bool = false

    public let wsUrl: URL

    public let timeoutNanoSeconds: UInt64

    private let wsEventLoopGroup: EventLoopGroup
    private var webSocket: WebSocket!

    // Stores ids and notification groups
    private let pendingRequests: SynchronizedDictionary<Int, DispatchGroup> = [:]
    // Stores responses as strings
    private let pendingResponses: SynchronizedDictionary<Int, String> = [:]

    // Maintain sync current id
    private let nextIdQueue = DispatchQueue(label: "Web3WebSocketProvider_nextIdQueue", attributes: .concurrent)
    private var currentId = 1
    private var nextId: Int {
        get {
            let retId = currentId

            nextIdQueue.sync(flags: .barrier) {
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
    }

    // MARK: - Initialization

    public init(wsUrl: String, timeout: DispatchTimeInterval = .seconds(120)) throws {
        // Concurrent queue for faster concurrent requests
        self.queue = DispatchQueue(label: "Web3WebSocketProvider", attributes: .concurrent)

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
        queue.async {
            let replacedIdRequest = RPCRequest(id: self.nextId, jsonrpc: request.jsonrpc, method: request.method, params: request.params)

            let body: Data
            do {
                body = try self.encoder.encode(replacedIdRequest)
            } catch {
                let err = Web3Response<Result>(error: .requestFailed(error))
                response(err)
                return
            }

            let responseGroup = DispatchGroup()
            self.pendingRequests[replacedIdRequest.id] = responseGroup
            responseGroup.enter()

            let promise = self.wsEventLoopGroup.next().makePromise(of: Void.self)
            self.webSocket.send(String(data: body, encoding: .utf8) ?? "", promise: promise)
            promise.futureResult.whenComplete { result in
                switch result {
                case .success(_):
                    self.queue.async {
                        let result = responseGroup.wait(timeout: DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + self.timeoutNanoSeconds))

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
        }
    }

    // MARK: - Helpers

    private struct IdOnly: Codable {
        let id: Int
    }

    private func registerWebSocketListeners() {
        // Receive response
        webSocket.onText { ws, string in
            if let data = string.data(using: .utf8), let idOnly = try? self.decoder.decode(IdOnly.self, from: data) {
                self.pendingResponses[idOnly.id] = string
                self.pendingRequests[idOnly.id]?.leave()
            }
        }

        // Handle close
        webSocket.onClose.whenComplete { result in
            if !self.closed && self.webSocket.isClosed {
                self.queue.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: DispatchTime.now().uptimeNanoseconds + 100_000_000)) {
                    try? self.reconnect()
                }
            }
        }
    }

    private func reconnect() throws {
        // Reconnect
        try WebSocket.connect(to: wsUrl, on: wsEventLoopGroup) { ws in
            self.webSocket = ws
        }.wait()

        registerWebSocketListeners()
    }
}
