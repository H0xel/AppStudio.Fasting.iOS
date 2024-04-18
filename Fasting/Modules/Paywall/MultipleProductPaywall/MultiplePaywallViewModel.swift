//  
//  MultiplePaywallViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 11.04.2024.
//

import AppStudioNavigation
import AppStudioUI
import AppStudioStyles
import AppStudioModels
import SwiftUI
import AppStudioSubscriptions
import Dependencies
import RxSwift
import AppStudioServices
import MunicornFoundation

class MultiplePaywallViewModel: BasePaywallViewModel<MultiplePaywallOutput> {
    var router: MultiplePaywallRouter!

    @Published var selectedProduct: SubscriptionProduct?
    private let context: PaywallContext

    init(input: MultiplePaywallInput, output: @escaping MultiplePaywallOutputBlock) {
        context = input.paywallContext
        super.init(output: output)
        paywallContext = input.paywallContext
        subscribeToStatus()
    }

    var popularProduct: SubscriptionProduct {
        guard let subscription = subscriptions.first(where: { $0.duration == .threeMonth }) else {
            return .empty
        }
        return subscription.asSubscriptionProduct(for: .threeMonth, promotion: promotionText(for: subscription))
    }

    var bestValueProduct: SubscriptionProduct {
        guard let subscription = subscriptions.first(where: { $0.duration == .year }) else {
            return .empty
        }

        return subscription.asSubscriptionProduct(for: .year, promotion: promotionText(for: subscription))
    }

    var weeklySubscription: SubscriptionProduct {
        guard let subscription = subscriptions.first(where: { $0.duration == .week }) else {
            return .empty
        }
        return subscription.asSubscriptionProduct(promotion: promotionText(for: subscription))
    }

    func handle(_ event: MultipleProductPaywallScreen.Event) {
        switch event {
        case .close:
            trackerService.track(.tapClosePaywall(context: context))
            output(.close)
        case .restore:
            router.presentProgressView()
            subscriptionService.restore()
            trackerService.track(.tapRestorePurchases(context: context, afId: analyticKeyStore.currentAppsFlyerId))
        case .subscribe:
            subscribe(id: selectedProduct?.id ?? "")
        case .appeared:
            trackPaywallShown()
        }
    }

    private func subscribeToStatus() {
        $status
            .sink(with: self) { this, status in
                switch status {
                case .initial:
                    this.router.dismissBanner()
                case .subscribed:
                    this.output(.subscribed)
                case .showAlert:
                    this.showRestoreErrorAlert()
                case .showProgress:
                    this.router.presentProgressView()
                case .hideProgress:
                    this.router.dismissBanner()
                case .subscriptionsLoaded:
                    if let bestValueProduct = this.subscriptions.first(where: { $0.duration == .year }) {
                        this.selectedProduct = bestValueProduct.asSubscriptionProduct(
                            for: .year,
                            promotion: this.promotionText(for: bestValueProduct))
                    }
                }
            }
            .store(in: &cancellables)
    }

    private func showRestoreErrorAlert() {
        let alertTitle = NSLocalizedString("PaywallDetailsScreen.errorSubscription",
                                           comment: "error subscription status")
        router.present(systemAlert: Alert(title: alertTitle, message: nil, actions: []))
    }
}

extension MultiplePaywallViewModel {
    private func promotionText(for subscription: Subscription) -> String? {
        guard subscription.productIdentifier != shortestSubscription?.productIdentifier,
              let price = subscription.pricePerWeek?.value.doubleValue,
              let shortestSubscriptionPrice = shortestSubscription?.pricePerWeek?.value.doubleValue,
              shortestSubscriptionPrice > 0 else {
            return nil
        }
        let percent = Int(price * 100 / shortestSubscriptionPrice)
        let saveText = NSLocalizedString("Paywall.savePercent", comment: "Save precent")
        return "\(String(format: saveText, 100 - percent))%"
    }
}

private extension Subscription {
    func asSubscriptionProduct(for duration: SubscriptionDuration = .week, promotion: String?) -> SubscriptionProduct {
        .init(id: productIdentifier,
              title: localizedTitle,
              titleDetails: formattedPrice ?? "",
              durationTitle: duration.title,
              pricePerWeek: localedPrice(for: .week) ?? "",
              price: localedPrice(for: duration) ?? "",
              promotion: promotion)
    }
}

private extension MultiplePaywallViewModel {
    func trackPaywallShown() {
        trackerService.track(.paywallShown(context: context,
                                           type: .main,
                                           afId: analyticKeyStore.currentAppsFlyerId))
    }
}
