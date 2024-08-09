//
//  GlobalConstants.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 20.05.2023.
//


// swiftlint:disable line_length
/// SETUP your global constants
public enum GlobalConstants {
    // MARK: - Common Application Settings
    public static let applicationName = "fasting"
    public static let applicationPrefix = ""
    public static let appStoreURL = "https://apps.apple.com/us/app/APPSTORE_IDENTIFIER"

    // MARK: - Contact and other info
    public static let contactEmail = "fasting-support@municorn.com"
    public static let termsOfUse = "https://telecom.municorn.com/terms?app=fasting"
    public static let privacyPolicy = "https://telecom.municorn.com/privacy?app=fasting"

    // MARK: - Intercom
    public static let intercomObfuscatedAppId = "23403404130b5855"
    public static let intercomObfuscatedApiKey = "324d202b010d054a4719104075534750141e13107440402107595d55591604116b3812324c115f0c0412151915715040"

    // MARK: - iCloud settings
    public static let iCloudContainerIdentifier = "iCloud.CONTAINER_IDENTIFIER"

    // MARK: - Backend server settings
    // MARK: Production server
    public static let productionBaseAddress = "https://telecom.municorn.com/"
    public static let productionServicePath = "api/"
    public static let productionTimeout = 90.0

    // MARK: Sandbox server
    public static let sandboxBaseAddress = "https://staging.telecom.municorn.com/"
    public static let sandboxServicePath = "api/"
    public static let sandboxTimeout = 90.0

    static let appStoreReviewURL = "https://apps.apple.com/us/app/intermittent-fasting-tracker/id6470460463?action=write-review"
}
// swiftlint:enable line_length
