//
//  PaywallRouter.swift
//  Mileage.iOS
//
//  Created by Руслан Сафаргалеев on 30.08.2023.
//

import AppStudioUI
import AppStudioNavigation
import Foundation

class PaywallRouter: BaseRouter {

    func presentProgressView() {
        present(banner: DimmedProgressBanner())
    }

    func open(url: URL) {
        let route = SafariRoute(url: url) { [weak self] in
            self?.dismiss()
        }
        present(route: route)
    }
}
