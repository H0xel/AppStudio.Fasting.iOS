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
    @Published private var highestPriceSubscription: SubscriptionProduct?
    @Published private var input: PaywallScreenInput

    var router: PaywallRouter!

    private let disposeBag = DisposeBag()
    private var chipestSubscription: Subscription?
    private var subscriptions: [Subscription] = []
    @Dependency(\.subscriptionService) private var subscriptionService
    @Dependency(\.messengerService) private var messenger
    @Dependency(\.productIdsService) private var productIdsService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.storageService) private var storageService

    init(input: PaywallScreenInput, output: @escaping ViewOutput<PaywallScreenOutput>) {
        self.input = input
        super.init(output: output)
        trackPaywallShown()
        subscribeToLoadingState()
        subscribeToMayUseAppStatus()
        subscribeToFinishTransactionState()
        subscribeToRestoreChange()
        loadAvailableProducts()
    }

    var headerDescription: String {
        String(format: input.headerTitles.description, selectedProduct?.titleDetails ?? "")
    }

    var headerTitles: PaywallTitle {
        PaywallTitle(title: input.headerTitles.title,
                     description: headerDescription,
                     subTitle: input.headerTitles.subTitle)
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
                                           type: .main,
                                           afId: storageService.currentAppsFlyerId))
        router.presentProgressView()
    }

    func close() {
        trackerService.track(.tapClosePaywall)
        output(.close)
    }

    func restore() {
        router.presentProgressView()
        subscriptionService.restore()
        trackerService.track(.tapRestorePurchases(context: input.paywallContext,
                                                  afId: storageService.currentAppsFlyerId))
    }

    private func handle(paywallScreenOutput event: PaywallScreenOutput) {
        switch event {
        case .close:
            router.dismiss()
        case .subscribed:
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
                case .success:
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
}

// MARK: - Track analytics events

private extension PaywallViewModel {

    func trackPaywallShown() {
        trackerService.track(.paywallShown(context: input.paywallContext,
                                           type: .main,
                                           afId: storageService.currentAppsFlyerId))
    }

    func trackRestoreFinishedEvent(result: RestoreResult, context: PaywallContext) {
        trackerService.track(.restoreFinished(context: context,
                                              result: result,
                                              afId: storageService.currentAppsFlyerId))
    }

    func trackPurchaseFinished(transaction: FinishTransactionMessage) {
        guard let selectedProduct = selectedProduct else {
            return
        }
        trackerService.track(.purchaseFinished(context: input.paywallContext,
                                               result: transaction.result,
                                               message: transaction.error?.localizedDescription ?? "",
                                               productId: selectedProduct.id,
                                               type: .main,
                                               afId: storageService.currentAppsFlyerId))
    }
}
