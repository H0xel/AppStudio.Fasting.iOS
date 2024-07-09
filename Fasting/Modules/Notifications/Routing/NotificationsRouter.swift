//  
//  NotificationsRouter.swift
//  Fasting
//
//  Created by Amakhin Ivan on 14.06.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioServices

class NotificationsRouter: BaseRouter {
    static func route(navigator: Navigator,
                      input: NotificationsInput,
                      output: @escaping NotificationsOutputBlock) -> Route {
        NotificationsRoute(navigator: navigator, input: input, output: output)
    }

    func presentNotificationsForStages(
        input: NotificationsForStagesInput,
        output: @escaping NotificationsForStagesOutputBlock
    ) {
        let route = NotificationsForStagesRoute(navigator: navigator,
                                                input: input,
                                                output: output)
        present(sheet: route, detents: [.height(703)])
    }

    func presentMultipleProductPaywall(context: PaywallContext) {
        let route = MultiplePaywallRoute(navigator: navigator,
                                         input: .init(paywallContext: context),
                                         output: { [weak self] output in
            switch output {
            case .close, .subscribed:
                self?.navigator.dismiss()
            }
        })
        navigator.present(route: route)
    }

    func presentNotificationAlert() {
        let alertTitle = "NotificationsAlert.title".localized()
        let alertSubTitle = "NotificationsAlert.subtitle".localized()
        let openSettingTitle = "NotificationsAlert.openSettings".localized()
        let cancelButtonTitle = "Button.cancel".localized()
        let openSettingsAction = DialogAction(title: openSettingTitle, role: nil, image: nil) {
            guard let settingsAppURL = URL(string: UIApplication.openNotificationSettingsURLString) else { return }
            UIApplication.shared.open(settingsAppURL, options: [:])
        }
        let cancelAction = DialogAction(title: cancelButtonTitle, role: .cancel, image: nil, action: {})
        present(systemAlert: Alert(
            title: alertTitle,
            message: alertSubTitle,
            actions: [openSettingsAction, cancelAction]))
    }
}
