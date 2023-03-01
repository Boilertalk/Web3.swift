<p align="center">
  <a href="https://github.com/Boilertalk/Web3.swift">
    <img src="https://crypto-bot-main.fra1.digitaloceanspaces.com/old/web3-swift-logo.png" width="256" height="256">
  </a>
</p>

<p align="center">
  <a href="https://github.com/Boilertalk/Web3.swift/actions/workflows/build-and-test.yml">
    <img src="https://github.com/Boilertalk/Web3.swift/actions/workflows/build-and-test.yml/badge.svg?branch=master" alt="CI Status">
  </a>
  <a href="https://codecov.io/gh/Boilertalk/Web3.swift">
    <img src="https://codecov.io/gh/Boilertalk/Web3.swift/branch/master/graph/badge.svg" alt="Code Coverage">
  </a>
  <a href="https://t.me/web3_swift">
    <img src="https://img.shields.io/badge/chat-on%20telegram-blue.svg?longCache=true&style=flat" alt="Telegram">
  </a>
</p>

# :chains: Web3

Web3.swift is a Swift library for signing transactions and interacting with Smart Contracts in the Ethereum Network.

It allows you to connect to a [geth](https://github.com/ethereum/go-ethereum) or [erigon](https://github.com/ledgerwatch/erigon)
Ethereum node (like [Chainnodes](https://www.chainnodes.org/)) to send transactions and read values from Smart Contracts without the need of
writing your own implementations of the protocols.

Web3.swift supports iOS, macOS, tvOS, watchOS and Linux with Swift Package Manager.

## Example

Check the usage below or look through the repositories tests.

## Why?

There are already some Web3 library out there written in Swift. We know their strengths and weaknesses and for our use case
they just didn't work.

`Web3.swift` was built with modularity, portability, speed and efficiency in mind.

**Ok, thank you for the buzzwords. But what does this actually mean?**

### :floppy_disk: Modularity

`Web3.swift` was built to be modular. If you install/use the basic `Web3` SPM product, you get access to the most basic
functions like transaction signing and interacting with an http rpc server.    
If you want to add support for IPC rpc or something else, you can simple create a library which depends on `Web3` and implements
this exact functionality. More about that later.    
If you want to use [PromiseKit](https://github.com/mxcl/PromiseKit) extensions for the web3 calls, you can either use the
provided PromiseKit SPM product or create your own.    
If you want to conveniently parse JSON ABIs for Ethereum Smart Contracts, you can use the provided ABI Parsing SPM product.

Finally, if you want to add functionality to `Web3.swift` which is not provided yet, you don't have to wait until it gets merged
and released in a version bump. You can simple extend/update functionality within you own app as our APIs are made to be very open
for changes.    
For example, if you want to add a web3 method which is not provided yet by `Web3.swift` (we will only support Infura supported methods),
you only have to add [some 3 lines of code](https://github.com/Boilertalk/Web3.swift/blob/master/Sources/Core/Web3/Web3.swift#L132)
(depending on the input and output parameters of the method). Adding IPC rpc support would be only implementing a protocol and answering
requests.

Like you can see, everything is possible with `Web3.swift`.

### :computer: Portability

One of the main reasons we started working on this project is because we wanted to use it with Swift Package Manager on
different platforms.    
Because of that, `Web3.swift` is available through [Swift Package Manager](https://swift.org/package-manager/) on iOS, macOS, tvOS, watchOS and Linux.    
> Note: For SPM we are only testing iOS, macOS and officially supported Linux distributions
(currently Ubuntu 16.04 and 20.04) but it should be compatible with all little endian systems
which are able to compile the Swift Compiler, Foundation and Glibc.

### :zap: Speed and Efficiency

We try to make this library as fast as possible while trying to provide an API which increases your development
workflow such that you can focus on building great DAPPS instead of worrying about implementation details.

All our APIs are thread safe and designed to be used in highly concurrent applications.

## Installation

### Swift Package Manager

Web3 is compatible with Swift Package Manager v5 (Swift 5 and above). Simply add it to the dependencies in your `Package.swift`.

```Swift
dependencies: [
    .package(url: "https://github.com/Boilertalk/Web3.swift.git", from: "0.6.0")
]
```

And then add it to your target dependencies:

```Swift
targets: [
    .target(
        name: "MyProject",
        dependencies: [
            .product(name: "Web3", package: "Web3.swift"),
            .product(name: "Web3PromiseKit", package: "Web3.swift"),
            .product(name: "Web3ContractABI", package: "Web3.swift"),
        ]
    ),
    .testTarget(
        name: "MyProjectTests",
        dependencies: ["MyProject"])
]
```

> Note: `Web3PromiseKit` and `Web3ContractABI` are optional and you only have to put them into
your target dependencies (and later import them) if you want to use them.

After the installation you can import `Web3` in your `.swift` files.

```Swift
import Web3

// Optional
import Web3PromiseKit
import Web3ContractABI
```

### CocoaPods and Carthage

Because of an internal decision, we stopped supporting any Package Managers other than SPM starting with version 0.5.0.

To elaborate a little on this decision: With XCode 11 and Swift 5.1 we reached a point with Swift Package Manager where it
slowly started making other package managers irrelevant. You could already load all your dependencies in the XCode project
with Swift Package Manager.    
With more updates it became even more prevalent. Cocoapods and Carthage maintainers lost interest in their project and
stopped maintaining it. There are many unresolved issues, many problems especially for library developers with Cocoapods.

So much hassle for no real gain. Users can already put dependencies which support SPM into their XCode project. So why bother?

The answer is simple. Some still use XCode < 11 and some library developers depend on Web3 in their own Pods/Carthages.

The decision was hard and took some time. But after seeing that the last version was very stable and used in many
production apps already, we decided to start with this move now.    
XCode 10 is already more than 2 years old. Most projects already upgraded, the ones that didn't have a much bigger
problem than Web3.swift not making Updates for Cocoapods...    
Library owners depending on Web3.swift are encouraged to drop Cocoapods and Carthage Support as well.

SPM is the Future. For all Cocoapods and Carthage Users who use it because many libraries did not switch to SPM yet:
You can still add Web3.swift as a SPM product into your `.xcworkspace` or `.xcodeproj` and keep all your other
dependencies inside Cocoapods/Carthage. But still. We encourage you to switch with as many dependencies as possible
to SPM. Better sooner than later. See the next section on how to do this.

### XCode

Using XCode 11 or later (for iOS, macOS or other Apple platforms) you can add SPM packages very easy.

In Xcode, select your project, from the Dropdown select the project, not a single Target, in the Tabs select `Swift Packages`.    
Then you can click the + icon and put in the URL to this repository (https://github.com/Boilertalk/Web3.swift).    
Now you can select all products and just click Next until the dependency was added.

That's it. If you push your changes even your CI will not make any problems. No hassles with outdated spec repositories,
no problems with some weird linker errors which only occur sometimes/with some dependencies.

If you need further guidance, join our [Telegram group](https://t.me/web3_swift) and we will help you. https://t.me/web3_swift

## Usage

### Interaction with an Ethereum node

With `Web3.swift` you can use an Ethereum node on a server to communicate with Ethereum.    
You can send signed transactions, read contract data, call contract functions and much more.

The base class for all available methods is `Web3`. You can, for example, instantiate it with
an http provider:

```Swift
let web3 = Web3(rpcURL: "https://mainnet.infura.io/<your_infura_id>")
```

All `web3_` methods are available directly from the `Web3` struct. The `net_` methods are
available under the `net` struct in the `web3` struct. The `eth_` methods are available
under the `eth` struct in the `web3` struct.

__*Please see the examples below*__

> Note: For the examples to work you need to import Web3 and PromiseKit first

#### Request web3_clientVersion

Returns the current client version.

**Parameters**

none

**Returns**

`String` - The current client version

```Swift
firstly {
    web3.clientVersion()
}.done { version in
    print(version)
}.catch { error in
    print("Error")
}
```

#### Request net_version

Returns the current network id.

**Parameters**

none

**Returns**

`String` - The current network id

```Swift
firstly {
    web3.net.version()
}.done { version in
    print(version)
}.catch { error in
    print("Error")
}
```

#### Request net_PeerCount

Returns number of peers currently connected to the client.

**Parameters**

none

**Returns**

`EthereumQuantity` - BigInt of the number of connected peers.

```Swift
firstly {
    web3.net.peerCount()
}.done { ethereumQuantity in
    print(ethereumQuantity.quantity)
}.catch { error in
    print("Error")
}
```

#### Send raw transaction

Creates new message call transaction or a contract creation for signed transactions.

**Parameters**

1. `EthereumTransaction`: The signed transaction

**Returns**

`EthereumData`, 32 Bytes - The transaction hash, or the zero hash if the transaction is not yet available

To send some ETH you first need to get the current transaction count of the sender (nonce),
create the transaction, sign it and then send it.

```Swift
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

```Swift
firstly {
    web3.eth.getBlockTransactionCountByNumber(block: .block(5397389))
}.done { count in
    print(count) // 88
}.catch { error in
    print(error)
}
```

#### More examples

For more examples either read through [our test cases](https://github.com/Boilertalk/Web3.swift/blob/master/Tests/Web3Tests/Web3Tests/Web3HttpTests.swift),
[the Web3 struct](https://github.com/Boilertalk/Web3.swift/blob/master/Sources/Core/Web3/Web3.swift)
or [the official Ethereum JSON RPC documentation](https://eth.wiki/json-rpc/API).

### Contract ABI interaction

We are providing an optional module for interaction with smart contracts. To use it you have to add `Web3ContractABI` to your target dependencies in your Podfile (for SPM). Make sure you check out the [installation instructions](#Installation) first.

We are providing two different options to create contract abi interfaces in Swift. Either you define your functions and events manually (or use one of our provided interfaces like [ERC20](Web3/Sources/ContractABI/Contract/ERC20.swift) or [ERC721](Web3/Sources/ContractABI/Contract/ERC721.swift)). Or you parse them from the JSON ABI representation just like in web3.js.

### Static Contracts

Static contracts are classes implementing `StaticContract`. They provide a set of functions and events they want to use from the original smart contract. Check out our provided static contracts as a starting point ([ERC20](Web3/Sources/ContractABI/Contract/ERC20.swift) or [ERC721](Web3/Sources/ContractABI/Contract/ERC721.swift)).

Our static ERC20 interface is called `GenericERC20Contract`, the ERC721 contract is called `GenericERC721Contract`. Both can be subclassed to add more functions for custom contracts.

With those `StaticContract` types you can create and use your contract like in the following example (We are using PromiseKit again in our examples).

```Swift
let web3 = Web3(rpcURL: "https://mainnet.infura.io/<your_infura_id>")

let contractAddress = try EthereumAddress(hex: "0x86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0", eip55: true)
let contract = web3.eth.Contract(type: GenericERC20Contract.self, address: contractAddress)

// Get balance of some address
firstly {
    try contract.balanceOf(address: EthereumAddress(hex: "0x3edB3b95DDe29580FFC04b46A68a31dD46106a4a", eip55: true)).call()
}.done { outputs in
    print(outputs["_balance"] as? BigUInt)
}.catch { error in
    print(error)
}

// Send some tokens to another address (locally signing the transaction)
let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: "...")
firstly {
    web3.eth.getTransactionCount(address: myPrivateKey.address, block: .latest)
}.then { nonce in
    try contract.transfer(to: EthereumAddress(hex: "0x3edB3b95DDe29580FFC04b46A68a31dD46106a4a", eip55: true), value: 100000).createTransaction(        
        nonce: nonce,
        gasPrice: EthereumQuantity(quantity: 21.gwei),
        maxFeePerGas: nil,
        maxPriorityFeePerGas: nil,
        gasLimit: 100000,
        from: myPrivateKey.address,
        value: 0,
        accessList: [:],
        transactionType: .legacy
    )!.sign(with: myPrivateKey).promise
}.then { tx in
    web3.eth.sendRawTransaction(transaction: tx)
}.done { txHash in
    print(txHash)
}.catch { error in
    print(error)
}

// Send some tokens to another address (signing will be done by the node)
let myAddress = try EthereumAddress(hex: "0x1f04ef7263804fafb839f0d04e2b5a6a1a57dc60", eip55: true)
firstly {
    web3.eth.getTransactionCount(address: myAddress, block: .latest)
}.then { nonce in
    try contract.transfer(to: EthereumAddress(hex: "0x3edB3b95DDe29580FFC04b46A68a31dD46106a4a", eip55: true), value: 100000).send(        
        nonce: nonce,
        gasPrice: EthereumQuantity(quantity: 21.gwei),
        maxFeePerGas: nil,
        maxPriorityFeePerGas: nil,
        gasLimit: 150000,
        from: myAddress,
        value: 0,
        accessList: [:],
        transactionType: .legacy
    )
}.done { txHash in
    print(txHash)
}.catch { error in
    print(error)
}
```

By creating your own interfaces, you can interact with any smart contract!

### Dynamic Contracts

If you only have access to the JSON ABI of a smart contract or you don't want to create a static template, you can use our dynamic contract api to parse the json string into a usable contract *during runtime*. See the example below.

```Swift
let web3 = Web3(rpcURL: "https://mainnet.infura.io/<your_infura_id>")

let contractAddress = try EthereumAddress(hex: "0x86fa049857e0209aa7d9e616f7eb3b3b78ecfdb0", eip55: true)
let contractJsonABI = "<your contract ABI as a JSON string>".data(using: .utf8)!
// You can optionally pass an abiKey param if the actual abi is nested and not the top level element of the json
let contract = try web3.eth.Contract(json: contractJsonABI, abiKey: nil, address: contractAddress)

print(contract.methods.count)

// Get balance of some address
firstly {
    try contract["balanceOf"]!(EthereumAddress(hex: "0x3edB3b95DDe29580FFC04b46A68a31dD46106a4a", eip55: true)).call()
}.done { outputs in
    print(outputs["_balance"] as? BigUInt)
}.catch { error in
    print(error)
}

// Send some tokens to another address (locally signing the transaction)
let myPrivateKey = try EthereumPrivateKey(hexPrivateKey: "...")
guard let transaction = contract["transfer"]?(EthereumAddress.testAddress, BigUInt(100000)).createTransaction(
    nonce: 0,
    gasPrice: EthereumQuantity(quantity: 21.gwei),
    maxFeePerGas: nil,
    maxPriorityFeePerGas: nil,
    gasLimit: 150000,
    from: myPrivateKey.address,
    value: 0,
    accessList: [:],
    transactionType: .legacy
)) else {
    return
}
let signedTx = try transaction.sign(with: myPrivateKey)

firstly {
    web3.eth.sendRawTransaction(transaction: signedTx)
}.done { txHash in
    print(txHash)
}.catch { error in
    print(error)
}
```

Using this API you can interact with any smart contract in the Ethereum Network!

For more examples, including contract creation (constructor calling) check out our [tests](Tests/Web3Tests/ContractTests).

## Common errors

### Couldn't parse ABI Object

If you are getting this error when parsing your ABI from a json, it may be because your contract has a fallback function. To solve it, remove the fragment of your ABI that has the information about the fallback function. The part you should remove might look like this:

```
{
    "payable": false,
    "stateMutability": "nonpayable",
    "type": "fallback"
},
```

## Disclaimer

Until we reach version 1.0.0 our API is subject to breaking changes between minor version jumps.
This is to make sure we can focus on providing the best implementation while we are in heavy development
instead of trying to maintain something which is deprecated.

That being said, we will try to minimize breaking changes. Most certainly there won't be many.

## Author

The awesome guys at Boilertalk :alembic:    
...and even more awesome members from the community :purple_heart:

Check out the [contributors list](https://github.com/Boilertalk/Web3.swift/graphs/contributors) for a complete list.

## License

Web3 is available under the MIT license. See the LICENSE file for more info.
