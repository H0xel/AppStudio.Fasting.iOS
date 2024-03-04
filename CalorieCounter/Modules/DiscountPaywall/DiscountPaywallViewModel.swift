//
//  DiscountPaywallViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.02.2024.
//

import AppStudioNavigation
import AppStudioUI
import Foundation
import Combine
import Dependencies
import RxSwift
import AppStudioSubscriptions

enum DiscountPaywallType {
    case timer(DiscountTimerView.ViewData)
    case discount(DiscountPaywallView.ViewData)
    case empty
}

class DiscountPaywallViewModel: BaseViewModel<DiscountPaywallOutput> {
    var router: DiscountPaywallRouter!
    @Published var timeInterval: TimeInterval = .second
    @Published var paywallType: DiscountPaywallType = .empty
    let discountPersent: String
    let context: PaywallContext

    @Dependency(\.subscriptionService) private var subscriptionService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.analyticKeyStore) private var analyticKeyStore
    @Dependency(\.messengerService) private var messenger
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService

    private let paywallInfo: DiscountPaywallInfo
    private let disposeBag = DisposeBag()
    private var subscription: AppStudioSubscriptions.Subscription?
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(input: DiscountPaywallInput, output: @escaping DiscountPaywallOutputBlock) {
        paywallInfo = input.paywallInfo
        discountPersent = "\(input.paywallInfo.discount)%"
        context = input.context
        super.init(output: output)
        subscribeToMayUseAppStatus()
        loadAvailableProducts()
        subscribeToLoadingState()
        subscribeToRestoreChange()
        subscribeToFinishTransactionState()
        updateTimer()
        startTimer()
    }

    func subscribe() {
        guard let subscription else { return }
        subscriptionService.purchase(subscription: subscription, context: context.rawValue)
        trackerService.track(.tapSubscribe(context: context,
                                           productId: subscription.productIdentifier,
                                           afId: analyticKeyStore.currentAppsFlyerId))
        router.presentProgressView()
    }

    func close() {
        output(.close)
        trackerService.track(.tapClosePaywall(context: context))
    }

    func restore() {
        router.presentProgressView()
        subscriptionService.restore()
        trackerService.track(.tapRestorePurchases(context: context,
                                                  afId: analyticKeyStore.currentAppsFlyerId))
    }

    func appeared() {
        trackPaywallShown()
    }

    func updateTimer() {
        guard let interval = discountPaywallTimerService.getCurrentTimer(
            durationInSeconds: paywallInfo.timerDurationInSeconds
        ) else {
            return
        }

        timeInterval = interval
    }

    private func startTimer() {
        Publishers.Merge(timer, Just(.now))
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, _ in
                this.timeInterval -= .second

                if this.timeInterval.seconds <= 0 {
                    this.discountPaywallTimerService.setAvailableDiscount(data: nil)
                    this.timer.upstream.connect().cancel()
                }
            }
            .store(in: &cancellables)
    }

    private func loadAvailableProducts() {
        subscriptionService.subscriptionProducts
            .asDriver()
            .drive(with: self) { this, subscriptions in
                if let subscription = subscriptions
                    .first(where: { $0.productIdentifier == this.paywallInfo.productId }) {
                    this.paywallType = .init(paywallInfo: this.paywallInfo, subscription: subscription)
                    this.subscription = subscription
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
                case .success:
                    this.discountPaywallTimerService.setAvailableDiscount(data: nil)
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
    }

    private func subscribeToMayUseAppStatus() {
        subscriptionService.actualSubscription
            .filter { $0.isUnlimited }
            .take(1)
            .asDriver()
            .drive(with: self) { this, _ in
                this.output(.subscribe)
                this.router.dismissBanner()
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
                    this.trackRestoreFinishedEvent(result: .fail, context: this.context)
                case .restored:
                    this.trackRestoreFinishedEvent(result: .success, context: this.context)
                }
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

    private func showRestoreErrorAlert() {
        let alertTitle = NSLocalizedString("PaywallDetailsScreen.errorSubscription",
                                             comment: "error subscription status")
        router.present(systemAlert: Alert(title: alertTitle, message: nil, actions: []))
    }
}

// MARK: - Track analytics events

private extension DiscountPaywallViewModel {

    func trackPaywallShown() {
        trackerService.track(.paywallShown(context: context,
                                           afId: analyticKeyStore.currentAppsFlyerId))
    }

    func trackRestoreFinishedEvent(result: RestoreResult, context: PaywallContext) {
        trackerService.track(.restoreFinished(context: context,
                                              result: result,
                                              afId: analyticKeyStore.currentAppsFlyerId))
    }

    func trackPurchaseFinished(transaction: FinishTransactionMessage) {
        guard let subscription else {
            return
        }
        trackerService.track(.purchaseFinished(context: context,
                                               result: transaction.result,
                                               message: transaction.error?.localizedDescription ?? "",
                                               productId: subscription.productIdentifier,
                                               afId: analyticKeyStore.currentAppsFlyerId))
    }
}
