import Foundation

public struct EthereumUtils {

    enum Error: Swift.Error {
        case saltNot32BytesError
        case initCodeHashNot32BytesError
    }

    public static func getCreate2Address(from: EthereumAddress, salt: [UInt8], initCodeHash: [UInt8]) throws -> EthereumAddress {
        if salt.count != 32 {
            throw Error.saltNot32BytesError
        }
        if initCodeHash.count != 32 {
            throw Error.initCodeHashNot32BytesError
        }

        var concat: [UInt8] = [0xff]
        concat.append(contentsOf: from.rawAddress)
        concat.append(contentsOf: salt)
        concat.append(contentsOf: initCodeHash)

        let hash = concat.sha3(.keccak256)
        let hexSlice = Array(hash[12...])

        return try EthereumAddress(hex: hexSlice.toHexString(), eip55: false)
    }

    public static func getCreate2Address(from: EthereumAddress, salt: [UInt8], initCode: [UInt8]) throws -> EthereumAddress {
        let initCodeHash = initCode.sha3(.keccak256)
        return try getCreate2Address(from: from, salt: salt, initCodeHash: initCodeHash)
    }
}
