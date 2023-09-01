// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "pxm",
  platforms: [.macOS(.v13)],
  dependencies: [
    .package(url: "https://github.com/fang-ling/image-codec", from: "0.0.14"),
    .package(
      url: "https://github.com/fang-ling/image-transformation",
      from: "0.0.3"
    ),
    .package(url: "https://github.com/fang-ling/collections", from: "0.0.8"),
    .package(
      url: "https://github.com/apple/swift-argument-parser",
      from: "1.2.2"
    )
  ],
  targets: [
    .executableTarget(
      name: "pxm",
      dependencies: [
        .product(name: "ImageCodec", package: "image-codec"),
        .product(name: "ImageTransformation", package: "image-transformation"),
        .product(name: "Collections", package: "collections"),
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ]
    ),
    .testTarget(
      name: "pxmTests",
      dependencies: ["pxm"]
    ),
  ]
)
