// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppStudio.Dependencies",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AppStudio.Dependencies",
            targets: ["AppStudio.Dependencies"]),
    ],
    dependencies: [
        // Internal municorn dependencies
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Common.git", exact: "1.0.23"),
        .package(url: "https://github.com/m-unicorn/iOS.MunicornFoundation.git", exact: "1.2.12"),
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Analytics.git", exact: "1.0.8"),
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Navigation.git", exact: "1.0.14"),
        .package(url: "https://github.com/m-unicorn/iOS.ABTesting.git", exact: "1.0.6"),
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Subscriptions.git", exact: "1.0.13"),
        //  External dependencies
        .package(url: "https://github.com/ReactiveX/RxSwift.git", exact: "6.6.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", exact: "1.0.0"),
        .package(url: "https://github.com/intercom/intercom-ios-sp", exact: "17.1.1"),
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.3.0"),
        .package(url: "https://github.com/Moya/Moya.git", exact: "15.0.3"),
        .package(url: "https://github.com/facebook/facebook-ios-sdk.git", exact: "17.0.2"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", exact: "10.23.1")
    ],
    targets: [
        .target(
            name: "AppStudio.Dependencies",
            dependencies: [
                // Internal municorn dependencies
                .product(name: "AppStudioFoundation", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioUI", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioABTesting", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioNavigation", package: "AppStudio.iOS.Navigation"),
                .product(name: "AppStudioSubscriptions", package: "AppStudio.iOS.Subscriptions"),
                .product(name: "NewAppStudioSubscriptions", package: "AppStudio.iOS.Subscriptions"),
                .product(name: "AppStudioAnalytics", package: "AppStudio.iOS.Analytics"),
                .product(name: "MunicornFoundation", package: "iOS.MunicornFoundation"),
                .product(name: "MunicornAPI", package: "iOS.MunicornFoundation"),
                .product(name: "MunicornUtilities", package: "iOS.MunicornFoundation"),
                .product(name: "MunicornCoreData", package: "iOS.MunicornFoundation"),
                .product(name: "ABTesting", package: "iOS.ABTesting"),
                //  External dependencies
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "MarkdownUI", package: "swift-markdown-ui"),
                .product(name: "Intercom", package: "intercom-ios-sp"),
                .product(name: "Moya", package: "Moya"),
                .product(name: "FacebookCore", package: "facebook-ios-sdk"),
                .product(name: "FirebaseCrashlytics", package: "firebase-ios-sdk")
            ]
        ),
    ]
)
