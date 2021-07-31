#### Static Contracts



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
        from: myPrivateKey.address,
        value: 0,
        gas: 100000,
        gasPrice: EthereumQuantity(quantity: 21.gwei)
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
        from: myAddress,
        value: 0,
        gas: 150000,
        gasPrice: EthereumQuantity(quantity: 21.gwei)
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
guard let transaction = contract["transfer"]?(EthereumAddress.testAddress, BigUInt(100000)).createTransaction(nonce: 0, from: myPrivateKey.address, value: 0, gas: 150000, gasPrice: EthereumQuantity(quantity: 21.gwei)) else {
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