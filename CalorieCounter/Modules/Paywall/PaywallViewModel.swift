//
//  PaywallViewModel.swift
//  Mileage.iOS
//
//  Created by Руслан Сафаргалеев on 07.08.2023.
//

import RxSwift
import SwiftUI
import Dependencies
import AppStudioUI
import AppStudioNavigation
import AppStudioSubscriptions

class PaywallViewModel: BaseViewModel<PaywallScreenOutput> {
    @Published var products: [SubscriptionProduct] = []
    @Published var selectedProduct: SubscriptionProduct?
    @Published var isTrialAvailable = false
    @Published var canDisplayCloseButton = false
    @Published private var hasSubscription = false
    @Published private var highestPriceSubscription: SubscriptionProduct?
    @Published private var input: PaywallScreenInput
    @Published private var discountPaywallInfo: DiscountPaywallInfo?

    var router: PaywallRouter!

    private let disposeBag = DisposeBag()
    private var shortestSubscription: Subscription?
    private var subscriptions: [Subscription] = []
    @Dependency(\.subscriptionServiceAdapter) private var subscriptionService
    @Dependency(\.messengerService) private var messenger
    @Dependency(\.productIdsService) private var productIdsService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.analyticKeyStore) private var analyticKeyStore
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService

    init(input: PaywallScreenInput, output: @escaping ViewOutput<PaywallScreenOutput>) {
        self.input = input
        super.init(output: output)
        configureCloseButton()
        subscribeToLoadingState()
        subscribeToMayUseAppStatus()
        subscribeToFinishTransactionState()
        subscribeToRestoreChange()
        loadAvailableProducts()
        subscribeToDiscountPaywallState()
        subscribeForAvailableDiscountPaywall()
    }

    var popularProduct: SubscriptionProduct {
        guard let subscription = subscriptions.first(where: { $0.duration == .threeMonth }) else {
            return .mock
        }
        return subscription.asSubscriptionProduct(for: .threeMonth, promotion: promotionText(for: subscription))
    }

    var bestValueProduct: SubscriptionProduct {
        guard let subscription = subscriptions.first(where: { $0.duration == .year }) else {
            return .mock
        }

        return subscription.asSubscriptionProduct(for: .year, promotion: promotionText(for: subscription))
    }

    var weeklySubscription: SubscriptionProduct {
        guard let subscription = subscriptions.first(where: { $0.duration == .week }) else {
            return .mock
        }
        return subscription.asSubscriptionProduct(promotion: promotionText(for: subscription))
    }

    var headerDescription: String {
        let title = isTrialAvailable 
        ? input.headerTitles.description
        : NSLocalizedString("PersonalizedPaywall.getPlus", comment: "")
        return String(format: title, selectedProduct?.titleDetails ?? "")
    }

    var headerTitles: PaywallTitle {
        PaywallTitle(title: input.headerTitles.title,
                     description: headerDescription,
                     subTitle: input.headerTitles.subTitle)
    }

    var context: PaywallContext {
        input.paywallContext
    }

    var bottomInfo: LocalizedStringKey {
        "Paywall.unlockAdvanteges"
    }

    func selectProduct(_ product: SubscriptionProduct) {
        selectedProduct = product
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
        subscriptionService.purchase(subscription: subscription, context: input.paywallContext.rawValue)
        trackerService.track(.tapSubscribe(context: input.paywallContext,
                                           productId: subscription.productIdentifier,
                                           afId: analyticKeyStore.currentAppsFlyerId))
        router.presentProgressView()
    }

    func close() {
        trackerService.track(.tapClosePaywall(context: context))

        if let discountPaywallInfo, context == .onboarding, !hasSubscription {
            output(.showDiscountPaywall(.init(context: .discountOnboarding, paywallInfo: discountPaywallInfo)))
            return
        }

        output(.close)
    }

    func restore() {
        router.presentProgressView()
        subscriptionService.restore()
        trackerService.track(.tapRestorePurchases(context: input.paywallContext,
                                                  afId: analyticKeyStore.currentAppsFlyerId))
    }

    func appeared() {
        trackPaywallShown()
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
                    this.trackRestoreFinishedEvent(result: .fail, context: this.input.paywallContext)
                case .restored:
                    this.trackRestoreFinishedEvent(result: .success, context: this.input.paywallContext)
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

    private func subscribeForAvailableDiscountPaywall() {
        discountPaywallTimerService.discountAvailable
            .assign(to: &$discountPaywallInfo)
    }

    private func subscribeToDiscountPaywallState() {
        subscriptionService.hasSubscriptionObservable
            .distinctUntilChanged()
            .flatMap(with: self, { this, hasSubscription -> Observable<(hasSubscription: Bool, discountPaywallInfo: DiscountPaywallInfo)> in
                this.appCustomization.discountPaywallExperiment
                    .map { (hasSubscription, $0) }
            })
            .asDriver()
            .drive(with: self) { this, args in
                this.discountPaywallTimerService.registerPaywall(info: args.discountPaywallInfo)
                this.hasSubscription = args.hasSubscription
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
                                 productIdsService.paywallProductIds)
            .map { subscriptions, availableIds in
                subscriptions
                    .filter { availableIds.contains($0.productIdentifier) }
                    .sorted { $0.duration.timeInterval < $1.duration.timeInterval }
            }
            .asDriver()
            .drive(with: self) { this, subscriptions in
                this.subscriptions = subscriptions
                this.shortestSubscription = subscriptions.first
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
            $0.asSubscriptionProduct(promotion: promotionText(for: $0))
        }
        self.products = products
        if let product = products.last {
            highestPriceSubscription = product
        }
        guard let selectedProduct else {
            self.selectedProduct = products.first
            return
        }
    }

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

private extension PaywallViewModel {

    func trackPaywallShown() {
        trackerService.track(.paywallShown(context: input.paywallContext,
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
        trackerService.track(.purchaseFinished(context: input.paywallContext,
                                               result: transaction.result,
                                               message: transaction.error?.localizedDescription ?? "",
                                               productId: selectedProduct.id,
                                               afId: analyticKeyStore.currentAppsFlyerId))
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
