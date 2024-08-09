//  
//  TrialPaywallViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 05.08.2024.
//

import AppStudioNavigation
import AppStudioUI
import AppStudioServices
import StoreKit
import AppStudioStyles
import Dependencies

class TrialPaywallViewModel: BasePaywallViewModel<TrialPaywallOutput> {
    @Dependency(\.accountProvider) private var accountProvider

    var router: TrialPaywallRouter!

    @Published private(set) var product: Product?

    var price: String {
        product?.displayPrice ?? ""
    }

    var trialPeriod: String {
        product?.subscription?.introductoryOffer?.period.debugDescription.lowercased() ?? ""
    }

    init(input: TrialPaywallInput, output: @escaping TrialPaywallOutputBlock) {
        super.init(output: output)
        // initialization code here
        paywallContext = .trialOffer
        accountId = accountProvider.accountId
        subscribeToStatus()
        initializeRemoteSubscriptions()
    }

    func handle(_ event: TrialProductPaywallScreen.Event) {
        switch event {
        case .close:
            paywallClosed()
            output(.close)
        case .restore:
            restore()
        case .subscribe:
            if let product {
                subscribe(id: product.id)
            }
        case .appeared:
            paywallAppeared()
        }
    }

    private func subscribeToStatus() {
        $status
            .sink(with: self) { this, status in
                switch status {
                case .none: break
                case .subscribed:
                    this.router.dismissBanner()
                    this.output(.subscribed)
                case .showAlert:
                    this.showRestoreErrorAlert()
                case .showProgress:
                    this.router.presentProgressView()
                case .hideProgress:
                    this.router.dismissBanner()
                }
            }
            .store(in: &cancellables)
    }

    private func initializeRemoteSubscriptions() {
        $subscriptions
            .sink(with: self) { this, products in
                this.product = products.first(where: { $0.id == "com.municorn.Fasting.yearly_3d_trial_exp_7" })
            }
            .store(in: &cancellables)
    }

    private func showRestoreErrorAlert() {
        let alertTitle = NSLocalizedString("PaywallDetailsScreen.errorSubscription",
                                           comment: "error subscription status")
        router.present(systemAlert: Alert(title: alertTitle, message: nil, actions: []))
    }
}
