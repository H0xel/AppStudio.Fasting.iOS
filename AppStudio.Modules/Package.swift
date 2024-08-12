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
        .package(path: "AppStudio.Styles"),
        .package(path: "AppStudio.Services"),
        .package(path: "AppStudio.Models")
    ],
    targets: [
        .target(
            name: "AICoach",
            dependencies: [
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
                .product(name: "AppStudioStyles", package: "AppStudio.Styles"),
                .product(name: "AppStudioServices", package: "AppStudio.Services"),
                .product(name: "AppStudioModels", package: "AppStudio.Models"),
                "WeightGoalWidget"
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
            name: "FastingWidget",
            dependencies: [
                .product(name: "AppStudioStyles", package: "AppStudio.Styles"),
                .product(name: "AppStudioServices", package: "AppStudio.Services"),
                .product(name: "AppStudioModels", package: "AppStudio.Models"),
            ],
            resources: [
                .process("Resources/en.lproj/Localizable.strings"),
                .process("Resources/fr-CA.lproj/Localizable.strings"),
                .process("Resources/fr.lproj/Localizable.strings"),
                .process("Resources/pt-BR.lproj/Localizable.strings")
            ]
        ),
        .target(
            name: "HealthOverview",
            dependencies: [
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
                .product(name: "AppStudioStyles", package: "AppStudio.Styles"),
                .product(name: "AppStudioServices", package: "AppStudio.Services"),
                .product(name: "AppStudioModels", package: "AppStudio.Models")
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
