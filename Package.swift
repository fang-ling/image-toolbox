// swift-tools-version: 5.7

import PackageDescription

let package = Package(
  name: "pxm",
  dependencies: [
    .package(url: "https://github.com/fang-ling/image-codec", from: "0.0.6"),
    .package(
      url: "https://github.com/fang-ling/image-transformation",
      from: "0.0.1"
    ),
    .package(url: "https://github.com/fang-ling/collections", from: "0.0.2")
  ],
  targets: [
    .executableTarget(
      name: "pxm",
      dependencies: [
        .product(name: "txt", package: "image-codec"),
        .product(name: "lml", package: "image-transformation"),
        .product(name: "xhl", package: "collections")
      ]),
    .testTarget(
      name: "pxmTests",
      dependencies: ["pxm"]),
  ]
)
