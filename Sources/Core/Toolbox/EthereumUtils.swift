
import Foundation

enum getCreateAddressError: Error {
case saltNot32BytesError
case initCodeHashNot32BytesError
}

public struct EthereumUtils {
    
    public static func getCreate2Address(from: String, salt: [UInt8], initCodeHash: [UInt8]) throws -> String {
        if salt.count != 32 {
            throw getCreateAddressError.saltNot32BytesError
        }
        if initCodeHash.count != 32 {
            throw getCreateAddressError.initCodeHashNot32BytesError
        }
        
        var concat: [UInt8] = [0xff]
        concat.append(contentsOf: try EthereumAddress(hex: from, eip55: false).rawAddress)
        concat.append(contentsOf: salt)
        concat.append(contentsOf: initCodeHash)
        
        let hash = concat.sha3(.keccak256)
        let hexSlice = Array(hash[12...])
        
        return try EthereumAddress(hex: hexSlice.toHexString(), eip55: false).hex(eip55: true)
    }
    
}
