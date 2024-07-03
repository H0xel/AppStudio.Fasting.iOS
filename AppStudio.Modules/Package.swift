// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppStudio.CommonModules",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "AICoach",
            targets: ["AICoach"]
        ),
        .library(
            name: "WeightWidget",
            targets: ["WeightWidget"]
        ),
        .library(
            name: "FastingWidget",
            targets: ["FastingWidget"]
        ),
        .library(
            name: "HealthOverview",
            targets: ["HealthOverview"]
        ),
        .library(
            name: "HealthProgress",
            targets: ["HealthProgress"]
        ),
        .library(
            name: "WaterCounter",
            targets: ["WaterCounter"]
        ),
        .library(
            name: "WeightGoalWidget",
            targets: ["WeightGoalWidget"]
        ),
        .library(
            name: "Explore",
            targets: ["Explore"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", exact: "1.0.0"),
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Navigation.git", exact: "1.0.13"),
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Common.git", exact: "1.0.20"),
        .package(url: "https://github.com/m-unicorn/AppStudio.iOS.Analytics.git", exact: "1.0.7"),
        .package(url: "https://github.com/m-unicorn/iOS.MunicornFoundation.git", exact: "1.2.12"),
        .package(url: "https://github.com/gonzalezreal/swift-markdown-ui", from: "2.3.0"),
        .package(path: "AppStudio.Styles"),
        .package(path: "AppStudio.Services"),
        .package(path: "AppStudio.Models")
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
                .product(name: "AppStudioAnalytics", package: "AppStudio.iOS.Analytics"),
                .product(name: "AppStudioServices", package: "AppStudio.Services"),
                .product(name: "AppStudioModels", package: "AppStudio.Models"),
                .product(name: "AppStudioStyles", package: "AppStudio.Styles"),
            ],
            resources: [
                .process("Resources/en.lproj/Localizable.strings"),
                .process("Resources/es.lproj/Localizable.strings"),
                .process("Resources/fr-CA.lproj/Localizable.strings"),
                .process("Resources/fr.lproj/Localizable.strings"),
                .process("Resources/pt-BR.lproj/Localizable.strings")
            ]
        ),
        .target(
            name: "WeightWidget",
            dependencies: [
                .product(name: "MunicornFoundation", package: "iOS.MunicornFoundation"),
                .product(name: "MunicornCoreData", package: "iOS.MunicornFoundation"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "AppStudioNavigation", package: "AppStudio.iOS.Navigation"),
                .product(name: "AppStudioAnalytics", package: "AppStudio.iOS.Analytics"),
                .product(name: "AppStudioFoundation", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioUI", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioStyles", package: "AppStudio.Styles"),
                .product(name: "AppStudioServices", package: "AppStudio.Services"),
                .product(name: "AppStudioModels", package: "AppStudio.Models"),
                "WeightGoalWidget"
            ],
            resources: [
//                .process("Resources")
                .process("Resources/en.lproj/Localizable.strings"),
                .process("Resources/es.lproj/Localizable.strings"),
                .process("Resources/fr-CA.lproj/Localizable.strings"),
                .process("Resources/fr.lproj/Localizable.strings"),
                .process("Resources/pt-BR.lproj/Localizable.strings")
            ]
        ),
        .target(
            name: "FastingWidget",
            dependencies: [
                .product(name: "MunicornFoundation", package: "iOS.MunicornFoundation"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "AppStudioNavigation", package: "AppStudio.iOS.Navigation"),
                .product(name: "AppStudioAnalytics", package: "AppStudio.iOS.Analytics"),
                .product(name: "AppStudioFoundation", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioUI", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioStyles", package: "AppStudio.Styles"),
                .product(name: "AppStudioServices", package: "AppStudio.Services"),
                .product(name: "AppStudioModels", package: "AppStudio.Models"),
            ],
            resources: [
//                .process("Resources")
                .process("Resources/en.lproj/Localizable.strings"),
//                .process("Resources/es.lproj/Localizable.strings"),
                .process("Resources/fr-CA.lproj/Localizable.strings"),
                .process("Resources/fr.lproj/Localizable.strings"),
                .process("Resources/pt-BR.lproj/Localizable.strings")
            ]
        ),
        .target(
            name: "HealthOverview",
            dependencies: [
                .product(name: "MunicornFoundation", package: "iOS.MunicornFoundation"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "AppStudioNavigation", package: "AppStudio.iOS.Navigation"),
                .product(name: "AppStudioAnalytics", package: "AppStudio.iOS.Analytics"),
                .product(name: "AppStudioFoundation", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioUI", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioStyles", package: "AppStudio.Styles"),
                .product(name: "AppStudioServices", package: "AppStudio.Services"),
                .product(name: "AppStudioModels", package: "AppStudio.Models"),
                "WeightWidget",
                "FastingWidget",
                "WaterCounter"
            ],
            resources: [
                .process("Resources/en.lproj/Localizable.strings"),
                .process("Resources/es.lproj/Localizable.strings"),
                .process("Resources/fr-CA.lproj/Localizable.strings"),
                .process("Resources/fr.lproj/Localizable.strings"),
                .process("Resources/pt-BR.lproj/Localizable.strings")
            ]
        ),
        .target(
            name: "HealthProgress",
            dependencies: [
                .product(name: "MunicornFoundation", package: "iOS.MunicornFoundation"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "AppStudioNavigation", package: "AppStudio.iOS.Navigation"),
                .product(name: "AppStudioUI", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioAnalytics", package: "AppStudio.iOS.Analytics"),
                .product(name: "AppStudioStyles", package: "AppStudio.Styles"),
                .product(name: "AppStudioServices", package: "AppStudio.Services"),
                .product(name: "AppStudioModels", package: "AppStudio.Models"),
                "WeightWidget",
                "WeightGoalWidget",
                "WaterCounter"
            ],
            resources: [
                .process("Resources/en.lproj/Localizable.strings"),
                .process("Resources/es.lproj/Localizable.strings"),
                .process("Resources/fr-CA.lproj/Localizable.strings"),
                .process("Resources/fr.lproj/Localizable.strings"),
                .process("Resources/pt-BR.lproj/Localizable.strings")
            ]
        ),
        .target(
            name: "WaterCounter",
            dependencies: [
                .product(name: "MunicornFoundation", package: "iOS.MunicornFoundation"),
                .product(name: "MunicornCoreData", package: "iOS.MunicornFoundation"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "AppStudioNavigation", package: "AppStudio.iOS.Navigation"),
                .product(name: "AppStudioUI", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioAnalytics", package: "AppStudio.iOS.Analytics"),
                .product(name: "AppStudioStyles", package: "AppStudio.Styles"),
                .product(name: "AppStudioServices", package: "AppStudio.Services")
            ],
            resources: [
                .process("Resources/en.lproj/Localizable.strings"),
                .process("Resources/es.lproj/Localizable.strings"),
                .process("Resources/fr-CA.lproj/Localizable.strings"),
                .process("Resources/fr.lproj/Localizable.strings"),
                .process("Resources/pt-BR.lproj/Localizable.strings")
            ]
        ),
        .target(
            name: "WeightGoalWidget",
            dependencies: [
                .product(name: "MunicornFoundation", package: "iOS.MunicornFoundation"),
                .product(name: "MunicornCoreData", package: "iOS.MunicornFoundation"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "AppStudioNavigation", package: "AppStudio.iOS.Navigation"),
                .product(name: "AppStudioAnalytics", package: "AppStudio.iOS.Analytics"),
                .product(name: "AppStudioFoundation", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioUI", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioStyles", package: "AppStudio.Styles"),
                .product(name: "AppStudioServices", package: "AppStudio.Services"),
                .product(name: "AppStudioModels", package: "AppStudio.Models"),
            ],
            resources: [
                .process("Resources/en.lproj/Localizable.strings"),
                .process("Resources/es.lproj/Localizable.strings"),
                .process("Resources/fr-CA.lproj/Localizable.strings"),
                .process("Resources/fr.lproj/Localizable.strings"),
                .process("Resources/pt-BR.lproj/Localizable.strings")
            ]
        ),
        .target(
            name: "Explore",
            dependencies: [
                .product(name: "MunicornFoundation", package: "iOS.MunicornFoundation"),
                .product(name: "MunicornCoreData", package: "iOS.MunicornFoundation"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "AppStudioNavigation", package: "AppStudio.iOS.Navigation"),
                .product(name: "AppStudioAnalytics", package: "AppStudio.iOS.Analytics"),
                .product(name: "AppStudioFoundation", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioUI", package: "AppStudio.iOS.Common"),
                .product(name: "AppStudioStyles", package: "AppStudio.Styles"),
                .product(name: "AppStudioServices", package: "AppStudio.Services"),
                .product(name: "AppStudioModels", package: "AppStudio.Models"),
                .product(name: "MarkdownUI", package: "swift-markdown-ui")
            ],
            resources: [
                .process("Resources/en.lproj/Localizable.strings"),
                .process("Resources/es.lproj/Localizable.strings"),
                .process("Resources/fr-CA.lproj/Localizable.strings"),
                .process("Resources/fr.lproj/Localizable.strings"),
                .process("Resources/pt-BR.lproj/Localizable.strings")
            ]
        ),
        .testTarget(name: "WaterCounterTest", dependencies: ["WaterCounter"])
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
