//
//  ErrorHandling.swift
//  AppStudioTemplate
//
//  Created by Konstantin Golenkov on 14.02.2024.
//

import Foundation
import AppStudioUI
import AppStudioNavigation

protocol ErrorHandling {
    func handle(error: TelecomError, router: Router, buttonTitle: String, action: @escaping () -> Void)
}

extension ErrorHandling {
    func handle(error: TelecomError,
                router: Router,
                buttonTitle: String,
                action: @escaping () -> Void) {
        handle(error: error,
               router: router,
               title: nil,
               message: nil,
               buttonTitle: buttonTitle,
               action: action)
    }

    func handle(error: TelecomError,
                router: Router,
                title: String? = nil,
                message: String? = nil,
                buttonTitle: String,
                action: @escaping () -> Void) {
        var alertTitle: String
        var alertMessage: String

        switch error.code {
        case .networkError:
            alertTitle = title ?? NSLocalizedString("Error.Network.title", comment: "")
            alertMessage = message ?? NSLocalizedString("Error.Network.message", comment: "")
        default:
            alertTitle = title ?? NSLocalizedString("Error.Unknonw.title", comment: "")
            alertMessage = message ?? NSLocalizedString("Error.Unknown.message", comment: "")
        }

        router.present(systemAlert: Alert(title: alertTitle,
                                          message: alertMessage,
                                          actions: [DialogAction(title: buttonTitle,
                                                                 role: .cancel,
                                                                 image: nil,
                                                                 action: action)]))
    }
}
