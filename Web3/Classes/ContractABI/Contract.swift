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

public protocol Contract {

    var contractDescriptionElements: [ContractDescriptionElement] { get }
}

public enum ContractCallError: Error {

    case functionMissing
    case inputsMalformed
}

public extension Contract {

    public func createCall(name: String, inputs: [BytesRepresentable]) throws -> EthereumCall {
        guard let description = contractDescriptionElements.findFunctionDescription(with: name) else {
            throw ContractCallError.functionMissing
        }
        guard description.inputs.count == inputs.count else {
            throw ContractCallError.inputsMalformed
        }
    }
}

/*
private extension Array where Element == Byte {

    private func abiEnc(for parameter: ContractFunctionDescription.FunctionParameter) throws -> Bytes {
        switch parameter.type {
        case .tuple:

        }
    }

    private func abiTupleHead()
}
*/
