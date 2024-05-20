//
//  View+withInAppPurchase.swift
//
//
//  Created by Amakhin Ivan on 02.05.2024.
//

import NewAppStudioSubscriptions
import Dependencies
import SwiftUI

struct WithInAppPurchaseModifier: ViewModifier {
    @Dependency(\.newSubscriptionService) private var newSubscriptionService
    var status: (inAppPurchaseStatus) -> ()

    func body(content: Content) -> some View {
        content
            .onReceive(newSubscriptionService.inAppPurchaseStatus.dropFirst()) { status in
                self.status(status)
            }
    }
}

public extension View {
    func withInAppPurchase(status: @escaping (inAppPurchaseStatus) -> ()) -> some View {
        modifier(WithInAppPurchaseModifier(status: status))
    }
}
