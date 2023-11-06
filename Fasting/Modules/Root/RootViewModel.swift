//  
//  RootViewModel.swift
//  Fasting
//
//  Created by Denis Khlopin on 19.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI
import Dependencies

class RootViewModel: BaseViewModel<RootOutput> {

    @Published var currentTab: AppTab = .fasting

    var router: RootRouter!
    @Dependency(\.appCustomization) private var appCustomization

    init(input: RootInput, output: @escaping RootOutputBlock) {
        super.init(output: output)
        initialize()
    }

    func initialize() {
        Task { [weak self] in
            guard let self else { return }
            let shouldForceUpdate = try await self.appCustomization.shouldForceUpdate()
            if shouldForceUpdate {
                self.presentForceUpdateScreen()
            }
        }
    }

    var fasringScreen: some View {
        router.fastingScreen
    }

    var profileScreen: some View {
        router.profileScreen
    }
}

// MARK: Routing
extension RootViewModel {
    func showPaywall() {
        router.presentPaywall()
    }

    private func presentForceUpdateScreen() {
        let banner = ForceUpdateBanner { [weak self] in
            self?.router.presentAppStore()
        }
        router.present(banner: banner)
    }
}
