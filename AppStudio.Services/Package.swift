// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppStudio.Services",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "AppStudioServices",
            targets: ["AppStudioServices"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", exact: "1.0.0"),
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Common.git", exact: "1.0.20"),
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Analytics.git", exact: "1.0.7"),
        .package(url: "https://github.com/m-unicorn/iOS.MunicornFoundation.git", exact: "1.2.12"),
        .package(url: "https://github.com/m-unicorn/iOS.ABTesting.git", exact: "1.0.6"),
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Subscriptions.git", exact: "1.0.4"),
        .package(path: "AppStudio.Models")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "AppStudioServices",
            dependencies: [
                .product(name: "MunicornAPI", package: "iOS.MunicornFoundation"),
                .product(name: "MunicornUtilities", package: "iOS.MunicornFoundation"),
                .product(name: "MunicornFoundation", package: "iOS.MunicornFoundation"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "AppStudioFoundation", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioUI", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioABTesting", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioAnalytics", package: "AppStudio.iOS.Analytics"),
                .product(name: "ABTesting", package: "iOS.ABTesting"),
                .product(name: "AppStudioSubscriptions", package: "AppStudio.iOS.Subscriptions"),
                .product(name: "NewAppStudioSubscriptions", package: "AppStudio.iOS.Subscriptions"),
                .product(name: "AppStudioModels", package: "AppStudio.Models")
            ],
            resources: [
                .process("Resources/en.lproj/Localizable.strings")
            ]
        )
    ]
)
