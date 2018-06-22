// swift-tools-version:4.0

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
    ],
    dependencies: [
        // Core dependencies
        .package(url: "https://github.com/attaswift/BigInt.git", from: "3.1.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.8.0"),
        .package(url: "https://github.com/Boilertalk/secp256k1.swift.git", from: "0.1.1"),

        // PromiseKit dependency
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "6.0.0"),

        // Test dependencies
        .package(url: "https://github.com/Quick/Quick.git", from: "1.2.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.3")
    ],
    targets: [
        .target(
            name: "Web3",
            dependencies: ["BigInt", "CryptoSwift", "secp256k1"],
            path: "Web3/Classes",
            sources: ["Core", "FoundationHTTP"]),
        .target(
            name: "Web3PromiseKit",
            dependencies: ["Web3", "PromiseKit"],
            path: "Web3/Classes",
            sources: ["PromiseKit"]),
        .testTarget(
            name: "Web3Tests",
            dependencies: ["Web3", "Web3PromiseKit", "Quick", "Nimble"])
    ]
)
