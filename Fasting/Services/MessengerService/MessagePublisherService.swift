//
//  MessagePublisherService.swift
//  AppStudio
//
//  Created by Amakhin Ivan on 01.11.2022.
//

import Foundation
import RxSwift
import StoreKit
import AppStudioSubscriptions

protocol MessagePublisherService {
    var eventSubject: PublishSubject<AppStudioMessage> { get }
    var replayEventSubject: ReplaySubject<AppStudioMessage> { get }
    func publish<T: AppStudioMessage>(message: T)
}

extension MessagePublisherService {
    func publish<T: AppStudioMessage>(message: T) {
        eventSubject.onNext(message)
        replayEventSubject.onNext(message)
    }

    func publishAppWillEnterForegroundMessage(sender: Any?) {
        publish(message: AppWillEnterForegroundMessage(sender: sender))
    }

    func publishRestoreSubscriptionStateMessage(sender: Any?, state: RestoreSubscriptionState) {
        publish(message: RestoreSubscriptionStateMessage(sender: sender, state: state))
    }

    func publishMayUseStateChangedMessage(sender: Any?, mayUseState: MayUseStateType, mayUse: Bool) {
        publish(message: MayUseStateChangedMessage(sender: sender,
                                                   mayUseState: mayUseState,
                                                   mayUse: mayUse))
    }

    func publishFinishTransactionMessage(state: SKPaymentTransactionState,
                                         context: PaywallContext?,
                                         error: SKError? = nil,
                                         sender: Any?) {
        publish(message: FinishTransactionMessage(state: state, context: context, error: error, sender: sender))
    }

    func publishPurchaseMessage(sender: Any?) {
        publish(message: PurchaseMessage(sender: sender))
    }

    func publishAppActivationMessage(sender: Any?) {
        publish(message: AppActivationMessage(sender: sender))
    }

    func publishWillTerminateMessage(sender: Any?) {
        publish(message: WillTerminateMessage(sender: sender))
    }

    func publishUpdateSubscriptionMessage(sender: Any?) {
        publish(message: UpdateSubscriptionMessage(sender: sender))
    }

    func publishCloudStoragesUpdateRequestMessage(sender: Any?) {
        publish(message: CloudStoragesUpdateRequestMessage(sender: sender))
    }

    func publishSubscriptionStateChanged(sender: Any?, stateChangeType: SubscriptionStateChangeType) {
        publish(message: SubscriptionStateMessage(sender: sender, stateChangeType: stateChangeType))
    }

    func publishAppInitializedMessage(sender: Any?) {
        publish(message: AppInitializedMessage(sender: sender))
    }

    func publishMigrationFinishedMessage(sender: Any?) {
        publish(message: MigrationFinishedMessage(sender: sender))
    }

    func publishUpdateIdentifiersMessage(sender: Any?) {
        publish(message: UpdateIdentifiersMessage(sender: sender))
    }
}
