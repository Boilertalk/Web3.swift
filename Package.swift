// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Web3",
    products: [
        .library(
            name: "Web3",
            targets: ["Web3"]),
        .library(
            name: "Web3PromiseKit",
            targets: ["Web3PromiseKit"]),
        .library(
            name: "Web3Keychain",
            targets: ["Web3Keychain"]),
        .library(
            name: "Web3ContractABI",
            targets: ["Web3ContractABI"]),
    ],
    dependencies: [
        // Core dependencies
        .package(url: "https://github.com/attaswift/BigInt.git", from: "3.1.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.15.0"),
        
        // Keychain dependency
        .package(url: "https://github.com/Boilertalk/secp256k1.swift.git", from: "0.1.1"),

        // PromiseKit dependency
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "6.8.0"),

        // Test dependencies
        .package(url: "https://github.com/Quick/Quick.git", from: "2.1.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "Web3",
            dependencies: ["BigInt", "CryptoSwift"],
            path: "Web3/Classes",
            sources: ["Core", "FoundationHTTP"]),
        .target(
            name: "Web3Keychain",
            dependencies: ["Web3", "BigInt", "CryptoSwift", "secp256k1"],
            path: "Web3/Classes",
            sources: ["Keychain"]),
        .target(
            name: "Web3PromiseKit",
            dependencies: ["Web3", "PromiseKit"],
            path: "Web3/Classes",
            sources: ["PromiseKit"]),
        .target(
            name: "Web3ContractABI",
            dependencies: ["Web3", "BigInt", "CryptoSwift"],
            path: "Web3/Classes",
            sources: ["ContractABI"]),
        .testTarget(
            name: "Web3Tests",
            dependencies: ["Web3", "Web3Keychain", "Web3PromiseKit", "Web3ContractABI", "Quick", "Nimble"])
    ]
)
