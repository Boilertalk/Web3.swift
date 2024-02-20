import Quick
import Nimble
@testable import Web3
import BigInt
import PromiseKit
#if canImport(Web3PromiseKit)
    @testable import Web3PromiseKit
#endif
import NIOConcurrencyHelpers

class Web3EventsTests: QuickSpec {

    let infuraUrl = "https://mainnet.infura.io/v3/362c324f295a4032b2fe87d910aaa33a"
    let infuraWsUrl = "wss://mainnet.infura.io/ws/v3/362c324f295a4032b2fe87d910aaa33a"

    override func spec() {
        describe("web3 events tests") {
            let web3 = Web3(rpcURL: infuraUrl)
            let web3Ws: Web3! = try? Web3(wsUrl: infuraWsUrl)
            if web3Ws == nil {
                fail("should initialize ws web3")
            }

            context("unidirectional provider events") {
                it("should throw when trying to subscribe to new heads") {
                    expect { try web3.eth.subscribeToNewHeads(subscribed: { subId in }, onEvent: { block in }) }.to(throwError())
                }

                it("should throw when trying to subscribe to new pending transactions") {
                    expect { try web3.eth.subscribeToNewPendingTransactions(subscribed: { subId in }, onEvent: { hash in }) }.to(throwError())
                }

                it("should throw when trying to subscribe to logs") {
                    expect { try web3.eth.subscribeToLogs(subscribed: { subId in }, onEvent: { log in }) }.to(throwError())
                }

                it("should throw when trying to unsubscribe") {
                    expect { try web3.eth.unsubscribe(subscriptionId: "abc", completion: { success in }) }.to(throwError())
                }
            }

            context("ws bidirectional provider events new heads") {
                it("should subscribe and unsubscribe to new heads") {
                    waitUntil(timeout: .seconds(30)) { done in
                        var subId = ""
                        let cancelled = NIOLockedValueBox(false)
                        try! web3Ws.eth.subscribeToNewHeads(subscribed: { response in
                            expect(response.result).toNot(beNil())

                            subId = response.result ?? ""
                        }, onEvent: { newHead in
                            guard let _ = newHead.result else {
                                if cancelled.withLockedValue({ $0 }) {
                                    switch (newHead.error as? Web3Response<EthereumBlockObject>.Error) {
                                    case .subscriptionCancelled(_):
                                        // Expected
                                        return
                                    default:
                                        break
                                    }
                                }

                                fail("event received but with error")
                                return
                            }

                            // Tests done. Test unsubscribe.
                            if !cancelled.withLockedValue({
                                let old = $0
                                $0 = true
                                return old
                            }) {
                                try! web3Ws.eth.unsubscribe(subscriptionId: subId, completion: { unsubscribed in
                                    expect(unsubscribed).to(beTrue())

                                    done()
                                })
                            }
                        })
                    }
                }
            }

            context("ws bidirectional provider events new pending transactions") {
                it("should subscribe and unsubscribe to new pending transactions") {
                    waitUntil(timeout: .seconds(5)) { done in
                        var subId = ""
                        let cancelled = NIOLockedValueBox(false)
                        try! web3Ws.eth.subscribeToNewPendingTransactions(subscribed: { response in
                            expect(response.result).toNot(beNil())

                            subId = response.result ?? ""
                        }, onEvent: { hash in
                            guard let hashValue = hash.result else {
                                if cancelled.withLockedValue({ $0 }) {
                                    switch (hash.error as? Web3Response<EthereumData>.Error) {
                                    case .subscriptionCancelled(_):
                                        // Expected
                                        return
                                    default:
                                        break
                                    }
                                }

                                fail("event received but with error")
                                return
                            }

                            expect(hashValue.bytes.count).to(equal(32))

                            // Tests done. Test unsubscribe.
                            if !cancelled.withLockedValue({
                                let old = $0
                                $0 = true
                                return old
                            }) {
                                try! web3Ws.eth.unsubscribe(subscriptionId: subId, completion: { unsubscribed in
                                    expect(unsubscribed).to(beTrue())

                                    done()
                                })
                            }
                        })
                    }
                }
            }

            context("ws bidirectional provider events generic logs") {
                it("should subscribe and unsubscribe to all logs") {
                    waitUntil(timeout: .seconds(60)) { done in
                        var subId = ""
                        let cancelled = NIOLockedValueBox(false)
                        try! web3Ws.eth.subscribeToLogs(subscribed: { response in
                            expect(response.result).toNot(beNil())

                            subId = response.result ?? ""
                        }, onEvent: { log in
                            guard let _ = log.result else {
                                if cancelled.withLockedValue({ $0 }) {
                                    switch (log.error as? Web3Response<EthereumLogObject>.Error) {
                                    case .subscriptionCancelled(_):
                                        // Expected
                                        return
                                    default:
                                        break
                                    }
                                }

                                fail("event received but with error")
                                return
                            }

                            // Tests done. Test unsubscribe.
                            if !cancelled.withLockedValue({
                                let old = $0
                                $0 = true
                                return old
                            }) {
                                try! web3Ws.eth.unsubscribe(subscriptionId: subId, completion: { unsubscribed in
                                    expect(unsubscribed).to(beTrue())

                                    done()
                                })
                            }
                        })
                    }
                }
            }

            context("ws bidirectional provider events specific logs") {
                it("should subscribe and unsubscribe to specific logs") {
                    // We test USDT transfers as they happen basically every block
                    waitUntil(timeout: .seconds(60)) { done in
                        var subId = ""
                        let cancelled = NIOLockedValueBox(false)
                        try! web3Ws.eth.subscribeToLogs(
                            addresses: [EthereumAddress(hex: "0xdAC17F958D2ee523a2206206994597C13D831ec7", eip55: false )],
                            topics: [[EthereumData(ethereumValue: "0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef")]],
                            subscribed: { response in
                                expect(response.result).toNot(beNil())

                                subId = response.result ?? ""
                            },
                            onEvent: { log in
                                guard let topicValue = log.result else {
                                    if cancelled.withLockedValue({ $0 }) {
                                        switch (log.error as? Web3Response<EthereumLogObject>.Error) {
                                        case .subscriptionCancelled(_):
                                            // Expected
                                            return
                                        default:
                                            break
                                        }
                                    }

                                    fail("event received but with error")
                                    return
                                }

                                expect(topicValue.topics.first?.hex()).to(equal("0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef"))

                                // Tests done. Test unsubscribe.
                                if !cancelled.withLockedValue({
                                    let old = $0
                                    $0 = true
                                    return old
                                }) {
                                    try! web3Ws.eth.unsubscribe(subscriptionId: subId, completion: { unsubscribed in
                                        expect(unsubscribed).to(beTrue())

                                        done()
                                    })
                                }
                            }
                        )
                    }
                }
            }
        }
    }
}
