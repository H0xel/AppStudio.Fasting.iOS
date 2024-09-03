//
//  PushReceivedMessage.swift
//  AppStudioTemplate
//
//  Created by Alexander Bochkarev on 09.11.2023.
//

class PushReceivedMessage: AppStudioMessage {
    let push: Push
    let isInForeground: Bool
    var isInBackground: Bool { !isInForeground }

    init(push: Push, isInForeground: Bool) {
        self.push = push
        self.isInForeground = isInForeground
        super.init()
    }
}
