# W3Connect

W3Connect is a Swift library for interacting with the blockchain & smart contract ecosystem using the Web3 interface. By connecting to a network or node, you can to compose, send transactions and read values from smart contracts without the need of writing your own implementations of the protocols. 

W3Connect aims to make it as simple and easy to follow and understand. The class structure follows the same pattern as the [official Web3 library](https://web3js.readthedocs.io) but renames and organizes the classes, variables, and methods for ease of use, efficiency, and understanding. 



W3Connect supports all networks that are compatible with the `Ethereum web3.js` [library](https://web3js.readthedocs.io). 


* [Ethereum (ETH)](https://ethereum.org) 
* [Binance Smart-Chain (BSC)](https://www.binance.org/en/smartChain)



## Usage


To use the library, add `import W3Connect` in your swift files.

```swift
import W3Connect
```

Define a new connection with a `Provider`:

```swift
let w3 = Blockchain(connectTo: "https://mainnet.infura.io/<your_infura_id>")
```

#### Interaction with an Blockchain node
With `W3Connect` you can use a local or remote node as the `Provider` to communicate with the blockchain network allowing for  fetching address balances, signing of transactions, reading contracts and calling of contracts and their respective functions.

All standard Web3 `web3_` methods are accessible using the base `Blockchain` struct. 

```swift
struct Blockchain {
	let network: Network
	let node: Node
	...
}
```

<span></span>
> `Network`: Provides information about the current connected network and related data. *Renamed from `net_`.*

<span></span>
> `Node`: Allows for interacting with the blockchain and it's smart contracts. *Renamed from `eth_`.*



## Send Raw Transaction

Creates new message call transaction or a contract creation for signed transactions.

**Parameters**

1. `Transaction`: The signed transaction

**Returns**

`NetworkData`, 32 Bytes - The transaction hash, or the zero hash if the transaction is not yet available

To send some ETH you first need to get the current transaction count of the sender (nonce),
create the transaction, sign it and then send it.

```swift
let privateKey = try! EthereumPrivateKey(hexPrivateKey: "0xa26da69ed1df3ba4bb2a231d506b711eace012f1bd2571dfbfff9650b03375af")
firstly {
    web3.eth.getTransactionCount(address: privateKey.address, block: .latest)
}.then { nonce in
    let tx = try EthereumTransaction(
        nonce: nonce,
        gasPrice: EthereumQuantity(quantity: 21.gwei),
        gas: 21000,
        to: EthereumAddress(hex: "0xC0866A1a0ed41e1aa75c932cA3c55fad847fd90D", eip55: true),
        value: EthereumQuantity(quantity: 1.eth)
    )
    return try tx.sign(with: privateKey, chainId: 1).promise
}.then { tx in
    web3.eth.sendRawTransaction(transaction: tx)
}.done { hash in
    print(hash)
}.catch { error in
    print(error)
}
```

#### Request block transaction count by block number

```swift
firstly {
    web3.eth.getBlockTransactionCountByNumber(block: .block(5397389))
}.done { count in
    print(count) // 88
}.catch { error in
    print(error)
}
```


## Contract ABI

<span></span>
> <p style="color: #444444; font-weight: 600; font-size: 14px; margin-bottom: -18px;">StaticContract</p>
<span style="font-size:12px">A protocol that provides predefined functions and events to interact with the contract</span>
> 
> - `ERC20Contract`: <span style="color: #a9a9a9; font-size:12px">*ERC-20 Standard for Tokens*</span>
> - `ERC721Contract`: <span style="color: #a9a9a9; font-size:12px">*ERC-721 Standard for NFT*</span>

<span></span>
> <p style="color: #444444; font-weight: 600; font-size: 14px; margin-bottom: -15px;">DynamicContract</p>
> A parsed JSON-RPC object representation that dynamically generates a contract at run-time.



There are several options to create contract abi interfaces: 

* Use the generic [ERC20](Web3/Classes/ContractABI/Contract/ERC20.swift) or [ERC721](Web3/Classes/ContractABI/Contract/ERC721.swift) static `Contract` 
* Creating your own `Contract` interface to make contract calls
* Parse the JSON ABI representation of the dynamic `Contract`, just like in web3.js

By creating your own interfaces, you can interact with *any* smart contract! 

> [Static & Dynamic Contract Examples](Contract.md)

## Installation

### Swift Package Manager
To add W3Connect to a [Swift Package Manager](https://swift.org/package-manager/) based project, add the following to your `Package.swift` files `dependencies` array.

```swift
.package(name: "W3Connect", url: "https://github.com/rkohl/W3Connect", .upToNextMajor(from: "1.1.0")),
```


## Contributors
* [Boilertalk/Web3.swift](https://github.com/Boilertalk/Web3.swift)


## License

W3Connect is available under the MIT license. See the LICENSE file for more info.
