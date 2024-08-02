//  
//  DiscountPaywallViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.02.2024.
//

import AppStudioNavigation
import AppStudioUI
import Combine
import Dependencies
import NewAppStudioSubscriptions
import AppStudioServices
import StoreKit

enum DiscountPaywallType {
    case timer(DiscountTimerView.ViewData)
    case discount(DiscountPaywallView.ViewData)
    case empty
}

class DiscountPaywallViewModel: BasePaywallViewModel<DiscountPaywallOutput> {
    @Dependency(\.discountPaywallTimerService) private var discountPaywallTimerService
    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.productIdsService) private var productIdsService
    @Dependency(\.accountProvider) private var accountProvider

    @Published var timeInterval: TimeInterval = .second
    @Published var paywallType: DiscountPaywallType = .empty

    var router: DiscountPaywallRouter!
    let discountPersent: String
    let context: PaywallContext

    private let paywallInfo: DiscountPaywallInfo
    private var paywallSubscription: Product?
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    init(input: DiscountPaywallInput, output: @escaping DiscountPaywallOutputBlock) {
        paywallInfo = input.paywallInfo
        discountPersent = "\(input.paywallInfo.discount ?? 0)%"
        context = input.context
        super.init(output: output)
        paywallContext = input.context
        accountId = accountProvider.accountId
        subscribeToStatus()
        initializeRemoteSubscriptions()
        updateTimer()
        startTimer()
    }

    func subscribe() {
        guard let paywallSubscription else { return }
        subscribe(id: paywallSubscription.id)
    }

    func close() {
        output(.close)
        paywallClosed()
    }

    func restoreTapped() {
        restore()
    }

    func appeared() {
        paywallAppeared()
    }

    func updateTimer() {
        guard let interval = discountPaywallTimerService.getCurrentTimer(
            durationInSeconds: paywallInfo.timerDurationInSeconds ?? 0
        ) else {
            return
        }

        timeInterval = interval
    }

    private func startTimer() {
        Publishers.Merge(timer, Just(.now))
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, _ in
                this.timeInterval -= .second

                if this.timeInterval.seconds <= 0 {
                    this.discountPaywallTimerService.setAvailableDiscount(data: nil)
                    this.timer.upstream.connect().cancel()
                }
            }
            .store(in: &cancellables)
    }

    private func subscribeToStatus() {
        $status
            .sink(with: self) { this, status in
                switch status {
                case .none: break
                case .subscribed:
                    this.context == .discountPaywallTab
                    ? this.output(.switchProgress(isProcessing: false))
                    : this.router.dismissBanner()
                    this.output(.subscribe)
                case .showAlert:
                    this.showRestoreErrorAlert()
                case .showProgress:
                    this.context == .discountPaywallTab
                    ? this.output(.switchProgress(isProcessing: true))
                    : this.router.presentProgressView()
                case .hideProgress:
                    this.context == .discountPaywallTab
                    ? this.output(.switchProgress(isProcessing: false))
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
                this.paywallSubscription = products.first(where: { $0.id == this.paywallInfo.productId })
                Task { @MainActor in
                    if let paywallSubscription = this.paywallSubscription {
                        this.paywallType = .init(paywallInfo: this.paywallInfo, subscription: paywallSubscription)
                    }
                }
            })
            .store(in: &cancellables)
    }
}
