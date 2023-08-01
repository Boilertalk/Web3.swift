// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Web3",
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "Web3",
            targets: ["Web3"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/attaswift/BigInt.git", from: "3.0.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "0.8.0"),
        .package(url: "https://github.com/Boilertalk/secp256k1.swift.git", from: "0.1.1"),
        .package(url: "https://github.com/vapor/bits.git", from: "1.1.0"),

        // Test dependencies
        .package(url: "https://github.com/Quick/Quick.git", from: "1.2.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.2")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "VaporBytes",
            dependencies: ["Bits"],
            path: "Web3/Classes",
            sources: ["VaporBytes"]),
        .target(
            name: "Web3",
            dependencies: ["VaporBytes", "BigInt", "CryptoSwift", "secp256k1"],
            path: "Web3/Classes",
            sources: ["Core"]),
        .testTarget(
            name: "Web3Tests",
            dependencies: ["Web3", "Quick", "Nimble"],
            path: "Example/Tests",
            exclude: ["LinuxMain.swift"],
            sources: ["."]),
    ]
)
