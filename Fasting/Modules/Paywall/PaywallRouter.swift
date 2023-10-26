//
//  PaywallRouter.swift
//  Mileage.iOS
//
//  Created by Руслан Сафаргалеев on 30.08.2023.
//

import AppStudioUI
import AppStudioNavigation

class PaywallRouter: BaseRouter {

    func presentProgressView() {
        present(banner: DimmedProgressBanner())
    }
}
