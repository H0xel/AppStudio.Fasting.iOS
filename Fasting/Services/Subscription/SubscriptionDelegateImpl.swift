//
//  AppStudioSubscriptionDelegateImpl.swift
//  AppStudio
//
//  Created by Denis Khlopin on 04.08.2023.
//

import Dependencies
import AppStudioSubscriptions
import AppStudioFoundation
import StoreKit

class SubscriptionDelegateImpl: AppStudioSubscriptionDelegate {
    @Dependency(\.messengerService) private var messenger
    @Dependency(\.productProvider) private var productProvider

    // List of current products
    var productCatalog: ProductCatalog {
        ProductCatalog(products: productProvider.productItems)
    }

    var defaultCurrency: String {
        "USD"
    }

    var appPrefix: String {
        GlobalConstants.applicationPrefix
    }

    func subscriptionPublishRestoreSubscriptionState(state: RestoreSubscriptionState) {
        messenger.publishRestoreSubscriptionStateMessage(sender: self, state: state)
    }

    func subscriptionPublishMayUseStateChanged(mayUseState: MayUseStateType, mayUse: Bool) {
        messenger.publishMayUseStateChangedMessage(sender: self, mayUseState: mayUseState, mayUse: mayUse)
    }

    func subscriptionPublishPurchase() {
        messenger.publishPurchaseMessage(sender: self)
    }

    func subscriptionPublishFinishTransaction(state: SKPaymentTransactionState,
                                              error: SKError?,
                                              context: String?) {
        messenger.publishFinishTransactionMessage(state: state,
                                                  context: PaywallContext(rawValue: context ?? ""),
                                                  sender: self)
    }

    func subscriptionPublishSubscriptionStateChanged(stateChangeType: SubscriptionStateChangeType) {
        messenger.publishSubscriptionStateChanged(sender: self, stateChangeType: stateChangeType)
    }

    func subscriptionPublishUpdateSubscription() {
        messenger.publishUpdateSubscriptionMessage(sender: self)
    }
}
