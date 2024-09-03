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
    public static let applicationName = "APP_NAME"
    public static let applicationPrefix = "APP_PREFIX"
    public static let appStoreURL = "https://apps.apple.com/us/app/APPSTORE_IDENTIFIER"

    // MARK: - Contact and other info
    public static let contactEmail = "CONTACT_EMAIL"
    public static let termsOfUse = "https://getpaidapp.com/terms"
    public static let privacyPolicy = "https://getpaidapp.com/privacy"

    // MARK: - Intercom
    public static let intercomObfuscatedAppId = "28553b15100f0911"
    public static let intercomObfuscatedApiKey = "324d202b010d054a1a1c151a27564505464914417948407d530a0456501503463b62116043410a5b01141c4211225840"

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
}
// swiftlint:enable line_length
