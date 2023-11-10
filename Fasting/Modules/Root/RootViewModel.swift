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

enum Step {
    case fasting
    case onboarding
}

class RootViewModel: BaseViewModel<RootOutput> {
    @Dependency(\.storageService) private var storageService
    @Dependency(\.idfaRequestService) private var idfaRequestService

    @Published var currentTab: AppTab = .fasting
    @Published var step: Step

    var router: RootRouter!
    @Dependency(\.appCustomization) private var appCustomization

    init(input: RootInput, output: @escaping RootOutputBlock) {
        step = input.step
        super.init(output: output)
        initialize()
    }

    func initialize() {
        Task { [weak self] in
            guard let self else { return }
            let shouldForceUpdate = try await self.appCustomization.shouldForceUpdate()
            if shouldForceUpdate {
                self.presentForceUpdateScreen()
                return
            }
        }
    }

    func requestIdfa() {
        idfaRequestService.requestIDFATracking()
    }

    var fastingScreen: some View {
        router.fastingScreen
    }

    var onboardingScreen: some View {
        OnboardingRoute(navigator: router.navigator, input: .init(), output: { [weak self] event in
            switch event {
            case .onboardingIsFinished:
                self?.storageService.onboardingIsFinished = true
                DispatchQueue.main.async {
                    self?.router.popToRoot()
                    self?.step = .fasting
                }
            }
        })
        .view
    }

    var profileScreen: some View {
        router.profileScreen
    }

    var paywallScreen: some View {
        PaywallRoute(navigator: router.navigator, input: .fromSettings) { [weak self] _ in

        }
        .view
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
