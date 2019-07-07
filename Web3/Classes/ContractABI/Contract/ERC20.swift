//
//  ERC20.swift
//  Web3
//
//  Created by Josh Pyles on 6/19/18.
//

import Foundation
import BigInt
#if !Web3CocoaPods
    import Web3
#endif

/// Base protocol for ERC20
public protocol ERC20Contract: EthereumContract {
    
    static var Transfer: SolidityEvent { get }
    static var Approval: SolidityEvent { get }
    
    func totalSupply() -> SolidityInvocation
    func balanceOf(address: EthereumAddress) -> SolidityInvocation
    func approve(spender: EthereumAddress, value: BigUInt) -> SolidityInvocation
    func allowance(owner: EthereumAddress, spender: EthereumAddress) -> SolidityInvocation
    func transferFrom(from: EthereumAddress, to: EthereumAddress, value: BigUInt) -> SolidityInvocation
    func transfer(to: EthereumAddress, value: BigUInt) -> SolidityInvocation
}

public protocol AnnotatedERC20: EthereumContract {
    func name() -> SolidityInvocation
    func symbol() -> SolidityInvocation
    func decimals() -> SolidityInvocation
}

/// Generic implementation class. Use directly, or subclass to conveniently add your contract's events or methods.
open class GenericERC20Contract: StaticContract, ERC20Contract, AnnotatedERC20 {
    public var address: EthereumAddress?
    public let eth: Web3.Eth
    
    open var constructor: SolidityConstructor?
    
    open var events: [SolidityEvent] {
        return [GenericERC20Contract.Transfer, GenericERC20Contract.Approval]
    }
    
    public required init(address: EthereumAddress?, eth: Web3.Eth) {
        self.address = address
        self.eth = eth
    }
}

// MARK: - Implementation of ERC721 standard methods and events

public extension ERC20Contract {
    
    static var Transfer: SolidityEvent {
        let inputs: [SolidityEvent.Parameter] = [
            SolidityEvent.Parameter(name: "_from", type: .address, indexed: true),
            SolidityEvent.Parameter(name: "_to", type: .address, indexed: true),
            SolidityEvent.Parameter(name: "_value", type: .uint256, indexed: false)
        ]
        return SolidityEvent(name: "Transfer", anonymous: false, inputs: inputs)
    }
    
    static var Approval: SolidityEvent {
        let inputs: [SolidityEvent.Parameter] = [
            SolidityEvent.Parameter(name: "_owner", type: .address, indexed: true),
            SolidityEvent.Parameter(name: "_spender", type: .address, indexed: true),
            SolidityEvent.Parameter(name: "_value", type: .uint256, indexed: false)
        ]
        return SolidityEvent(name: "Approval", anonymous: false, inputs: inputs)
    }
    
    func totalSupply() -> SolidityInvocation {
        let outputs = [SolidityFunctionParameter(name: "_totalSupply", type: .uint256)]
        let method = SolidityConstantFunction(name: "totalSupply", outputs: outputs, handler: self)
        return method.invoke()
    }
    
    func balanceOf(address: EthereumAddress) -> SolidityInvocation {
        let inputs = [SolidityFunctionParameter(name: "_owner", type: .address)]
        let outputs = [SolidityFunctionParameter(name: "_balance", type: .uint256)]
        let method = SolidityConstantFunction(name: "balanceOf", inputs: inputs, outputs: outputs, handler: self)
        return method.invoke(address)
    }
    
    func approve(spender: EthereumAddress, value: BigUInt) -> SolidityInvocation {
        let inputs = [
            SolidityFunctionParameter(name: "_spender", type: .address),
            SolidityFunctionParameter(name: "_value", type: .uint256)
        ]
        let method = SolidityNonPayableFunction(name: "approve", inputs: inputs, handler: self)
        return method.invoke(spender, value)
    }
    
    func allowance(owner: EthereumAddress, spender: EthereumAddress) -> SolidityInvocation {
        let inputs = [
            SolidityFunctionParameter(name: "_owner", type: .address),
            SolidityFunctionParameter(name: "_spender", type: .address)
        ]
        let outputs = [
            SolidityFunctionParameter(name: "_remaining", type: .uint256)
        ]
        let method = SolidityConstantFunction(name: "allowance", inputs: inputs, outputs: outputs, handler: self)
        return method.invoke(owner, spender)
    }
    
    func transferFrom(from: EthereumAddress, to: EthereumAddress, value: BigUInt) -> SolidityInvocation {
        let inputs = [
            SolidityFunctionParameter(name: "_from", type: .address),
            SolidityFunctionParameter(name: "_to", type: .address),
            SolidityFunctionParameter(name: "_value", type: .uint256)
        ]
        let method = SolidityNonPayableFunction(name: "transferFrom", inputs: inputs, handler: self)
        return method.invoke(from, to, value)
    }
    
    func transfer(to: EthereumAddress, value: BigUInt) -> SolidityInvocation {
        let inputs = [
            SolidityFunctionParameter(name: "_to", type: .address),
            SolidityFunctionParameter(name: "_value", type: .uint256)
        ]
        let method = SolidityNonPayableFunction(name: "transfer", inputs: inputs, handler: self)
        return method.invoke(to, value)
    }
}

// MARK: - Implementation of ERC20 Metadata

public extension AnnotatedERC20 {
    
    func name() -> SolidityInvocation {
        let outputs = [
            SolidityFunctionParameter(name: "_name", type: .string)
        ]
        let method = SolidityConstantFunction(name: "name", inputs: [], outputs: outputs, handler: self)
        return method.invoke()
    }
    
    func symbol() -> SolidityInvocation {
        let outputs = [
            SolidityFunctionParameter(name: "_symbol", type: .string)
        ]
        let method = SolidityConstantFunction(name: "symbol", inputs: [], outputs: outputs, handler: self)
        return method.invoke()
    }
    
    func decimals() -> SolidityInvocation {
        let outputs = [
            SolidityFunctionParameter(name: "_decimals", type: .uint8)
        ]
        let method = SolidityConstantFunction(name: "decimals", inputs: [], outputs: outputs, handler: self)
        return method.invoke()
    }
}


