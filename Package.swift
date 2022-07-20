// swift-tools-version:5.5

/**
*  CollectionConcurrencyKit
*  Copyright (c) John Sundell 2021
*  MIT license, see LICENSE.md file for details
*/

import PackageDescription

let swiftSettings: [SwiftSetting]
#if compiler(<5.6)
swiftSettings = []
#else
swiftSettings = [.unsafeFlags(["-warn-concurrency"])]
#endif

let package = Package(
    name: "CollectionConcurrencyKit",
    platforms: [.iOS(.v13), .macOS(.v10_15), .watchOS(.v6), .tvOS(.v13)],
    products: [
        .library(
            name: "CollectionConcurrencyKit",
            targets: ["CollectionConcurrencyKit"]
        )
    ],
    targets: [
        .target(
            name: "CollectionConcurrencyKit",
            path: "Sources",
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "CollectionConcurrencyKitTests",
            dependencies: ["CollectionConcurrencyKit"],
            path: "Tests"
        )
    ]
)
