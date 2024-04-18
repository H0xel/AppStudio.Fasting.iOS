//  
//  FastingPhaseViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.12.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import Dependencies
import RxSwift

class FastingPhaseViewModel: BaseViewModel<FastingPhaseOutput> {

    @Dependency(\.subscriptionService) private var subscriptionService
    @Dependency(\.trackerService) private var trackerService

    var router: FastingPhaseRouter!
    @Published var stage: FastingStage
    @Published var hasSubscription = false
    private let disposeBag = DisposeBag()
    private let isMonetizationExpAvailable: Bool


    init(input: FastingPhaseInput, output: @escaping FastingPhaseOutputBlock) {
        stage = input.stage
        isMonetizationExpAvailable = input.isMonetizationExpAvailable
        super.init(output: output)
        observeMayUseApp()
    }

    var title: String {
        NSLocalizedString("FastingPhase.\(stage.rawValue)", comment: "")
    }

    var startDescription: String {
        NSLocalizedString("FastingPhase.startDescription.\(stage.rawValue)", comment: "")
    }

    var isLocked: Bool {
        !hasSubscription
    }

    var canShowArticle: Bool {
        if !hasSubscription {
            return stage == .sugarRises
        }
        return true
    }

    var article: Article {
        switch stage {
        case .sugarRises:
                .sugarRises
        case .sugarDrop:
                .sugarDrop
        case .sugarNormal:
                .sugarNormal
        case .burning:
                .burning
        case .ketosis:
                .ketosis
        case .autophagy:
                .autophagy
        }
    }

    var image: Image {
        switch stage {
        case .sugarRises:
            return .init(.sugarRisesArticle)
        case .sugarDrop:
            return .init(.sugarDownArticle)
        case .sugarNormal:
            return .init(.sugarNormalArticle)
        case .burning:
            return .init(.fatBurningArticle)
        case .ketosis:
            return .init(.ketosisArticle)
        case .autophagy:
            return .init(.autophagyArticle)
        }
    }

    func close() {
        router.dismiss()
    }

    func changeStage(to newStage: FastingStage) {
        trackerService.track(.tapFastingStages(stage: newStage.rawValue, context: .phasesScreen))
        stage = newStage
    }

    func presentPaywall() {
        trackerService.track(.tapUnlockFastingStages)

        if isMonetizationExpAvailable {
            router.presentMultipleProductPaywall()
            return
        }

        router.presentPaywall { [weak self] _ in
            self?.router.dismiss(PaywallRoute.self)
        }
    }

    private func observeMayUseApp() {
        subscriptionService.hasSubscriptionObservable
            .asDriver()
            .drive(with: self) { this, mayUseApp in
                this.hasSubscription = mayUseApp
            }
            .disposed(by: disposeBag)
    }
}
