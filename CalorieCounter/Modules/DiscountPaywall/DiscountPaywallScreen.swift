//  
//  DiscountPaywallScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.02.2024.
//

import SwiftUI
import AppStudioNavigation
import MunicornFoundation
import AppStudioServices

struct DiscountPaywallScreen: View {
    @StateObject var viewModel: DiscountPaywallViewModel
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: .zero) {
            ZStack {
                Color.white

                switch viewModel.paywallType {
                case .timer(let viewData):
                    DiscountTimerView(viewData: .init(
                        timerInterval: viewModel.timeInterval,
                        discount: viewData.discount,
                        descriptionViewData: viewData.descriptionViewData
                    ))

                case .discount(let viewData):
                    DiscountPaywallView(viewData: viewData)
                case .empty:
                    EmptyView()
                }

                HStack(spacing: .zero) {
                    Button(action: viewModel.restore) {
                        restoreButton
                    }

                    Spacer()

                    Button(action: viewModel.close) {
                        Image.close.foregroundStyle(Color.studioGreyStrokeFill)
                    }
                }
                .aligned(.top)
                .padding(.horizontal, .headerButtonsHorizontalPadding)
                .padding(.top, .headerButtonsTopPadding)
            }
            AccentButton(title: "DiscountPaywall.saveNow \(viewModel.discountPersent)") {
                viewModel.subscribe()
            }
            .padding(.horizontal, .buttonHorizontalPadding)
            .padding(.bottom, .buttonBottomPadding)
        }
        .onAppear(perform: viewModel.appeared)
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                viewModel.updateTimer()
            }
        }
    }

    private var restoreButton: some View {
        Text("Paywall.restore")
            .foregroundColor(.studioGrayPlaceholder)
            .font(.poppins(.buttonText))
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static var buttonHorizontalPadding: CGFloat { 16 }
    static var buttonBottomPadding: CGFloat { 8 }
    static let tabBarRestoreButtonTrailingPadding: CGFloat = 16
    static let tabBarRestoreButtonBottomPadding: CGFloat = 10
    static let headerButtonsHorizontalPadding: CGFloat = 16
    static let headerButtonsTopPadding: CGFloat = 10
}

struct DiscountPaywallScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            DiscountPaywallScreen(
                viewModel: DiscountPaywallViewModel(
                    input: .init(context: .discountMain, paywallInfo: .init(
                        name: "",
                        productId: "",
                        delayTimeInHours: nil,
                        paywallType: "",
                        renewOfferTime: nil,
                        discount: 50,
                        timerDurationInSeconds: 0,
                        priceDisplay: "")),
                    output: { _ in }
                )
            )
        }
    }
}
