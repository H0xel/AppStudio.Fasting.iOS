//  
//  PersonalizedPaywallViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.12.2023.
//

import RxSwift
import SwiftUI
import Dependencies
import AppStudioUI
import AppStudioNavigation
import AppStudioSubscriptions
import AppStudioServices
import AppStudioModels
import StoreKit

class PersonalizedPaywallViewModel: BasePaywallViewModel<PersonalizedPaywallOutput> {
    @Dependency(\.productIdsService) private var productIdsService
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService
    @Dependency(\.newSubscriptionService) private var newSubscriptionService

    @Published var isTrialAvailable = false
    @Published var canDisplayCloseButton = false
    @Published private var discountPaywallInfo: DiscountPaywallInfo?
    let input: PersonalizedPaywallInput

    var router: PersonalizedPaywallRouter!

    private let disposeBag = DisposeBag()
    private var paywallSubscription: Product?


    init(input: PersonalizedPaywallInput, output: @escaping PersonalizedPaywallOutputBlock) {
        self.input = input
        super.init(output: output)
        paywallContext = .onboarding
        configureCloseButton()
        initializeRemoteSubscriptions()
        subscribeToDiscountPaywallState()
        subscribeForAvailableDiscountPaywall()
        subscribeToStatus()
    }

    private var headerDescription: String {
        guard let paywallSubscription else { return "" }
        return paywallSubscription.paywallDescription(isTrialAvailable: isTrialAvailable) ?? ""
    }

    var promoViewData: PersonalizedPromotionalOfferView.ViewData? {
        guard let paywallSubscription,
              let promoPrice = paywallSubscription.promoPriceLocale,
              let promoDuration = paywallSubscription.promoDuration,
              isTrialAvailable else {
            return nil
        }
        return .init(duration: promoDuration, price: promoPrice)
    }

    var headerViewData: PersonalizedTitleView.ViewData {
        .init(title: input.title,
              description: headerDescription)
    }

    func subscribe() {
        if let paywallSubscription {
            subscribe(id: paywallSubscription.id)
        }
    }

    func close() {
        guard canDisplayCloseButton else { return }
        paywallClosed()

        if let discountPaywallInfo {
            output(.showDiscountPaywall(.init(context: .discountOnboarding, paywallInfo: discountPaywallInfo)))
            return
        }

        output(.close)
    }

    func restoreTapped() {
        restore()
    }

    func appeared() {
        paywallAppeared()
    }

    func scrolledDown() {
        canDisplayCloseButton = true
    }

    private func subscribeToStatus() {
        $status
            .sink(with: self) { this, status in
                switch status {
                case .none: break
                case .subscribed:
                    this.router.dismissBanner()
                    this.output(.subscribed)
                case .showAlert:
                    this.showRestoreErrorAlert()
                case .showProgress:
                    this.router.presentProgressView()
                case .hideProgress:
                    this.router.dismissBanner()
                }
            }
            .store(in: &cancellables)
    }

    private func showRestoreErrorAlert() {
        let alertTitle = NSLocalizedString("PaywallDetailsScreen.errorSubscription",
                                           comment: "error subscription status")
        router.present(systemAlert: Alert(title: alertTitle, message: nil, actions: []))
    }

    private func initializeRemoteSubscriptions() {
        $subscriptions
            .setFailureType(to: Error.self)
            .combineLatest(productIdsService.paywallProductIds.asPublisher())
            .sink(with: self,
                  receiveCompletion: { _ in },
                  receiveValue: { this, args in
                let products = args.0
                let productId = args.1.first
                this.paywallSubscription = products.first(where: { $0.id == productId })
                Task { @MainActor in
                    if let paywallSubscription = this.paywallSubscription {
                        this.isTrialAvailable = await this.newSubscriptionService.hasPromotion(
                            product: paywallSubscription
                        )
                    }
                }
            })
            .store(in: &cancellables)
    }

    private func subscribeForAvailableDiscountPaywall() {
        discountPaywallTimerService.discountAvailable
            .assign(to: &$discountPaywallInfo)
    }

    private func subscribeToDiscountPaywallState() {
        appCustomization.discountPaywallExperiment
            .asDriver()
            .drive(with: self) { this, discountPaywallInfo in
                if let discountPaywallInfo = discountPaywallInfo {
                    this.discountPaywallTimerService.registerPaywall(info: discountPaywallInfo)
                }
            }
            .disposed(by: disposeBag)
    }

    private func configureCloseButton() {
        Task {
            let delay = try? await appCustomization.closePaywallButtonDelay()
            try await Task.sleep(seconds: Double(delay ?? 3))
            await MainActor.run { [weak self] in
                self?.canDisplayCloseButton = true
            }
        }
    }
}
