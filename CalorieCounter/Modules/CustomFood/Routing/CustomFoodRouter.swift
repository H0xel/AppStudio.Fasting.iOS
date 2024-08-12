//  
//  CustomFoodRouter.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.07.2024.
//

import SwiftUI
import AppStudioUI
import AppStudioNavigation
import AppStudioStyles
import Dependencies

class CustomFoodRouter: BaseRouter {
    @Dependency(\.cameraAccessService) private var cameraAccessService

    static func route(navigator: Navigator,
                      input: CustomFoodInput,
                      output: @escaping CustomFoodOutputBlock) -> Route {
        CustomFoodRoute(navigator: navigator, input: input, output: output)
    }

    func presentChangeWeightBanner(input: CustomKeyboardInput, output: @escaping ViewOutput<ContainerKeyboardOutput>) {
        let banner = ContainerKeyboardBanner(input: input, output: output)
        present(banner: banner, animation: .linear(duration: 0.2))
    }

    func presentChangeTextBanner(input: CustomTextKeyboardInput, output: @escaping ViewOutput<CustomTextKeyboardOutput>) {
        let banner = CustomTextKeyboardBanner(input: input, output: output)
        present(banner: banner, animation: .linear(duration: 0.2))
    }

    func presentBottomSheet(configuration: BottomActionSheetConfiguration, completion: @escaping () -> Void) {
        let router = BottomActionSheetRoute(
            navigator: navigator, 
            input: .init(configuration: configuration
            ),
            output: { [weak self] event in
                self?.dismiss()
                switch event {
                case .leftButtonTapped:
                    break
                case .rightButtonTapped:
                    completion()
                }
            }
        )

        var height: CGFloat {
            configuration == .deleteBarcode ? 203 : 233
        }

        present(sheet: router, detents: [.height(height)], showIndicator: false)
    }

    func presentBarcodeScanner(output: @escaping BarcodeOutputBlock) {
        Task {
            guard await cameraAccessService.requestAccess() else {
                presentCameraAccessAlert()
                return
            }
            let route = BarcodeRoute(navigator: self.navigator, input: BarcodeInput(), output: output)
            await present(route: route)
        }
    }

    private func presentCameraAccessAlert() {
        let alertTitle = "CameraAlert.title".localized()
        let alertSubTitle = "CameraAlert.subtitle".localized()
        let openSettingTitle = "CameraAlert.openSettings".localized()
        let cancelButtonTitle = "Button.cancel".localized()
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
