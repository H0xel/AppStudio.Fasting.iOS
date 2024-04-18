//
//  BasePaywallViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 12.04.2024.
//

import AppStudioUI
import AppStudioStyles
import AppStudioModels
import SwiftUI
import AppStudioSubscriptions
import Dependencies
import RxSwift
import AppStudioServices
import MunicornFoundation

extension BasePaywallViewModel {
    enum Status {
        case initial
        case subscribed
        case showAlert
        case showProgress
        case hideProgress
        case subscriptionsLoaded
    }
}

class BasePaywallViewModel<OutputEventType>: BaseViewModel<OutputEventType> {

//    @Published var selectedProduct: SubscriptionProduct = .mock
    @Published var status: Status = .initial
    @Published var hasSubscription = false
    @Published var isTrialAvailable = false

    var subscriptions: [Subscription] = []
    var shortestSubscription: Subscription?
    var paywallContext: PaywallContext?

    private var selectedProductIdentifier: String?

    @Dependency(\.messengerService) private var messenger
    @Dependency(\.productIdsService) private var productIdsService
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.trackerService) var trackerService
    @Dependency(\.analyticKeyStore) var analyticKeyStore
    @Dependency(\.subscriptionService) var subscriptionService

    private let disposeBag = DisposeBag()

    override init(output: @escaping ViewOutput<OutputEventType>) {
        super.init(output: output)
        subscribeToLoadingState()
        subscribeToMayUseAppStatus()
        subscribeToFinishTransactionState()
        subscribeToRestoreChange()
        loadAvailableProducts()
        subscribeToHasSubscription()
    }
    
    func subscribe(id: String) {
        guard let subscription = subscriptions.first(where: { $0.productIdentifier == id }), let paywallContext else {
            return
        }
        selectedProductIdentifier = id
        subscriptionService.purchase(subscription: subscription, context: paywallContext.rawValue)
        trackerService.track(.tapSubscribe(context: paywallContext,
                                           productId: subscription.productIdentifier,
                                           type: .main,
                                           afId: analyticKeyStore.currentAppsFlyerId))
        status = .showProgress
    }

    private func subscribeToLoadingState() {
        messenger.onMessage(SubscriptionStateMessage.self)
            .map { $0.stateChangeType }
            .asDriver()
            .drive(with: self) { this, state in
                switch state {
                case .error:
                    this.status = .hideProgress
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
//                    this.showRestoreErrorAlert()
                    this.status = .showAlert
                    if let paywallContext = this.paywallContext {
                        this.trackRestoreFinishedEvent(result: .fail, context: paywallContext)
                    }
                case .restored:
                    if let paywallContext = this.paywallContext {
                        this.trackRestoreFinishedEvent(result: .success, context: paywallContext)
                    }
                }
                this.status = .hideProgress
            }
            .disposed(by: disposeBag)
    }

    private func subscribeToMayUseAppStatus() {
        subscriptionService.actualSubscription
            .filter { $0.isUnlimited }
            .take(1)
            .asDriver()
            .drive(with: self) { this, _ in
                this.status = .subscribed
//                this.output(.subscribed)
//                this.isLoading = false
            }
            .disposed(by: disposeBag)
    }

    private func subscribeToHasSubscription() {
        subscriptionService.hasSubscriptionObservable
            .distinctUntilChanged()
            .asDriver()
            .drive(with: self) { this, hasSubscription in
                this.hasSubscription = hasSubscription
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

        let ids = [
            "com.municorn.Fasting.weekly_exp_7",
            "com.municorn.Fasting.3monthly_exp_7",
            "com.municorn.Fasting.yearly_exp_7"
        ]

        Observable.combineLatest(subscriptionService.subscriptionProducts,
                                 productIdsService.paywallProductIds)
            .map { subscriptions, availableIds in
                subscriptions
                    .filter { ids.contains($0.productIdentifier) }
                    .sorted { $0.duration.timeInterval < $1.duration.timeInterval }
            }
            .asDriver()
            .drive(with: self) { this, subscriptions in
                this.subscriptions = subscriptions
                this.shortestSubscription = subscriptions.first
                this.checkIsTrialAvailable()
                this.status = .subscriptionsLoaded
            }
            .disposed(by: disposeBag)
    }

    private func checkIsTrialAvailable() {
        guard let trial = subscriptions.first(where: { $0.isTrial }) else {
//            assignProducts()
            return
        }
        subscriptionService.isTrialAvailable(for: trial)
            .asDriver()
            .drive(with: self) { this, isAvailable in
                this.isTrialAvailable = isAvailable
//                this.assignProducts()
            }
            .disposed(by: disposeBag)
    }

//    private func assignProducts() {
//        let products = subscriptions.map {
//            $0.asSubscriptionProduct(promotion: promotionText(for: $0))
//        }
//        self.products = products
//
//        if let bestValueProduct = subscriptions.first(where: { $0.duration == .year }) {
//            selectedProduct = bestValueProduct.asSubscriptionProduct(
//                for: .year,
//                promotion: promotionText(for: bestValueProduct))
//        }
//    }
}

// MARK: - Track analytics events

private extension BasePaywallViewModel {

    func trackPaywallShown() {
        guard let paywallContext else { return }
        trackerService.track(.paywallShown(context: paywallContext,
                                           type: .main,
                                           afId: analyticKeyStore.currentAppsFlyerId))
    }

    func trackRestoreFinishedEvent(result: RestoreResult, context: PaywallContext) {
        trackerService.track(.restoreFinished(context: context,
                                              result: result,
                                              afId: analyticKeyStore.currentAppsFlyerId))
    }

    func trackPurchaseFinished(transaction: FinishTransactionMessage) {
        guard let paywallContext, let selectedProductIdentifier else { return }
        trackerService.track(.purchaseFinished(context: paywallContext,
                                               result: transaction.result,
                                               message: transaction.error?.localizedDescription ?? "",
                                               productId: selectedProductIdentifier,
                                               type: .main,
                                               afId: analyticKeyStore.currentAppsFlyerId))

        if transaction.state == .purchased && !cloudStorage.afFirstSubscribeTracked {
            trackerService.track(.afFirstSubscribe)
            cloudStorage.afFirstSubscribeTracked = true
        }
    }
}

class TestableViewModel: BasePaywallViewModel<MultiplePaywallOutput> {
    @Published private var input: MultiplePaywallInput

    init(input: MultiplePaywallInput, output: @escaping MultiplePaywallOutputBlock) {
        self.input = input
        super.init(output: output)
        paywallContext = input.paywallContext
    }
}
