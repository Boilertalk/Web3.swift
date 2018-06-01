//
//  Contract.swift
//  Web3
//
//  Created by Koray Koska on 30.05.18.
//

import Foundation
#if !Web3CocoaPods
import Web3
#endif
import CryptoSwift

public protocol Contract {

    // var contractDescriptionElements: [ContractDescriptionElement] { get }
}

public enum ContractCallError: Error {

    case functionMissing
    case inputsMalformed
    case internalError
}

public extension Contract {

    /*
    public func createTransactionData(name: String, inputs: [ContractTypeConvertible]) throws -> EthereumData {
        guard let description = contractDescriptionElements.findFunctionDescription(with: name) else {
            throw ContractCallError.functionMissing
        }
        guard description.inputs.count == inputs.count else {
            throw ContractCallError.inputsMalformed
        }

        var newInputs: [(parameter: ContractFunctionDescription.FunctionParameter, data: ContractTypeConvertible)] = []
        for i in 0..<inputs.count {
            newInputs.append((parameter: description.inputs[i], data: inputs[i]))
        }
        return createTransactionData(name: name, inputs: newInputs)
    }*/

    public func createTransactionData(name: String, inputs: [ContractTypeConvertible]) -> EthereumData {
        let parameter = ContractFunctionDescription.FunctionParameter(name: "functionParameters", type: .tuple, components: inputs.map { $0.parameterType })

        let signature = "\(name)\(parameter.signatureTypeString)"
        let selector = SHA3(variant: .keccak256).functionSelector(for: signature.data(using: .utf8)?.makeBytes() ?? [])

        let encoding = ContractTypeTuple(types: inputs).encoding()

        var data = selector
        data.append(contentsOf: encoding)

        return EthereumData(bytes: data)
    }
}

private extension SHA3 {

    func functionSelector(for bytes: Bytes) -> Bytes {
        let hash = calculate(for: bytes)
        var selector = Bytes(repeating: 0, count: 4)
        for i in 0..<4 {
            if hash.count > i {
                selector[i] = hash[i]
            }
        }

        return selector
    }
}
