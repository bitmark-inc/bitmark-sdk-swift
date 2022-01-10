// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "tinysha3",
  products: [
  .library(name: "tinysha3", targets: ["tinysha3"]),
  ],
  targets: [
    .systemLibrary(name: "tinysha3"),
  ]
)