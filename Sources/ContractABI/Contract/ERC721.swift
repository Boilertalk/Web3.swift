//
//  ERC721.swift
//  Web3
//
//  Created by Josh Pyles on 6/5/18.
//

import Foundation
import BigInt
#if !Web3CocoaPods
    import Web3
#endif

/// Base protocol for ERC721
public protocol ERC721Contract: ERC165Contract {
    
    static var Transfer: SolidityEvent { get }
    static var Approval: SolidityEvent { get }
    
    func balanceOf(address: EthereumAddress) -> SolidityInvocation
    func ownerOf(tokenId: BigUInt) -> SolidityInvocation
    func approve(to: EthereumAddress, tokenId: BigUInt) -> SolidityInvocation
    func getApproved(tokenId: BigUInt) -> SolidityInvocation
    func transferFrom(from: EthereumAddress, to: EthereumAddress, tokenId: BigUInt) -> SolidityInvocation
    func transfer(to: EthereumAddress, tokenId: BigUInt) -> SolidityInvocation
}

/// ERC721 Metadata Extension
public protocol AnnotatedERC721: EthereumContract {
    func name() -> SolidityInvocation
    func symbol() -> SolidityInvocation
    func tokenURI() -> SolidityInvocation
}

/// ERC721 Enumeration Extension
public protocol EnumeratedERC721: EthereumContract {
    func totalSupply() -> SolidityInvocation
    func tokenByIndex(index: BigUInt) -> SolidityInvocation
    func tokenOfOwnerByIndex(owner: EthereumAddress, index: BigUInt) -> SolidityInvocation
}

/// Generic implementation class. Use directly, or subclass to conveniently add your contract's events or methods.
open class GenericERC721Contract: StaticContract, ERC721Contract {
    public var address: EthereumAddress?
    public let eth: Web3.Eth
    
    open var constructor: SolidityConstructor?
    
    open var events: [SolidityEvent] {
        return [GenericERC721Contract.Transfer, GenericERC721Contract.Approval]
    }
    
    public required init(address: EthereumAddress?, eth: Web3.Eth) {
        self.address = address
        self.eth = eth
    }
}

// MARK: - Implementation of ERC721 standard methods and events

public extension ERC721Contract {

    static var Transfer: SolidityEvent {
        let inputs: [SolidityEvent.Parameter] = [
            SolidityEvent.Parameter(name: "_from", type: .address, indexed: true),
            SolidityEvent.Parameter(name: "_to", type: .address, indexed: true),
            SolidityEvent.Parameter(name: "_tokenId", type: .uint256, indexed: false)
        ]
        return SolidityEvent(name: "Transfer", anonymous: false, inputs: inputs)
    }
    
    static var Approval: SolidityEvent {
        let inputs: [SolidityEvent.Parameter] = [
            SolidityEvent.Parameter(name: "_owner", type: .address, indexed: true),
            SolidityEvent.Parameter(name: "_approved", type: .address, indexed: true),
            SolidityEvent.Parameter(name: "_tokenId", type: .uint256, indexed: false)
        ]
        return SolidityEvent(name: "Approval", anonymous: false, inputs: inputs)
    }
    
    func balanceOf(address: EthereumAddress) -> SolidityInvocation {
        let inputs = [SolidityFunctionParameter(name: "_owner", type: .address)]
        let outputs = [SolidityFunctionParameter(name: "_balance", type: .uint256)]
        let method = SolidityConstantFunction(name: "balanceOf", inputs: inputs, outputs: outputs, handler: self)
        return method.invoke(address)
    }
    
    func ownerOf(tokenId: BigUInt) -> SolidityInvocation {
        let inputs = [SolidityFunctionParameter(name: "_tokenId", type: .uint256)]
        let outputs = [SolidityFunctionParameter(name: "_owner", type: .address)]
        let method = SolidityConstantFunction(name: "ownerOf", inputs: inputs, outputs: outputs, handler: self)
        return method.invoke(tokenId)
    }
    
    func approve(to: EthereumAddress, tokenId: BigUInt) -> SolidityInvocation {
        let inputs = [
            SolidityFunctionParameter(name: "_to", type: .address),
            SolidityFunctionParameter(name: "_tokenId", type: .uint256)
        ]
        let method = SolidityNonPayableFunction(name: "approve", inputs: inputs, handler: self)
        return method.invoke(to, tokenId)
    }
    
    func getApproved(tokenId: BigUInt) -> SolidityInvocation {
        let inputs = [SolidityFunctionParameter(name: "_tokenId", type: .uint256)]
        let outputs = [SolidityFunctionParameter(name: "_approved", type: .address)]
        let method = SolidityConstantFunction(name: "getApproved", inputs: inputs, outputs: outputs, handler: self)
        return method.invoke(tokenId)
    }
    
    func transferFrom(from: EthereumAddress, to: EthereumAddress, tokenId: BigUInt) -> SolidityInvocation {
        let inputs = [
            SolidityFunctionParameter(name: "_from", type: .address),
            SolidityFunctionParameter(name: "_to", type: .address),
            SolidityFunctionParameter(name: "_tokenId", type: .uint256)
        ]
        let method = SolidityNonPayableFunction(name: "transferFrom", inputs: inputs, handler: self)
        return method.invoke(from, to, tokenId)
    }
    
    func transfer(to: EthereumAddress, tokenId: BigUInt) -> SolidityInvocation {
        let inputs = [
            SolidityFunctionParameter(name: "_to", type: .address),
            SolidityFunctionParameter(name: "_tokenId", type: .uint256)
        ]
        let method = SolidityNonPayableFunction(name: "transfer", inputs: inputs, handler: self)
        return method.invoke(to, tokenId)
    }
    
}

public extension AnnotatedERC721 {
    
    func name() -> SolidityInvocation {
        let outputs = [SolidityFunctionParameter(name: "_name", type: .string)]
        let method = SolidityConstantFunction(name: "name", outputs: outputs, handler: self)
        return method.invoke()
    }
    
    func symbol() -> SolidityInvocation {
        let outputs = [SolidityFunctionParameter(name: "_symbol", type: .string)]
        let method = SolidityConstantFunction(name: "symbol", outputs: outputs, handler: self)
        return method.invoke()
    }
    
    func tokenURI(tokenId: BigUInt) -> SolidityInvocation {
        let inputs = [SolidityFunctionParameter(name: "_tokenId", type: .uint256)]
        let outputs = [SolidityFunctionParameter(name: "_tokenURI", type: .string)]
        let method = SolidityConstantFunction(name: "tokenURI", inputs: inputs, outputs: outputs, handler: self)
        return method.invoke(tokenId)
    }
    
}

public extension EnumeratedERC721 {
    
    func totalSupply() -> SolidityInvocation {
        let outputs = [SolidityFunctionParameter(name: "_totalSupply", type: .uint256)]
        let method = SolidityConstantFunction(name: "totalSupply", outputs: outputs, handler: self)
        return method.invoke()
    }
    
    func tokenByIndex(index: BigUInt) -> SolidityInvocation {
        let inputs = [SolidityFunctionParameter(name: "_index", type: .uint256)]
        let outputs = [SolidityFunctionParameter(name: "_tokenId", type: .uint256)]
        let method = SolidityConstantFunction(name: "tokenByIndex", inputs: inputs, outputs: outputs, handler: self)
        return method.invoke(index)
    }
    
    func tokenOfOwnerByIndex(owner: EthereumAddress, index: BigUInt) -> SolidityInvocation {
        let inputs = [
            SolidityFunctionParameter(name: "_owner", type: .address),
            SolidityFunctionParameter(name: "_index", type: .uint256)
        ]
        let outputs = [SolidityFunctionParameter(name: "_tokenId", type: .uint256)]
        let method = SolidityConstantFunction(name: "tokenOfOwnerByIndex", inputs: inputs, outputs: outputs, handler: self)
        return method.invoke(owner, index)
    }
    
}
