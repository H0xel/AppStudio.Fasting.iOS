//
//  MealViewRouter.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

class MealViewRouter: BaseRouter {
    func presentDeleteBanner(editType: MealEditType,
                             onCancel: @escaping () -> Void,
                             onDelete: @escaping () -> Void,
                             onEdit: @escaping () -> Void) {
        let banner = MealDeleteBanner(editType: editType,
                                      onCancel: onCancel,
                                      onDelete: onDelete,
                                      onEdit: onEdit)
        present(banner: banner)
    }

    func presentAddIngredientBanner(meal: Meal,
                                    onTap: @escaping (String) -> Void,
                                    onBarcodeScan: @escaping (Bool) -> Void,
                                    onDismissFocus: @escaping () -> Void) {
        let route = AddIngredientBanner(meal: meal,
                                        onTap: onTap,
                                        onBarcodeScan: onBarcodeScan,
                                        onDismissFocus: onDismissFocus)
        present(banner: route)
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

    func presentChangeWeightBanner(title: String,
                                   initialWeight: Double,
                                   onWeightChange: @escaping (Double) -> Void,
                                   onCancel: @escaping () -> Void) {
        let banner = ChangeWeightBanner(title: title,
                                        initialWeight: initialWeight,
                                        onWeightChange: onWeightChange,
                                        onCancel: onCancel)
        present(banner: banner)
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
}
