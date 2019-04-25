//
//  EthereumTransaction+Keychain.swift
//  Web3
//
//  Created by Yehor Popovych on 4/25/19.
//

import Foundation
import BigInt

#if !Web3CocoaPods
    import Web3
#endif

public extension EthereumTransaction {
    // MARK: - Convenient functions
    
    /**
     * Signs this transaction with the given private key and returns an instance of `EthereumSignedTransaction`
     *
     * - parameter privateKey: The private key for the new signature.
     * - parameter chainId: Optional chainId as described in EIP155.
     */
    func sign(with privateKey: EthereumPrivateKey, chainId: EthereumQuantity = 0) throws -> EthereumSignedTransaction {
        guard let nonce = nonce, let gasPrice = gasPrice, let gasLimit = gas, let value = value else {
            throw EthereumSignedTransaction.Error.transactionInvalid
        }
        
        let rlp = try self.rlp(chainId: chainId)
        let rawRlp = try RLPEncoder().encode(rlp)
        let signature = try privateKey.sign(message: rawRlp)
        
        let v: BigUInt
        if chainId.quantity == 0 {
            v = BigUInt(signature.v) + BigUInt(27)
        } else {
            let sigV = BigUInt(signature.v)
            let big27 = BigUInt(27)
            let chainIdCalc = (chainId.quantity * BigUInt(2) + BigUInt(8))
            v = sigV + big27 + chainIdCalc
        }
        
        let r = BigUInt(bytes: signature.r)
        let s = BigUInt(bytes: signature.s)
        
        return EthereumSignedTransaction(
            nonce: nonce,
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            to: to,
            value: value,
            data: data,
            v: EthereumQuantity(quantity: v),
            r: EthereumQuantity(quantity: r),
            s: EthereumQuantity(quantity: s),
            chainId: chainId
        )
    }
}

public extension EthereumSignedTransaction {
    
    // MARK: - Convenient functions
    
    func verifySignature() -> Bool {
        let recId: BigUInt
        if v.quantity >= BigUInt(35) + (BigUInt(2) * chainId.quantity) {
            recId = v.quantity - BigUInt(35) - (BigUInt(2) * chainId.quantity)
        } else {
            if v.quantity >= 27 {
                recId = v.quantity - 27
            } else {
                recId = v.quantity
            }
        }
        let rlp = RLPItem(
            nonce: nonce,
            gasPrice: gasPrice,
            gasLimit: gasLimit,
            to: to,
            value: value,
            data: data,
            v: chainId,
            r: 0,
            s: 0
        )
        if let _ = try? EthereumPublicKey(message: RLPEncoder().encode(rlp), v: EthereumQuantity(quantity: recId), r: r, s: s) {
            return true
        }
        
        return false
    }
}
