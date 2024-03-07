// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AICoach",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AICoach",
            targets: ["AICoach"])
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", exact: "1.0.0"),
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Navigation.git", exact: "1.0.11"),
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Common.git", exact: "1.0.20"),
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Analytics.git", exact: "1.0.5"),
        .package(url: "https://github.com/m-unicorn/iOS.MunicornFoundation.git", exact: "1.2.11")
    ],
    targets: [
        .target(
            name: "AICoach",
            dependencies: [
                .product(name: "MunicornAPI", package: "iOS.MunicornFoundation"),
                .product(name: "MunicornUtilities", package: "iOS.MunicornFoundation"),
                .product(name: "MunicornFoundation", package: "iOS.MunicornFoundation"),
                .product(name: "MunicornCoreData", package: "iOS.MunicornFoundation"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "AppStudioNavigation", package: "AppStudio.iOS.Navigation"),
                .product(name: "AppStudioUI", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioFoundation", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioAnalytics", package: "AppStudio.iOS.Analytics")
            ],
            resources: [
                .process("Resources/en.lproj/Localizable.strings")
            ]
        )
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
