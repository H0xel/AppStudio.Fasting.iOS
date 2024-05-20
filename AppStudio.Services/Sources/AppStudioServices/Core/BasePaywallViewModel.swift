//
//  BasePaywallViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 12.04.2024.
//

import SwiftUI
import NewAppStudioSubscriptions
import Dependencies
import StoreKit
import AppStudioUI
import MunicornFoundation

public extension BasePaywallViewModel {
    enum Status {
        case subscribed
        case showAlert
        case showProgress
        case hideProgress
    }
}

open class BasePaywallViewModel<OutputEventType>: BaseViewModel<OutputEventType> {

    @Published public private(set) var status: Status?
    @Published public private(set) var hasSubscription = false

    @Published public private(set) var subscriptions: [Product] = []
    public var paywallContext: PaywallContext?
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.analyticKeyStore) private var analyticKeyStore
    @Dependency(\.newSubscriptionService) private var newSubscriptionService

    public override init(output: @escaping ViewOutput<OutputEventType>) {
        super.init(output: output)
        initializeSubscriptions()
        subscribeToHasSubscription()
    }

    public func subscribe(id: String) {
        guard let subscription = subscriptions.first(where: { $0.id == id }), let paywallContext else {
            return
        }

        status = .showProgress

        trackerService.track(.tapSubscribe(context: paywallContext,
                                           productId: subscription.id,
                                           type: .main,
                                           afId: analyticKeyStore.currentAppsFlyerId))

        Task { @MainActor in
            do {
                let purchaseResult = try await newSubscriptionService.purchase(subscription,
                                                                               context: paywallContext.rawValue)

                status = .hideProgress
                if purchaseResult.isPurchased {
                    status = .subscribed
                }

                trackPurchaseFinished(productId: subscription.id,
                                      purchasedResult: purchaseResult,
                                      error: nil)
            } catch {
                status = .hideProgress
                trackPurchaseFinished(productId: subscription.id,
                                      purchasedResult: nil,
                                      error: error.localizedDescription)
            }
        }
    }

    public func restore() {
        Task { @MainActor in
            status = .showProgress
            do {
                try await newSubscriptionService.restore()
                status = .hideProgress
                trackRestoreFinishedEvent(result: .success)
            } catch {
                status = .hideProgress
                trackRestoreFinishedEvent(result: .fail)
            }
        }
    }

    public func paywallAppeared() {
        trackPaywallShown()
    }
    
    public func paywallClosed() {
        trackPaywallClosed()
    }

    private func subscribeToHasSubscription() {
        newSubscriptionService.hasSubscription
            .receive(on: DispatchQueue.main)
            .assign(to: &$hasSubscription)
    }

    private func initializeSubscriptions() {
        newSubscriptionService.products
            .assign(to: &$subscriptions)
    }
}

// MARK: - Track analytics events

private extension BasePaywallViewModel {

    func trackPaywallClosed() {
        guard let paywallContext else { return }
        trackerService.track(.tapClosePaywall(context: paywallContext))
    }

    func trackPaywallShown() {
        guard let paywallContext else { return }
        trackerService.track(.paywallShown(context: paywallContext,
                                           type: .main,
                                           afId: analyticKeyStore.currentAppsFlyerId))
    }

    func trackRestoreFinishedEvent(result: RestoreResult) {
        guard let paywallContext else { return }
        trackerService.track(.restoreFinished(context: paywallContext,
                                              result: result,
                                              afId: analyticKeyStore.currentAppsFlyerId))
    }

    func trackPurchaseFinished(productId: String,
                               purchasedResult: Product.PurchaseResult?,
                               error: String?) {
        guard let paywallContext else { return }
        trackerService.track(.purchaseFinished(context: paywallContext,
                                               result: purchasedResult?.result ?? "failed",
                                               message: error ?? "",
                                               productId: productId,
                                               type: .main,
                                               afId: analyticKeyStore.currentAppsFlyerId))

        if purchasedResult?.isPurchased == true && !cloudStorage.afFirstSubscribeTracked {
            trackerService.track(.afFirstSubscribe)
            cloudStorage.afFirstSubscribeTracked = true
        }
    }
}

private let afFirstSubscribeKey = "iCloud.afFirstSubscribeKey"

private extension CloudStorage {
    var afFirstSubscribeTracked: Bool {
        get { get(key: afFirstSubscribeKey, defaultValue: false) }
        set { set(key: afFirstSubscribeKey, value: newValue) }
    }
}
