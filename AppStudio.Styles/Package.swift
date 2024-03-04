// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppStudio.Styles",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AppStudioStyles",
            targets: ["AppStudioStyles"]),
    ],
    targets: [
        .target(
            name: "AppStudioStyles",
            resources: [
                .process("Resources/Color.xcassets")
            ]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
