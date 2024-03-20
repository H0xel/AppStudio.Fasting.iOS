//  
//  PersonalizedPaywallViewModel.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 06.12.2023.
//

import RxSwift
import SwiftUI
import Dependencies
import AppStudioUI
import AppStudioNavigation
import AppStudioSubscriptions
import AppStudioServices

class PersonalizedPaywallViewModel: BaseViewModel<PersonalizedPaywallOutput> {
    @Published var products: [SubscriptionProduct] = []
    @Published var selectedProduct: SubscriptionProduct?
    @Published var isTrialAvailable = false
    @Published var canDisplayCloseButton = false
    @Published private var highestPriceSubscription: SubscriptionProduct?
    let input: PersonalizedPaywallInput

    var router: PersonalizedPaywallRouter!

    private let disposeBag = DisposeBag()
    private var chipestSubscription: Subscription?
    private var subscriptions: [Subscription] = []
    @Dependency(\.subscriptionServiceAdapter) private var subscriptionService
    @Dependency(\.messengerService) private var messenger
    @Dependency(\.productIdsService) private var productIdsService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.analyticKeyStore) private var analyticKeyStore
    @Dependency(\.appCustomization) private var appCustomization

    private let context = "personalizedPaywall"

    init(input: PersonalizedPaywallInput, output: @escaping PersonalizedPaywallOutputBlock) {
        self.input = input
        super.init(output: output)
        configureCloseButton()
        subscribeToLoadingState()
        subscribeToMayUseAppStatus()
        subscribeToFinishTransactionState()
        subscribeToRestoreChange()
        loadAvailableProducts()
    }

    private var headerDescription: String {
        let title = isTrialAvailable
        ? NSLocalizedString("Paywall.tryForFree", comment: "")
        : NSLocalizedString("PersonalizedPaywall.getPlus", comment: "")
        return String(format: title, selectedProduct?.titleDetails ?? "")
    }

    var headerViewData: PersonalizedTitleView.ViewData {
        .init(title: input.title,
              description: headerDescription)
    }

    func subscribe(duration: SubscriptionDuration) {
        guard let subscription = subscriptions.first(where: { $0.duration == duration }),
              let product = products.first(where: { $0.id == subscription.productIdentifier }) else {
            return
        }
        selectedProduct = product
        subscribe()
    }

    func subscribe() {
        guard let subscription = subscriptions.first(where: { $0.productIdentifier == selectedProduct?.id }) else {
            return
        }
        subscriptionService.purchase(subscription: subscription, context: context)
        trackerService.track(.tapSubscribe(context: .onboarding,
                                           productId: subscription.productIdentifier,
                                           afId: analyticKeyStore.currentAppsFlyerId))
        router.presentProgressView()
    }

    func close() {
        guard canDisplayCloseButton else { return }
        trackerService.track(.tapClosePaywall(context: .onboarding))
        output(.close)
    }

    func restore() {
        router.presentProgressView()
        subscriptionService.restore()
        trackerService.track(.tapRestorePurchases(context: .onboarding,
                                                  afId: analyticKeyStore.currentAppsFlyerId))
    }

    func appeared() {
        trackPaywallShown()
    }

    func scrolledDown() {
        canDisplayCloseButton = true
    }

    private func handle(paywallScreenOutput event: PaywallScreenOutput) {
        switch event {
        case .close:
            router.dismiss()
        case .subscribed, .showDiscountPaywall:
            break
        }
    }

    private func subscribeToLoadingState() {
        messenger.onMessage(SubscriptionStateMessage.self)
            .map { $0.stateChangeType }
            .asDriver()
            .drive(with: self) { this, state in
                switch state {
                case .error:
                    this.router.dismissBanner()
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }

    private func subscribeToRestoreChange() {
        messenger.onMessage(RestoreSubscriptionStateMessage.self)
            .map { $0.state }
            .asDriver()
            .drive(with: self) { this, state in
                switch state {
                case .failed:
                    this.showRestoreErrorAlert()
                    this.trackRestoreFinishedEvent(result: .fail, context: .onboarding)
                case .restored:
                    this.trackRestoreFinishedEvent(result: .success, context: .onboarding)
                }
                this.router.dismissBanner()
            }
            .disposed(by: disposeBag)
    }

    private func subscribeToMayUseAppStatus() {
        subscriptionService.actualSubscription
            .filter { $0.isUnlimited }
            .take(1)
            .asDriver()
            .drive(with: self) { this, _ in
                this.output(.subscribed)
                this.router.dismissBanner()
            }
            .disposed(by: disposeBag)
    }

    private func subscribeToFinishTransactionState() {
        messenger.onMessage(FinishTransactionMessage.self)
            .distinctUntilChanged()
            .subscribe(with: self) { this, transaction in
                this.trackPurchaseFinished(transaction: transaction)
            }
            .disposed(by: disposeBag)
    }

    private func loadAvailableProducts() {
        Observable.combineLatest(subscriptionService.subscriptionProducts,
                                 productIdsService.productIds)
            .map { subscriptions, availableIds in
                subscriptions
                    .filter { availableIds.contains($0.productIdentifier) }
                    .sorted { (($0.price?.value ?? 0) as Decimal) < (($1.price?.value ?? 0) as Decimal) }
            }
            .asDriver()
            .drive(with: self) { this, subscriptions in
                this.subscriptions = subscriptions
                this.chipestSubscription = subscriptions.first
                this.checkIsTrialAvailable()
            }
            .disposed(by: disposeBag)
    }

    private func checkIsTrialAvailable() {
        guard let trial = subscriptions.first(where: { $0.isTrial }) else {
            assignProducts()
            return
        }
        subscriptionService.isTrialAvailable(for: trial)
            .asDriver()
            .drive(with: self) { this, isAvailable in
                this.isTrialAvailable = isAvailable
                this.assignProducts()
            }
            .disposed(by: disposeBag)
    }

    private func assignProducts() {
        let products = subscriptions.map {
            SubscriptionProduct(id: $0.productIdentifier,
                                title: $0.localizedTitle,
                                titleDetails: $0.formattedPrice ?? "",
                                durationTitle: $0.duration.title,
                                pricePerWeek: "\($0.pricePerWeek?.currency ?? "")\($0.pricePerWeek?.value ?? 0)", 
                                price: "\($0.price?.currency ?? "")\($0.price?.value ?? 0)",
                                promotion: promotionText(for: $0))
        }
        self.products = products
        if let product = products.last {
            highestPriceSubscription = product
        }
        guard let selectedProduct else {
            self.selectedProduct = products.first
            return
        }
        if !products.contains(selectedProduct) {
            self.selectedProduct = products.first
        }
    }

    private func promotionText(for subscription: Subscription) -> String? {
        guard subscription.duration == .year,
              let price = subscription.price,
              let chipestSubscriptionPrice = chipestSubscription?.priceByMonth?.value as? Decimal,
              chipestSubscriptionPrice > 0 else {
            return nil
        }
        let priceForYear = chipestSubscriptionPrice * 12
        let yearSubscriptionPercent = (price.value as Decimal) / priceForYear
        let number = Int(Double(truncating: NSDecimalNumber(decimal: yearSubscriptionPercent)) * 100)
        let saveText = NSLocalizedString("Paywall.savePercent", comment: "Save precent")
        return "\(String(format: saveText, 100 - number))%"
    }

    private func showRestoreErrorAlert() {
        let alertTitle = NSLocalizedString("PaywallDetailsScreen.errorSubscription",
                                             comment: "error subscription status")
        router.present(systemAlert: Alert(title: alertTitle, message: nil, actions: []))
    }

    private func configureCloseButton() {
        Task {
            let delay = try? await appCustomization.closePaywallButtonDelay()
            try await Task.sleep(seconds: Double(delay ?? 3))
            await MainActor.run { [weak self] in
                self?.canDisplayCloseButton = true
            }
        }
    }
}

// MARK: - Track analytics events

private extension PersonalizedPaywallViewModel {

    func trackPaywallShown() {
        trackerService.track(.paywallShown(context: .onboarding,
                                           afId: analyticKeyStore.currentAppsFlyerId))
    }

    func trackRestoreFinishedEvent(result: RestoreResult, context: PaywallContext) {
        trackerService.track(.restoreFinished(context: context,
                                              result: result,
                                              afId: analyticKeyStore.currentAppsFlyerId))
    }

    func trackPurchaseFinished(transaction: FinishTransactionMessage) {
        guard let selectedProduct = selectedProduct else {
            return
        }
        trackerService.track(.purchaseFinished(context: .onboarding,
                                               result: transaction.result,
                                               message: transaction.error?.localizedDescription ?? "",
                                               productId: selectedProduct.id,
                                               afId: analyticKeyStore.currentAppsFlyerId))
    }
}
