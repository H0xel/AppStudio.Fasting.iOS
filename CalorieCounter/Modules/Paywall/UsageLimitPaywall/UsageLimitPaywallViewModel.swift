//
//  UsageLimitPaywallViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 11.04.2024.
//

import AppStudioModels
import NewAppStudioSubscriptions
import Dependencies
import AppStudioServices
import AppStudioStyles
import AppStudioNavigation
import AppStudioUI
import StoreKit

class UsageLimitPaywallViewModel: BasePaywallViewModel<PaywallScreenOutput> {
    @Dependency(\.newSubscriptionService) private var newSubscriptionService
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.productIdsService) private var productIdsService

    var router: PaywallRouter!
    @Published var selectedProduct: SubscriptionProduct?

    private var paywallSubscriptions: [Product] = []

    init(input: PaywallScreenInput, output: @escaping ViewOutput<PaywallScreenOutput>) {
        super.init(output: output)
        paywallContext = input.paywallContext
        subscribeToStatus()
        initializeRemoteSubscriptions()
    }

    var popularProduct: SubscriptionProduct {
        guard let subscription = paywallSubscriptions.first(where: {
            $0.subscription?.subscriptionPeriod.duration == .threeMonth
        }) else {
            return .empty
        }
        return subscription.asSubscriptionProduct(for: .threeMonth, promotion: promotionText(for: subscription))
    }

    var bestValueProduct: SubscriptionProduct {
        guard let subscription = paywallSubscriptions.first(where: {
            $0.subscription?.subscriptionPeriod.duration == .year
        }) else {
            return .empty
        }

        return subscription.asSubscriptionProduct(for: .year, promotion: promotionText(for: subscription))
    }

    var weeklySubscription: SubscriptionProduct {
        guard let subscription = paywallSubscriptions.first(where: {
            $0.subscription?.subscriptionPeriod.duration == .week
        }) else {
            return .empty
        }
        return subscription.asSubscriptionProduct(promotion: nil)
    }

    func handle(_ event: MultipleProductPaywallScreen.Event) {
        switch event {
        case .close:
            paywallClosed()
            output(.close)
        case .restore:
            restore()
        case .subscribe:
            if let selectedProduct {
                subscribe(id: selectedProduct.id)
            }
        case .appeared:
            paywallAppeared()
        case .presentTermsOfUse:
            guard let url = URL(string: GlobalConstants.termsOfUse) else {
                return
            }
            router.open(url: url)
        case .presentPrivacyPolicy:
            guard let url = URL(string: GlobalConstants.privacyPolicy) else {
                return
            }
            router.open(url: url)
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

    private func showRestoreErrorAlert() {
        let alertTitle = NSLocalizedString("PaywallDetailsScreen.errorSubscription",
                                           comment: "error subscription status")
        router.present(systemAlert: Alert(title: alertTitle, message: nil, actions: []))
    }

    private func initializeRemoteSubscriptions() {
        $subscriptions
            .setFailureType(to: Error.self)
            .combineLatest(productIdsService.paywallProductIds.asPublisher())
            .sink(with: self,
                  receiveCompletion: { _ in },
                  receiveValue: { this, args in
                let products = args.0
                let productIds = args.1
                this.paywallSubscriptions = products.filter { productIds.contains($0.id) }
                this.selectedProduct = this.bestValueProduct
            })
            .store(in: &cancellables)
    }
}

extension UsageLimitPaywallViewModel {
    private func promotionText(for subscription: Product) -> String? {
        guard let shortestSubscription = paywallSubscriptions.first(
            where: { $0.subscription?.subscriptionPeriod.duration == .week }
        ),
              let price = subscription.pricePerWeek,
              shortestSubscription.id != subscription.id,
              let shortestSubscriptionPrice = shortestSubscription.pricePerWeek,
              shortestSubscriptionPrice > 0 else {
            return nil
        }

        let productPricePerWeek = NSDecimalNumber(decimal: price).doubleValue
        let shortestProductPrice = NSDecimalNumber(decimal: shortestSubscriptionPrice).doubleValue

        let percent = Int(productPricePerWeek * 100 / shortestProductPrice)
        let saveText = NSLocalizedString("Paywall.savePercent", comment: "Save precent")
        return "\(String(format: saveText, 100 - percent))%"
    }
}
