//
//  SubscriptionServiceInitializer.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//
import AppStudioSubscriptions
import Dependencies
import RxSwift

final class SubscriptionServiceInitializer: AppInitializer {
    @Dependency(\.appStudioSubscription) private var appStudioSubscription
    @Dependency(\.appStudioSubscriptionDelegate) private var appStudioSubscriptionDelegate
    @Dependency(\.messengerService) private var messenger
    private var disposeBag = DisposeBag()

    func initialize() {
        appStudioSubscription.initialize(
            dependencies: dependencies,
            delegate: appStudioSubscriptionDelegate
        ) { subscriptionService in
            register(subscriptionService: subscriptionService)
            subscribeMessages()
        }
    }

    private func subscribeMessages() {
        messenger.onReplayMessage(AppActivationMessage.self)
            .asVoid()
            .subscribe(onNext: appStudioSubscription.didAppActivation)
            .disposed(by: disposeBag)

        messenger.onReplayMessage(WillTerminateMessage.self)
            .asVoid()
            .subscribe(onNext: appStudioSubscription.didAppWillTerminate)
            .disposed(by: disposeBag)

        messenger.onReplayMessage(UpdateSubscriptionMessage.self)
            .asVoid()
            .subscribe(onNext: appStudioSubscription.didUpdateSubscriptionMessage)
            .disposed(by: disposeBag)

        messenger.onReplayMessage(CloudStoragesUpdateRequestMessage.self)
            .asVoid()
            .subscribe(onNext: appStudioSubscription.didCloudStoragesUpdateRequestMessage)
            .disposed(by: disposeBag)

        appStudioSubscription.didAppActivation()
    }

    private func register(subscriptionService: SubscriptionService) {
        SubscriptionServiceKey.liveValue = subscriptionService
    }

    private var dependencies: AppStudioSubscriptionDependencies {
        @Dependency(\.storageService) var storageService
        @Dependency(\.cloudStorage) var cloudStorage
        @Dependency(\.concurrentQueue) var concurrentQueue
        @Dependency(\.serialQueue) var serialQueue
        @Dependency(\.subscriptionApi) var subscriptionApi

        return AppStudioSubscriptionDependencies(storageService: storageService,
                                                 cloudStorage: cloudStorage,
                                                 logger: nil,
                                                 serialQueue: serialQueue,
                                                 concurrentQueue: concurrentQueue,
                                                 subscriptionApi: subscriptionApi)
    }
}
