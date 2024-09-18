//  
//  RootViewModel.swift
//  AppStudioTemplate
//
//  Created by Denis Khlopin on 19.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import Dependencies
import SwiftUI
import NewAppStudioSubscriptions

class RootViewModel: BaseViewModel<RootOutput> {
    @Dependency(\.idfaRequestService) private var idfaRequestService
    @Dependency(\.rootInitializationService) private var rootInitializationService
    @Dependency(\.cloudStorage) private var cloudStorage

    @Published private(set) var rootScreen: RootScreen = .launchScreen
    @Published private(set) var isProcessingSubscription = false
    @Published private(set) var hasSubscription = false

    private let router: RootRouter

    lazy var onboardingScreen: some View = {
        router.onboardingScreen { [weak self] event in
            switch event {
            case .onboardingIsFinished:
                self?.cloudStorage.onboardingIsFinished = true
                DispatchQueue.main.async {
                    self?.router.popToRoot()
                    self?.rootScreen = .periodTracker
                }
            }
        }
    }()

    override init() {
        router = RootRouter(navigator: Navigator())
        super.init()
        initialize()
    }

    func handle(status: inAppPurchaseStatus) {
        if status.isLoading {
            isProcessingSubscription = true
            return
        }
        isProcessingSubscription = false
    }

    private func initialize() {
        rootInitializationService
            .rootSetup
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, setup in
                this.hasSubscription = setup.hasSubscription
                this.rootScreen = setup.rootScreen
            }
            .store(in: &cancellables)
    }
}

extension RootViewModel {
    enum RootScreen: Equatable {
        case launchScreen
        case periodTracker
        case onboarding
        case forceUpdate(String)
    }
}

// MARK: Routing
extension RootViewModel {
    func openAppStore(_ applink: String) {
        router.presentAppStore(applink)
    }

    func requestIdfa() {
        idfaRequestService.requestIDFATracking()
    }
}
