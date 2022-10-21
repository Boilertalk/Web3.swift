import Foundation

public extension Web3 {

    /**
     * Initializes a new instance of `Web3` with a WebSocket RPC interface and the given url.
     *
     * - parameter wsUrl: The URL of the HTTP RPC API.
     */
    init(wsUrl: String) throws {
        try self.init(provider: Web3WebSocketProvider(wsUrl: wsUrl), rpcId: 1)
    }
}
