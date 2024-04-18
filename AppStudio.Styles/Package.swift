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
    dependencies: [
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Navigation.git", exact: "1.0.11"),
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Common.git", exact: "1.0.20"),
        .package(url: "https://github.com/m-unicorn/iOS.MunicornFoundation.git", exact: "1.2.11"),
        .package(path: "AppStudio.Models")
    ],
    targets: [
        .target(
            name: "AppStudioStyles",
            dependencies: [
                .product(name: "MunicornFoundation", package: "iOS.MunicornFoundation"),
                .product(name: "AppStudioUI", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioFoundation", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioModels", package: "AppStudio.Models"),
                .product(name: "AppStudioNavigation", package: "AppStudio.iOS.Navigation")
            ],
            resources: [
                .process("Resources/Color.xcassets")
            ]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
