// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SCColorSampler",
    platforms: [.macOS("12.3")],
    products: [
        .library(
            name: "SCColorSampler",
            targets: ["SCColorSampler"]),
    ],
    targets: [
        .target(
            name: "SCColorSampler",
            path: "Sources"
        )
    ]
)
