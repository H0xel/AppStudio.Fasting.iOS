//
//  RestoreSubscriptionStateMessage.swift
//  AppStudio
//
//  Created by Aleksei Kuprin on 03/10/2017.
//  Copyright © 2017 Payment Systems LLC. All rights reserved.
//

import Foundation
import AppStudioSubscriptions

public class RestoreSubscriptionStateMessage: AppStudioMessage {
    public let state: RestoreSubscriptionState

    init(sender: Any?, state: RestoreSubscriptionState) {
        self.state = state
        super.init(sender: sender)
    }
}
