//
//  MayUseStateChangedMessage.swift
//  AppStudio
//
//  Created by Aleksei Kuprin on 18/10/2017.
//  Copyright © 2017 Payment Systems LLC. All rights reserved.
//

import AppStudioSubscriptions

class MayUseStateChangedMessage: AppStudioMessage {
    public let mayUseState: MayUseStateType
    public let mayUse: Bool

    public init(sender: Any?, mayUseState: MayUseStateType, mayUse: Bool) {
        self.mayUseState = mayUseState
        self.mayUse = mayUse
        super.init(sender: sender)
    }
}
