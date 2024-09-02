//  
//  RootInitializationServiceImpl.swift
//  Fasting
//
//  Created by Amakhin Ivan on 07.08.2024.
//

import Dependencies
import RxSwift
import UIKit
import Combine

class RootInitializationServiceImpl: RootInitializationService {
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.newSubscriptionService) private var newSubscriptionService
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.w2WLoadingService) private var w2WLoadingService

    var rootSetup: AnyPublisher<RootSetup, Never> {
        newSubscriptionService.hasSubscription
            .dropFirst()
            .combineLatest(forceUpdateObservable.asPublisherWithoutError(), isW2WLoaded)
            .prefix(1)
            .map(with: self) { this, args in
                let arguments = (hasSubscription: args.0, forceUpdateArgs: args.1, w2wLoaded: args.2)
                arguments.w2wLoaded
                return RootSetup(
                    rootScreen: this.rootScreen(
                        shouldShowForceUpdate: arguments.forceUpdateArgs.shouldShowForceUpdate,
                        forceUpdateLink: arguments.forceUpdateArgs.appLink
                    ),
                    hasSubscription: arguments.hasSubscription,
                    w2wLoaded: arguments.w2wLoaded
                )
            }
            .eraseToAnyPublisher()
    }

    private var isW2WLoaded: AnyPublisher<Bool, Never> {
        w2WLoadingService.isLoaded
            .filter { $0 == true }
            .eraseToAnyPublisher()
    }

    private var forceUpdateObservable: Observable<(shouldShowForceUpdate: Bool, appLink: String)> {
        appCustomization.forceUpdateAppVersion
            .flatMap(with: self) { this, version -> Observable<(shouldShowForceUpdate: Bool, appLink: String)> in
                this.appCustomization.appStoreLink.map {
                    (shouldShowForceUpdate: !Bundle.lessOrEqualToCurrentVersion(version),
                     appLink: $0)
                }
            }
    }

    private func rootScreen(shouldShowForceUpdate: Bool, forceUpdateLink: String) -> RootViewModel.RootScreen {
        if shouldShowForceUpdate {
            return .forceUpdate(forceUpdateLink)
        }
        return cloudStorage.onboardingIsFinished ? .fasting : .onboarding
    }
}
