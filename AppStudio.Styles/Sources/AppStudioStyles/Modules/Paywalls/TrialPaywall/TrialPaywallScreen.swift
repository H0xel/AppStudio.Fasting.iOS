//
//  TrialPaywallScreen.swift
//
//  Created by Amakhin Ivan on 05.08.2024.
//

import SwiftUI
import AppStudioModels
import MunicornUtilities

public struct TrialProductPaywallScreen: View {
    let price: String
    let trialPeriod: String
    let type: SourceType
    var action: (Event) -> Void

    public init(price: String, 
                trialPeriod: String,
                type: SourceType,
                action: @escaping (Event) -> Void
    ) {
        self.price = price
        self.trialPeriod = trialPeriod
        self.type = type
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            ScrollView {
                type.image
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                VStack(spacing: .zero) {
                    Text(type.title)
                        .font(.poppinsBold(.headerL))
                        .foregroundStyle(Color.studioBlackLight)
                        .multilineTextAlignment(.center)
                        .padding(.top, .titleTopPadding)

                    VStack(spacing: .zero) {
                        Text("TrialPaywall.forFree".localized(bundle: .module))
                            .font(.poppinsBold(.headerL))
                            .foregroundStyle(Color.studioGreen)
                        Image(.fastingTrialIUnderline)
                            .frame(width: .underIineWidth)
                            .aligned(.right)
                    }
                    .frame(width: .forFreeWidth)

                    VStack(spacing: .zero) {
                        Text(trialPeriodTitle)
                            .font(.poppinsBold(.buttonText))
                            .foregroundStyle(Color.studioGreen)
                        Text(pricePerYearTitle)
                            .font(.poppins(.body))
                            .foregroundStyle(Color.studioGrayText)
                    }
                    .padding(.vertical, .freeTrialTopPadding)

                    ForEach(type.bullets, id: \.self) { text in
                        HStack(spacing: .zero) {
                            Text(type.bulletEmoji)
                                .padding(.trailing, .bulletTrailingPadding)
                                .padding(.leading, .bulletLeadingPadding)
                            Text(text)
                                .font(.poppins(.body))
                                .foregroundStyle(Color.studioBlackLight)
                            Spacer()
                        }
                        .padding(.vertical, .bulletVerticalPadding)
                    }
                }
            }
            .scrollIndicators(.hidden)

            AccentButton(title: .string("TrialPaywall.startFreeTrial".localized(bundle: .module))) {
                action(.subscribe)
            }
            .padding(.vertical, .buttonVerticalPadding)
            .background()
        }
        .padding(.horizontal, .horizontalPadding)
        .onAppear {
            action(.appeared)
        }
        .toolbar(.visible, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
        .navBarButton(content: closeButton,
                      action: { action(.close) })
    }

    private var pricePerYearTitle: String {
        .init(format: "TrialPaywall.pricePerYear".localized(bundle: .module), price)
    }

    private var trialPeriodTitle: String {
        .init(format: "TrialPaywall.trialPeriod".localized(bundle: .module), trialPeriod)
    }

    private var closeButton: some View {
        Image.close
            .foregroundStyle(Color.studioGreyPlaceholder)
    }
}

public extension TrialProductPaywallScreen {
    enum Event {
        case close
        case restore
        case subscribe
        case appeared
    }

    enum SourceType {
        case fasting
        case calorieCounter

        var image: Image {
            switch self {
            case .fasting:
                Image(.fastingTrialPaywall)
            case .calorieCounter:
                Image(.fastingTrialPaywall)
            }
        }

        var title: String {
            switch self {
            case .fasting: return "TrialPaywall.fasting.title".localized(bundle: .module)
            case .calorieCounter:
                return ""
            }
        }

        var bulletEmoji: String {
            switch self {
            case .fasting: "🚀"
            case .calorieCounter: ""
            }
        }

        var bullets: [String] {
            switch self {
            case .fasting:
                [
                    "TrialPaywall.fasting.bullet1".localized(bundle: .module),
                    "TrialPaywall.fasting.bullet2".localized(bundle: .module),
                    "TrialPaywall.fasting.bullet3".localized(bundle: .module),
                    "TrialPaywall.fasting.bullet4".localized(bundle: .module)
                ]
            case .calorieCounter:
                []
            }
        }
    }
}

private extension CGFloat {
    static let titleTopPadding: CGFloat = 12
    static let underIineWidth: CGFloat = 98
    static let forFreeWidth: CGFloat = 150
    static let freeTrialTopPadding: CGFloat = 25
    static let horizontalPadding: CGFloat = 24
    static let bulletLeadingPadding: CGFloat = 32
    static let bulletTrailingPadding: CGFloat = 20
    static let bulletVerticalPadding: CGFloat = 8
    static let buttonVerticalPadding: CGFloat = 8
}

#Preview {
    NavigationView {
        TrialProductPaywallScreen(
            price: "",
            trialPeriod: "",
            type: .fasting,
            action: { _ in })
    }
}

