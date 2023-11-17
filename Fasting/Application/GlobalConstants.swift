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
    // TODO: - Add information
    public static let applicationName = "fasting"
    public static let applicationPrefix = ""
    public static let appStoreURL = "https://apps.apple.com/us/app/APPSTORE_IDENTIFIER"

    // TODO: - Add contactEmail, termsOfUse, privacyPolicy
    // MARK: - Contact and other info
    public static let contactEmail = "fasting-support@municorn.com"
    public static let termsOfUse = "https://telecom.municorn.com/terms?app=fasting"
    public static let privacyPolicy = "https://telecom.municorn.com/privacy?app=fasting"

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
    public static let sandboxBaseAddress = "https://telecom.municorn.com/"
    public static let sandboxServicePath = "api/"
    public static let sandboxTimeout = 90.0
}
// swiftlint:enable line_length
