//
//  TelecomTargetType.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 08.11.2023.
//

import Foundation
import Moya
import Dependencies

protocol TelecomTargetType: TargetType, AccessTokenAuthorizable {}

extension TelecomTargetType {

    var authorizationType: AuthorizationType? {
        .basic
    }

    var baseURL: URL {
        @Dependency(\.apiSettingsProvider) var apiSettingsProvider
        guard let url = URL(string: "\(apiSettingsProvider.baseAddress)\(apiSettingsProvider.servicePath)") else {
            fatalError("Base URL is not configured")
        }
        return url
    }

    var headers: [String: String]? {
        @Dependency(\.mobileDeviceDataProvider) var mobileDeviceDataProvider
        let deviceData = mobileDeviceDataProvider.deviceData

        return [
            "XA-OS-Type": deviceData.osType,
            "XA-OS-Version": deviceData.osVersion,
            "XA-App-Build-Number": deviceData.appBuildNumber,
            "XA-App-Version": deviceData.appVersion,
            "XA-App-Type": deviceData.appType,
            "XA-Store": deviceData.store,
            "XA-Device-Model": deviceData.deviceModel,
            "XA-Vendor-Id": deviceData.id,
            "XA-Timezone": deviceData.timezone.description
        ]
    }

    var validationType: ValidationType {
        .successCodes
    }
}
