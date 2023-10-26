//
//  PaywallServiceImpl.swift
//  AppStudio
//
//  Created by Denis Khlopin on 15.08.2023.
//

import RxSwift
import AppStudioSubscriptions
import Dependencies
import AppStudioNavigation
import MunicornFoundation

class PaywallServiceImpl: PaywallService {
    @Dependency(\.subscriptionService) private var subscriptionService
    @Dependency(\.cloudStorage) private var cloudStorage

    private let disposeBag = DisposeBag()
    @Atomic private var hasSubscription = false
    @Atomic private var isPresenting = false

    func hasSubscription() async -> Bool {
        hasSubscription
    }

    @MainActor
    func presentPaywallIfNeeded(paywallContext: PaywallServiceContext, router: Router) async -> Bool {
        // TODO: SETUP you can add additional conditions when paywall no need to show
        if hasSubscription {
            return true
        }
        if isPresenting {
            return hasSubscription
        }
        isPresenting = true
        let isSubscribed = await presentPaywall(paywallContext, router: router)
        isPresenting = false

        await router.dismiss()

        return isSubscribed
    }

    @MainActor
    private func presentPaywall(_ paywallContext: PaywallServiceContext, router: Router) async -> Bool {
        return await withCheckedContinuation { continuation in
            let route = PaywallRoute(navigator: router.navigator, input: .onboarding) { output in
                switch output {
                case .close:
                    continuation.resume(returning: false)
                case .subscribed:
                    continuation.resume(returning: true)
                }
            }
            router.present(route: route)
        }
    }
}

extension PaywallServiceImpl: AppInitializer {
    func initialize() {
        subscriptionService.hasSubscriptionObservable
            .asDriver()
            .drive(with: self) { this, mayUseApp in
                this.hasSubscription = mayUseApp
            }
            .disposed(by: disposeBag)
    }
}
