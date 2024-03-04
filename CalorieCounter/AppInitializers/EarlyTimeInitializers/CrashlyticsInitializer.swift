//
//  CrashlyticsInitializer.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 18.05.2023.
//

import SwiftUI
import FirebaseCrashlytics
import MunicornFoundation
import Dependencies
import RxSwift

final class CrashlyticsInitializer: AppInitializer {

    @Dependency(\.accountIdProvider) private var accountIdProvider
    @Dependency(\.messengerService) private var messengerService
    @Dependency(\.concurrentQueue) var concurrentQueue
    private let disposeBag = DisposeBag()

    func initialize() {
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(!UIDevice.current.isDebug)
        subscribeToMessages()
    }

    private func subscribeToMessages() {
        let scheduler = ConcurrentDispatchQueueScheduler(queue: concurrentQueue)
        messengerService.onMessage(AppInitializedMessage.self)
            .throttle(.seconds(1), scheduler: scheduler)
            .map { _ in }
            .subscribe(onNext: setUserID)
            .disposed(by: disposeBag)
    }

    private func setUserID() {
        let publicID = accountIdProvider.accountId
        Crashlytics.crashlytics().setUserID(publicID)
    }
}
