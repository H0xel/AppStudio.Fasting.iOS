//
//  SignUpMessage.swift
//  AppStudio
//
//  Created by Александр Alex on 12.01.18.
//  Copyright © 2018 GetPaid Inc. All rights reserved.
//

import Foundation

class AppInitializedMessage: AppStudioMessage {
    public let isInitial: Bool

    public init(sender: Any?, isInitial: Bool) {
        self.isInitial = isInitial
        super.init(sender: sender)
    }
}
