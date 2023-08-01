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

## Installation

### CocoaPods

Web3 is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your `Podfile`:

```ruby
pod 'Web3'
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

## Author

Koray Koska, koray@koska.at

## License

Web3 is available under the MIT license. See the LICENSE file for more info.
