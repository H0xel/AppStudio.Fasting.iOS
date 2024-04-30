//
//  DiscountNotification.swift
//  
//
//  Created by Amakhin Ivan on 25.04.2024.
//

import UserNotifications
import AppStudioFoundation

public struct DiscountLocalNotification: LocalNotification {
    public let id: String = "Discount.notification"
    public let deepLink: DeepLink? = .discount
    
    public var content: UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Deeplink.title.discount".localized(bundle: .module)
        content.body = "Deeplink.body.discount".localized(bundle: .module)
        if let deepLink {
            content.userInfo = ["deepLink": deepLink.rawValue]
        }
        return content
    }
    
    public init() {}
}
