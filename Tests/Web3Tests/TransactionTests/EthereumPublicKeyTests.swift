//
//  EthereumPublicKeyTests.swift
//  Web3_Tests
//
//  Created by Koray Koska on 07.02.18.
//

import Quick
import Nimble
@testable import Web3

class EthereumPublicKeyTests: QuickSpec {

    override func spec() {
        describe("ethereum public key checks") {
            context("public key verification") {

                it("should be a valid public key") {
                    let hex = "0x5ff2ea6b8d33785647dad53ff31548f8d173845cabccde40fe810b9bc5fc20394035c7173c95a352576dec3124a83f6581bae850cf7d770b12df995a325b7106"
                    let bytes: [UInt8] = [
                        0x5f, 0xf2, 0xea, 0x6b, 0x8d, 0x33, 0x78, 0x56, 0x47, 0xda, 0xd5, 0x3f, 0xf3, 0x15, 0x48, 0xf8,
                        0xd1, 0x73, 0x84, 0x5c, 0xab, 0xcc, 0xde, 0x40, 0xfe, 0x81, 0x0b, 0x9b, 0xc5, 0xfc, 0x20, 0x39,
                        0x40, 0x35, 0xc7, 0x17, 0x3c, 0x95, 0xa3, 0x52, 0x57, 0x6d, 0xec, 0x31, 0x24, 0xa8, 0x3f, 0x65,
                        0x81, 0xba, 0xe8, 0x50, 0xcf, 0x7d, 0x77, 0x0b, 0x12, 0xdf, 0x99, 0x5a, 0x32, 0x5b, 0x71, 0x06
                    ]

                    let pub = try? EthereumPublicKey(hexPublicKey: hex)
                    expect(pub).toNot(beNil())
                    expect(pub?.rawPublicKey) == bytes

                    let pub2 = try? EthereumPublicKey(publicKey: bytes)
                    expect(pub2).toNot(beNil())
                    expect(pub2?.rawPublicKey) == bytes

                    // Both should be the same private key
                    expect(pub?.rawPublicKey) == pub2?.rawPublicKey

                    // hex should match
                    expect(pub?.hex()) == hex
                    expect(pub2?.hex()) == hex
                }

                it("should be edge case invalid public keys") {
                    // Yes I know, those pubkeys are not real 'edge cases' as public keys are coordinates on the
                    // secp256k1 curve and not ascending numbers, but let's just call them like that for the tests.

                    let hexMin = "0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
                    do {
                        let q = try EthereumPublicKey(hexPublicKey: hexMin)
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumPublicKey.Error.keyMalformed))
                    }

                    let haxMax = "0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"
                    do {
                        let q = try EthereumPublicKey(hexPublicKey: haxMax)
                        expect(q).to(beNil(), description: "The value \(q) should not exist")
                    } catch {
                        expect(error).to(matchError(EthereumPublicKey.Error.keyMalformed))
                    }
                }
            }

            context("ethereum address verification") {

                it("should generate a valid ethereum address") {
                    let hex = "0x5872ec8b7f69bebfd6104d5eb19a339e9316afcc84864c98bbb3d5e10f0eea21b361d2cb1890113c85c5fc633fd0897223b69823a9c59341dd2981b0fb978671"
                    let pub = try? EthereumPublicKey(hexPublicKey: hex)

                    expect(pub?.address.hex(eip55: false)) == "0xb54c5e59124546034bf1b8a07b52e35b34cb5ff8"
                    expect(pub?.address.hex(eip55: true)) == "0xB54C5E59124546034BF1b8a07b52e35b34cb5Ff8"
                }
            }

            context("hashable") {
                it("should produce correct hashValues") {
                    let hex = "0x5872ec8b7f69bebfd6104d5eb19a339e9316afcc84864c98bbb3d5e10f0eea21b361d2cb1890113c85c5fc633fd0897223b69823a9c59341dd2981b0fb978671"
                    let pub1 = try? EthereumPublicKey(hexPublicKey: hex)
                    let pub2 = try? EthereumPublicKey(hexPublicKey: hex)

                    expect(pub1?.hashValue) == pub2?.hashValue
                }

                it("should produce different hashValues") {
                    let hex = "0x5872ec8b7f69bebfd6104d5eb19a339e9316afcc84864c98bbb3d5e10f0eea21b361d2cb1890113c85c5fc633fd0897223b69823a9c59341dd2981b0fb978671"
                    let hex2 = "0x735e1f29385d943e41ee3d72c3f867837bf279b52db4c42cf3904186edb7c957db34cfda5a4d0620556ce4a539cfb023576fe0e768eece9f0001fedf3bcc448d"
                    let pub1 = try? EthereumPublicKey(hexPublicKey: hex)
                    let pub2 = try? EthereumPublicKey(hexPublicKey: hex2)

                    expect(pub1?.hashValue) != pub2?.hashValue
                }
            }

            context("Public key generation from elliptic curve") {
                let rlpDecoder = RLPDecoder()

                it("should correctly verify the signature") {
                    let rawTx = "0xf8710180830f4240850d5bd0dff6825208944f5e9d9e6e05af22ef7683548c1c67a0436ea86987133a618ca1c85080c001a0f71d478c03498d090cf00e80f1bf4bba753dcb06fdcd5b0a0d683adb19a9ee5aa04aaa7c9720b1e3e13af27e20f489fa3ad4668ef5d4786176e47453192c4912e1".hexToBytes()
                    let rlpArray = try? rlpDecoder.decode(rawTx)
                    let tx = try! EthereumSignedTransaction(rlp: rlpArray!)

                    let rlp = RLPItem(
                        nonce: tx.nonce,
                        gasPrice: tx.gasPrice,
                        maxFeePerGas: tx.maxFeePerGas,
                        maxPriorityFeePerGas: tx.maxPriorityFeePerGas,
                        gasLimit: tx.gasLimit,
                        to: tx.to,
                        value: tx.value,
                        data: tx.data,
                        chainId: tx.chainId,
                        accessList: tx.accessList,
                        transactionType: tx.transactionType
                    )
                    let rawRlp = try RLPEncoder().encode(rlp)
                    var messageToSign = Bytes()
                    messageToSign.append(0x02)
                    messageToSign.append(contentsOf: rawRlp)

                    let originalPublicKey = try EthereumPublicKey(hexPublicKey: "0xcca03e481ecd3c7fe43bc5e3c495a8601557c52c509d9ca7fc89d3052a9855209a2a73b7f929e664baf24abb8443ebbd2ae7ef5bce3741ec013b721a545c136f")

                    expect(originalPublicKey.address.hex(eip55: true)) == "0x3d4CE0e38A3F4294df8AE65bC8A57b8eEc976203"

                    let isCorrect = try originalPublicKey.verifySignature(message: messageToSign, v: tx.v.makeBytes().bigEndianUInt!, r: tx.r.quantity, s: tx.s.quantity)
                    expect(isCorrect) == true
                }

                it("should generate the correct from address") {
                    let rawTx = "0xf8710180830f4240850d5bd0dff6825208944f5e9d9e6e05af22ef7683548c1c67a0436ea86987133a618ca1c85080c001a0f71d478c03498d090cf00e80f1bf4bba753dcb06fdcd5b0a0d683adb19a9ee5aa04aaa7c9720b1e3e13af27e20f489fa3ad4668ef5d4786176e47453192c4912e1".hexToBytes()
                    let rlpArray = try? rlpDecoder.decode(rawTx)
                    let tx = try! EthereumSignedTransaction(rlp: rlpArray!)

                    let rlp = RLPItem(
                        nonce: tx.nonce,
                        gasPrice: tx.gasPrice,
                        maxFeePerGas: tx.maxFeePerGas,
                        maxPriorityFeePerGas: tx.maxPriorityFeePerGas,
                        gasLimit: tx.gasLimit,
                        to: tx.to,
                        value: tx.value,
                        data: tx.data,
                        chainId: tx.chainId,
                        accessList: tx.accessList,
                        transactionType: tx.transactionType
                    )
                    let rawRlp = try RLPEncoder().encode(rlp)
                    var messageToSign = Bytes()
                    messageToSign.append(0x02)
                    messageToSign.append(contentsOf: rawRlp)

                    let from = try EthereumPublicKey(message: messageToSign, v: tx.v, r: tx.r, s: tx.s).address

                    expect(from.hex(eip55: true)) == "0x3d4CE0e38A3F4294df8AE65bC8A57b8eEc976203"
                }
            }
        }
    }
}
