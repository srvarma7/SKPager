// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SKPager",
    products: [
        .library(
            name: "SKPager",
            targets: ["SKPager"]),
    ],
    dependencies: [
        .package(url: "https://github.com/srvarma7/SKBar", branch: "main")
    ],
    targets: [
        .target(
            name: "SKPager",
            dependencies: [
                "SKBar"
            ]),
        .testTarget(
            name: "SKPagerTests",
            dependencies: ["SKPager"]),
    ]
)
