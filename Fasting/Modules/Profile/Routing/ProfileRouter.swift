//  
//  ProfileRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.11.2023.
//

import SwiftUI
import AppStudioNavigation
import Dependencies

class ProfileRouter: BaseRouter {

    @Dependency(\.openURL) private var openURL

    func open(url: URL) {
        let route = SafariRoute(url: url) { [weak self] in
            self?.dismiss()
        }
        present(route: route)
    }

    func presentSupport() {
        guard EmailRoute.canPresent else {
            sendEmailWithOpenUrl()
            return
        }
        let subject = NSLocalizedString("ProfileScreen.supportEmailSubject", comment: "")
        let route = EmailRoute(recipient: GlobalConstants.contactEmail, subject: subject) { [weak self] in
            self?.dismiss()
        }
        present(route: route)
    }

    private func sendEmailWithOpenUrl() {
        Task {
            guard let url = URL(string: GlobalConstants.contactEmail) else { return }
            await openURL(url)
        }
    }
}
