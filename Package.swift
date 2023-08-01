// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Web3",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "VaporBytes",
            targets: ["VaporBytes"]),
        .library(
            name: "Web3",
            targets: ["Web3"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/attaswift/BigInt.git", from: "3.0.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.8.0"),
        .package(url: "https://github.com/Boilertalk/secp256k1.swift.git", from: "0.1.0"),
        .package(url: "https://github.com/vapor/bits.git", from: "1.1.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            path: "Web3/Classes",
            sources: ["VaporBytes"],
            name: "VaporBytes",
            dependencies: ["Bits"]),
        .target(
            path: "Web3/Classes",
            sources: ["Core"],
            name: "Web3",
            dependencies: ["VaporBytes", "BigInt", "CryptoSwift", "secp256k1"]),
        .testTarget(
            path: "Example/Tests",
            exclude: ["LinuxMain.swift"],
            sources: ".",
            name: "Web3Tests",
            dependencies: ["Web3"]),
    ]
)
