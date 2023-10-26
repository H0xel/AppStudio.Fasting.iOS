//
//  SubscriptionStateMessage.swift
//  AppStudio
//
//  Created by Aleksei Kuprin on 03/10/2017.
//  Copyright © 2017 Payment Systems LLC. All rights reserved.
//

import AppStudioSubscriptions

class SubscriptionStateMessage: AppStudioMessage {
    public let stateChangeType: SubscriptionStateChangeType

    public init(sender: Any?, stateChangeType: SubscriptionStateChangeType) {
        self.stateChangeType = stateChangeType
        super.init(sender: sender)
    }
}
