//
//  PaywallViewModel.swift
//  Mileage.iOS
//
//  Created by Руслан Сафаргалеев on 07.08.2023.
//

import RxSwift
import SwiftUI
import Dependencies
import AppStudioUI
import AppStudioNavigation
import AppStudioSubscriptions
import AppStudioServices
import MunicornFoundation
import AppStudioModels

class PaywallViewModel: BasePaywallViewModel<PaywallScreenOutput> {
    @Published var selectedProduct: SubscriptionProduct?
    @Published var isTrialAvailable = false
    @Published var canDisplayCloseButton = false
    @Published private var input: PaywallScreenInput
    @Published private var discountPaywallInfo: DiscountPaywallInfo?

    var router: PaywallRouter!

    private let disposeBag = DisposeBag()
    @Dependency(\.newSubscriptionService) private var newSubscriptionService
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.productIdsService) private var productIdsService
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService
    @Dependency(\.accountProvider) private var accountProvider

    init(input: PaywallScreenInput, output: @escaping ViewOutput<PaywallScreenOutput>) {
        self.input = input
        super.init(output: output)
        paywallContext = context
        accountId = accountProvider.accountId
        configureCloseButton()
        initializeRemoteSubscriptions()
        subscribeToStatus()
        subscribeToDiscountPaywallState()
        subscribeForAvailableDiscountPaywall()
    }

    var headerDescription: String {
        let title = isTrialAvailable ? input.headerTitles.description : NSLocalizedString("Paywall.renewsAt",
                                                                                          comment: "")
        return String(format: title, selectedProduct?.titleDetails ?? "")
    }

    var headerTitles: PaywallTitle {
        PaywallTitle(title: input.headerTitles.title,
                     description: headerDescription,
                     subTitle: input.headerTitles.subTitle)
    }

    var context: PaywallContext {
        input.paywallContext
    }

    var isSettings: Bool {
        context == .paywallTab
    }

    var bottomInfo: LocalizedStringKey {
        isTrialAvailable ? "Paywall.noPaymentNow" : "Paywall.cancelAnyTime"
    }

    func subscribe() {
        if let selectedProduct {
            subscribe(id: selectedProduct.id)
        }
    }

    func close() {
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

    func handle(_ event: PaywallBottomInfoView.Action) {
        switch event {
        case .onSaveTap:
            subscribe()
        }
    }

    private func subscribeToStatus() {
        $status
            .sink(with: self) { this, status in
                switch status {
                case .none: break
                case .subscribed:
                    this.isSettings
                    ? this.output(.switchProgressView(isPresented: false))
                    : this.router.dismissBanner()
                    this.output(.subscribed)
                case .showAlert:
                    this.showRestoreErrorAlert()
                case .showProgress:
                    this.isSettings 
                    ? this.output(.switchProgressView(isPresented: true))
                    : this.router.presentProgressView()
                case .hideProgress:
                    this.isSettings
                    ? this.output(.switchProgressView(isPresented: false))
                    : this.router.dismissBanner()
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
                let firstRemoteSubscription = products.first(where: { $0.id == productId })
                this.selectedProduct = firstRemoteSubscription?.asSubscriptionProduct(promotion: nil)
                Task { @MainActor in
                    if let firstRemoteSubscription {
                        this.isTrialAvailable = await this.newSubscriptionService.hasPromotion(
                            product: firstRemoteSubscription
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
            .distinctUntilChanged()
            .asDriver()
            .drive(with: self) { this, discountPaywallInfo in
                if let discountPaywallInfo {
                    this.discountPaywallTimerService.registerPaywall(info: discountPaywallInfo)
                }
            }
            .disposed(by: disposeBag)
    }

    private func configureCloseButton() {
        if context == .freeUsageLimit {
            canDisplayCloseButton = true
            return
        }
        Task {
            let delay = try? await appCustomization.closePaywallButtonDelay()
            try await Task.sleep(seconds: Double(delay ?? 3))
            await MainActor.run { [weak self] in
                self?.canDisplayCloseButton = true
            }
        }
    }
}
