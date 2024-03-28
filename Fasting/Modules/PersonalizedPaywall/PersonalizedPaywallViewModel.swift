//  
//  PersonalizedPaywallViewModel.swift
//  Fasting
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
    @Published var isTrialAvailable = false
    @Published var canDisplayCloseButton = false
    @Published private var highestPriceSubscription: SubscriptionProduct?
    @Published private var discountPaywallInfo: DiscountPaywallInfo?
    let input: PersonalizedPaywallInput

    var router: PersonalizedPaywallRouter!

    private let disposeBag = DisposeBag()
    private var subscriptions: [Subscription] = []
    @Dependency(\.subscriptionService) private var subscriptionService
    @Dependency(\.messengerService) private var messenger
    @Dependency(\.productIdsService) private var productIdsService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.analyticKeyStore) private var analyticKeyStore
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.promoPaywallService) private var promoPaywallService
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService
    @Dependency(\.cloudStorage) private var cloudStorage

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
        subscribeForAvailableDiscountPaywall()
    }

    private var headerDescription: String {
        promoPaywallService.pricingExperimentSKProduct?.paywallDescription(isTrialAvailable: isTrialAvailable) ?? ""
    }

    var promoViewData: PersonalizedPromotionalOfferView.ViewData? {
        guard let skProduct = promoPaywallService.pricingExperimentSKProduct,
              let promoPrice = skProduct.promoPriceLocale,
              let promoDuration = skProduct.promoDuration else {
            return nil
        }
        return .init(duration: promoDuration, price: promoPrice)
    }

    var headerViewData: PersonalizedTitleView.ViewData {
        .init(title: input.title,
              description: headerDescription)
    }

    func subscribe() {
        guard let subscription = subscriptions.first(
            where: { $0.productIdentifier == promoPaywallService.pricingExperimentSKProduct?.productIdentifier }
        ) else {
            return
        }
        subscriptionService.purchase(subscription: subscription, context: context)
        trackerService.track(.tapSubscribe(context: .onboarding,
                                           productId: subscription.productIdentifier,
                                           type: .main,
                                           afId: analyticKeyStore.currentAppsFlyerId))
        router.presentProgressView()
    }

    func close() {
        guard canDisplayCloseButton else { return }
        trackerService.track(.tapClosePaywall(context: .onboarding))

        if let discountPaywallInfo {
            output(.showDiscountPaywall(.init(context: .discountOnboarding, paywallInfo: discountPaywallInfo)))
            return
        }

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

    private func subscribeForAvailableDiscountPaywall() {
        discountPaywallTimerService.discountAvailable
            .assign(to: &$discountPaywallInfo)
    }

    private func subscribeToDiscountPaywallState() {
        subscriptionService.hasSubscriptionObservable
            .distinctUntilChanged()
            .flatMap(with: self, { this, hasSubscription -> Observable<(hasSubscription: Bool,
                                                                        discountPaywallInfo: DiscountPaywallInfo?)> in
                this.appCustomization.discountPaywallExperiment
                    .map { (hasSubscription, $0) }
            })
            .asDriver()
            .drive(with: self) { this, args in
                if let discountPaywallInfo = args.discountPaywallInfo {
                    this.discountPaywallTimerService.registerPaywall(info: discountPaywallInfo)
                }
            }
            .disposed(by: disposeBag)
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
        subscriptionService.subscriptionProducts
            .asDriver()
            .drive(with: self) { this, subscriptions in
                this.subscriptions = subscriptions
                this.checkIsTrialAvailable()
            }
            .disposed(by: disposeBag)
    }

    private func checkIsTrialAvailable() {
        guard let trial = subscriptions.first(
            where: { $0.productIdentifier == promoPaywallService.pricingExperimentSKProduct?.productIdentifier }
        ) else {
            return
        }
        subscriptionService.isTrialAvailable(for: trial)
            .asDriver()
            .drive(with: self) { this, isAvailable in
                this.isTrialAvailable = isAvailable
            }
            .disposed(by: disposeBag)
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
                                           type: .main,
                                           afId: analyticKeyStore.currentAppsFlyerId))
    }

    func trackRestoreFinishedEvent(result: RestoreResult, context: PaywallContext) {
        trackerService.track(.restoreFinished(context: context,
                                              result: result,
                                              afId: analyticKeyStore.currentAppsFlyerId))
    }

    func trackPurchaseFinished(transaction: FinishTransactionMessage) {
        guard let productID = promoPaywallService.pricingExperimentSKProduct?.productIdentifier  else {
            return
        }
        trackerService.track(.purchaseFinished(context: .onboarding,
                                               result: transaction.result,
                                               message: transaction.error?.localizedDescription ?? "",
                                               productId: productID,
                                               type: .main,
                                               afId: analyticKeyStore.currentAppsFlyerId))

        if transaction.state == .purchased && !cloudStorage.afFirstSubscribeTracked {
            trackerService.track(.afFirstSubscribe)
            cloudStorage.afFirstSubscribeTracked = true
        }
    }
}
