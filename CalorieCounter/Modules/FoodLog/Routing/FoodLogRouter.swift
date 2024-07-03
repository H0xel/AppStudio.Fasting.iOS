//  
//  FoodLogRouter.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.12.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import AppStudioServices

class FoodLogRouter: BaseRouter {

    let mealRouter: MealViewRouter

    override init(navigator: Navigator) {
        mealRouter = .init(navigator: navigator)
        super.init(navigator: navigator)
    }

    func presentMealTypePicker(currentMealType: MealType, onPick: @escaping (MealType) -> Void) {
        let route = MealTypePickerRoute(currentMealType: currentMealType) { [weak self] type in
            self?.dismiss()
            onPick(type)
        }
        present(sheet: route, detents: [.medium], showIndicator: false)
    }

    func presentBarcodeScanner(output: @escaping BarcodeOutputBlock) {
        let route = BarcodeRoute(navigator: navigator, input: BarcodeInput(), output: output)
        present(route: route)
    }

    func presentPaywall(output: @escaping ViewOutput<PaywallScreenOutput>) {
        let route = UsagePaywallRoute(navigator: navigator,
                                      context: .barcodeScanner,
                                      output: output)
        present(route: route)
    }

    func presentQuickAddBanner(input: QuickAddInput, output: @escaping QuickAddOutputBlock) {
        let banner = QuickAddBanner(navigator: navigator, input: input, output: output)
        present(banner: banner)
    }

    func presentCameraAccessAlert() {
        let alertTitle = NSLocalizedString("CameraAlert.title" , comment: "")
        let alertSubTitle = NSLocalizedString("CameraAlert.subtitle" , comment: "")
        let openSettingTitle = NSLocalizedString("CameraAlert.openSettings" , comment: "")
        let cancelButtonTitle = NSLocalizedString("Button.cancel" , comment: "")
        let openSettingsAction = DialogAction(title: openSettingTitle, role: nil, image: nil) {
            guard let settingsAppURL = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsAppURL, options: [:])
        }
        let cancelAction = DialogAction(title: cancelButtonTitle, role: .cancel, image: nil, action: {})
        present(systemAlert: Alert(
            title: alertTitle,
            message: alertSubTitle,
            actions: [openSettingsAction, cancelAction]))
    }
}
