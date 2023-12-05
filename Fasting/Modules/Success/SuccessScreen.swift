//  
//  SuccessScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 03.11.2023.
//

import SwiftUI
import AppStudioUI
import AppStudioNavigation

struct SuccessScreen: View {
    @StateObject var viewModel: SuccessViewModel

    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            Group {
                Text(viewModel.resultTitle)
                    .font(.adaptivePoppins(font: .headerM, smallDeviceFont: .headerS))

                if let subtitle = viewModel.resultSubtitle {
                    Text(subtitle)
                        .font(.adaptivePoppins(font: .buttonText, smallDeviceFont: .body))
                        .padding(.top, Layout.subtitleTopPadding)
                }
                Spacer()
                viewModel.resultImage
                Spacer()
                Spacer()
                Text(Localization.youFastingTime)
                    .font(.poppins(.body))
                Text(viewModel.fastingTime)
                    .font(.poppins(.accentS))
                    .padding(.top, Layout.fastingTimeTopPadding)
                Spacer()
            }
            .foregroundStyle(.accent)
            SuccessIntervalView(startDate: viewModel.fastingStartTime,
                                endDate: viewModel.fastingEndTime,
                                onStartEdit: viewModel.editStartDate,
                                onEndEdit: viewModel.editEndDate)
            .padding(.bottom, Layout.intervalBottomPadding)
            AccentButton(title: Localization.submit, action: viewModel.submit)
                .padding(.bottom, Layout.bottomPadding)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, Layout.horizontalPadding)
        .cancelButton(action: viewModel.dismiss)
    }
}

// MARK: - Layout properties
private extension SuccessScreen {
    enum Layout {
        static let topPadding: CGFloat = 40
        static let subtitleTopPadding: CGFloat = 16
        static let imageTopPadding: CGFloat = 44
        static let fastingTimeTopPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 32
        static let bottomPadding: CGFloat = 16
        static let intervalBottomPadding: CGFloat = 24
    }
}

// MARK: - Localization
private extension SuccessScreen {
    enum Localization {
        static let youFastingTime: LocalizedStringKey = "SuccessScreen.yourFastingTime"
        static let submit: LocalizedStringKey = "SuccessScreen.submit"
    }
}

struct SuccessScreen_Previews: PreviewProvider {
    static var previews: some View {
        ModernNavigationView {
            SuccessScreen(
                viewModel: SuccessViewModel(
                    input: SuccessInput(plan: .beginner,
                                        startDate: .now.adding(.hour, value: -3),
                                        endDate: .now),
                    output: { _ in }
                )
            )
        }
    }
}
