// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "pxm",
    dependencies: [],
    targets: [
        .executableTarget(
            name: "pxm",
            dependencies: []),
        .testTarget(
            name: "pxmTests",
            dependencies: ["pxm"]),
    ]
)
