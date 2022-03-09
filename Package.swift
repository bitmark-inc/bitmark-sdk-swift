// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BitmarkSDK",
    platforms: [.iOS(.v12), .macOS(.v10_12)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "BitmarkSDK",
            targets: ["BitmarkSDK"]),
    ],
    dependencies: [
        .package(name: "TweetNacl", url: "https://github.com/bitmark-inc/tweetnacl-swiftwrap", branch: "master"),
        .package(name: "BIP39", url: "https://github.com/bitmark-inc/bip39-swift", branch: "master"),
        .package(name: "tinysha3-spm", url: "https://github.com/autonomy-system/tinysha3-spm.git", branch: "update-name")
    ],
    targets: [
        .target(
            name: "BitmarkSDK",
            dependencies: ["tinysha3-spm", "TweetNacl", "BIP39"],
            exclude: ["Info.plist", "Bitmark/EventSubscription.swift"]),
        .testTarget(
            name: "BitmarkSDKTests",
            dependencies: ["BitmarkSDK"],
            exclude: ["Info.plist"]),
    ]
)