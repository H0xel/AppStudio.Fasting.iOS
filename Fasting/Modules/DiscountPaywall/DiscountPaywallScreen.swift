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

                if isSettings {
                    Button(action: viewModel.restoreTapped) {
                        restoreButton
                            .padding(.trailing, .tabBarRestoreButtonTrailingPadding)
                            .padding(.top, .tabBarRestoreButtonBottomPadding)
                    }
                    .aligned(.topRight)
                }
            }
            AccentButton(title: .string(Localization.saveNow(amount: viewModel.discountPersent))) {
                viewModel.subscribe()
            }
            .padding(.horizontal, .buttonHorizontalPadding)
            .padding(.bottom, .buttonBottomPadding)
        }
        .navBarButton(placement: .navigationBarTrailing,
                      isVisible: true,
                      content: Image.close.foregroundStyle(Color.studioGreyStrokeFill),
                      action: viewModel.close)
        .navBarButton(content: restoreButton,
                      action: viewModel.restoreTapped)
        .toolbarBackground(.clear, for: .navigationBar)
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

    private var isSettings: Bool {
        viewModel.context == .discountPaywallTab
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static var buttonHorizontalPadding: CGFloat { 16 }
    static var buttonBottomPadding: CGFloat { 8 }
    static let tabBarRestoreButtonTrailingPadding: CGFloat = 16
    static let tabBarRestoreButtonBottomPadding: CGFloat = 10
}

// MARK: - Localization
private extension DiscountPaywallScreen {
    enum Localization {
        static func saveNow(amount: String) -> String {
            String(format: NSLocalizedString("DiscountPaywall.saveNow", comment: "Save % now"), amount)
        }
    }
}

struct DiscountPaywallScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DiscountPaywallScreen(
                viewModel: DiscountPaywallViewModel(
                    input: .init(context: .paywallTab, paywallInfo: .mock),
                    output: { _ in }
                )
            )
        }
    }
}
