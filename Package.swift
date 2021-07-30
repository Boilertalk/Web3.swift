// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "Web3",
    platforms: [
       .iOS(.v10),
       .macOS(.v10_12)
    ],
    products: [
        .library(
            name: "Web3",
            targets: ["Web3"]),
    ],
    dependencies: [
        // Core dependencies
        .package(url: "https://github.com/attaswift/BigInt.git", from: "5.0.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.0.0"),
        .package(name: "secp256k1", url: "https://github.com/GigaBitcoin/secp256k1.swift", .branch("main")),
        .package(url: "https://github.com/mxcl/PromiseKit.git", from: "6.0.0"),
    ],
    targets: [
        .target(
            name: "Web3",
            dependencies: ["BigInt", "CryptoSwift", "PromiseKit", "secp256k1"],
            path: "Sources"),
    ],
    swiftLanguageVersions: [.version("5.5")]
)
