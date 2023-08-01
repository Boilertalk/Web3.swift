<a href="https://github.com/Boilertalk/Web3.swift">
  <img src="https://storage.googleapis.com/boilertalk/logo.svg" width="100%" height="256">
</a>

<p align="center">
  <a href="https://travis-ci.org/Boilertalk/Web3.swift">
    <img src="http://img.shields.io/travis/Boilertalk/Web3.swift.svg?style=flat" alt="CI Status">
  </a>
  <a href="http://cocoapods.org/pods/Web3">
    <img src="https://img.shields.io/cocoapods/v/Web3.svg?style=flat" alt="Version">
  </a>
  <a href="http://cocoapods.org/pods/Web3">
    <img src="https://img.shields.io/cocoapods/l/Web3.svg?style=flat" alt="License">
  </a>
  <a href="http://cocoapods.org/pods/Web3">
    <img src="https://img.shields.io/cocoapods/p/Web3.svg?style=flat" alt="Platform">
  </a>
  <a href="https://github.com/Carthage/Carthage">
    <img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage compatible">
  </a>
  <a href="https://codecov.io/gh/Boilertalk/Web3.swift">
    <img src="https://codecov.io/gh/Boilertalk/Web3.swift/branch/master/graph/badge.svg" alt="Code Coverage">
  </a>
</p>

# :alembic: Web3

Web3.swift is a Swift library for signing transactions and interacting with Smart Contracts in the Ethereum Network.

It allows you to connect to a [geth](https://github.com/ethereum/go-ethereum) or [parity](https://github.com/paritytech/parity)
Ethereum node (like [Infura](https://infura.io/)) to send transactions and read values from Smart Contracts without the need of
writing your own implementations of the protocols.

Web3.swift supports iOS, macOS, tvOS and watchOS with CocoaPods and Carthage and macOS and Linux with Swift Package Manager.

## Example

Check the usage below or look through the repositories tests.

## Why?

There are already some Web3 library out there written in Swift. We know their strengths and weaknesses and for our use case
it they just didn't work.

`Web3.swift` was built with modularity, portability, speed and efficiency in mind.

**Ok, thank you for the buzzwords. But what does this actually mean?**

### :floppy_disk: Modularity

`Web3.swift` was built to be modular. If you install/use the basic `Web3` subspec/SPM product, you get access to the most basic
functions like transaction signing and interacting with an http rpc server.    
If you want to add support for IPC rpc or something else, you can simple create a library which depends on `Web3` and implements
this exact functionality. More about that later.    
If you want to use [PromiseKit](https://github.com/mxcl/PromiseKit) extensions for the web3 calls, you can either use the
provided PromiseKit subspec/SPM product or create your own.    
If you want to conveniently parse JSON ABIs for Ethereum Smart Contracts, you can use the provided ABI Parsing subspec/SPM product
which will be released in version 0.2.0.

Finally, if you want to add functionality to `Web3.swift` which is not provided yet, you don't have to wait until it gets merged
and released in a version bump. You can simple extend/update functionality within you own app as our APIs are made to be very open
for changes.    
For example, if you want to add a web3 method which is not provided yet by `Web3.swift` (we will only support Infura supported methods),
you only have to add [some 3 lines of code](https://github.com/Boilertalk/Web3.swift/blob/master/Web3/Classes/Core/Web3/Web3.swift#L136)
(depending on the input and output parameters of the method). Adding IPC rpc support would be only implementing a protocol and answering
requests.

Like you can see, everything is possible with `Web3.swift`.

### :computer: Portability

One of the main reasons we started working on this project is because we wanted to use it with CocoaPods and Swift Package Manager on
different platforms.    
Because of that, `Web3.swift` is available through [CocoaPods](https://cocoapods.org/), [Carthage](https://github.com/Carthage/Carthage)
and [Swift Package Manager](https://swift.org/package-manager/) on iOS, macOS, tvOS, watchOS (with CocoaPods and Carthage)
and macOS and Linux (with SPM).    
> Note: For SPM we are only testing macOS and officially supported Linux distributions
(currently Ubuntu 14.04 and 16.04) but it should be compatible with all little endian systems
which are able to compile the Swift Compiler, Foundation and Glibc.

### :zap: Speed and Efficiency

We try to make this library as fast as possible while trying to provide an API which increases your development
workflow such that you can focus on building great DAPPS instead of worrying about implementation details.

All our APIs are thread safe and designed to be used in highly concurrent applications

## Installation

### CocoaPods

Web3 is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your `Podfile`:

```ruby
pod 'Web3'
```

### Carthage

Web3 is compatible with [Carthage](https://github.com/Carthage/Carthage), a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To install it, simply add the following line to your `Cartfile`:

```
github "Boilertalk/Web3.swift"
```

### Swift Package Manager

Web3 is compatible with Swift Package Manager v4 (Swift 4 and above). Simply add it to the dependencies in your `Package.swift`.

```Swift
dependencies: [
    .package(url: "https://github.com/Boilertalk/Web3.swift.git", from: "0.1.0")
]
```

After which you can import it in your `.swift` files.

```Swift
import Web3
```

## Usage

> TODO: Add usage examples

## Disclaimer

Until we reach version 1.0.0 our API is subject to breaking changes between minor version jumps.
This is to make sure we can focus on providing the best implementation while we are in heavy development
instead of trying to maintain something which is deprecated.

That being said, we will try to minimize breaking changes. Most certainly there won't be many.

## Author

The awesome guys at Boilertalk :alembic:

## License

Web3 is available under the MIT license. See the LICENSE file for more info.
