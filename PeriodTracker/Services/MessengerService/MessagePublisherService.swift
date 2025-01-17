//
//  MessagePublisherService.swift
//  AppStudio
//
//  Created by Amakhin Ivan on 01.11.2022.
//

import Foundation
import RxSwift
import StoreKit

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

    func publishAppInitializedMessage(sender: Any?) {
        publish(message: AppInitializedMessage(sender: sender))
    }

    func publishMigrationFinishedMessage(sender: Any?) {
        publish(message: MigrationFinishedMessage(sender: sender))
    }

    func publishUpdateIdentifiersMessage(sender: Any?) {
        publish(message: UpdateIdentifiersMessage(sender: sender))
    }

    func publishPushReceivedMessage(push: Push, isInForeground: Bool) {
        publish(message: PushReceivedMessage(push: push, isInForeground: isInForeground))
    }
}
