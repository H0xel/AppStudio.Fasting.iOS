//  
//  EndFastingEarlyScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 07.11.2023.
//

import SwiftUI
import AppStudioNavigation

struct EndFastingEarlyScreen: View {
    @StateObject var viewModel: EndFastingEarlyViewModel

    var body: some View {
        VStack(spacing: .zero) {
            // TODO: - Заменить на картинку, когда она будет готова
            Color.gray
                .frame(height: 186)
            Text(Localization.title)
                .font(.poppins(.headerM))
                .padding(.top, Layout.topPadding)
            Text(viewModel.subtitle)
                .font(.poppins(.buttonText))
                .padding(.top, Layout.subtitleTopPadding)

            HStack(spacing: Layout.buttonsSpacing) {
                BorderedButton(title: Localization.cancel, action: viewModel.cancel)
                AccentButton(title: Localization.endFasting, action: viewModel.endFasting)
            }
            .padding(.top, Layout.buttonsTopPadding)
        }
        .multilineTextAlignment(.center)
        .padding(.horizontal, Layout.horizontalPadding)
    }
}

// MARK: - Layout properties
private extension EndFastingEarlyScreen {
    enum Layout {
        static let topPadding: CGFloat = 32
        static let bottomPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 32
        static let titleTopPadding: CGFloat = 64
        static let subtitleTopPadding: CGFloat = 24
        static let buttonsTopPadding: CGFloat = 48
        static let buttonsSpacing: CGFloat = 8
    }
}

// MARK: - Localization
private extension EndFastingEarlyScreen {
    enum Localization {
        static let title: LocalizedStringKey = "EndFastingEarlyScreen.title"
        static let endFasting: LocalizedStringKey = "FastingScreen.endFasting"
        static let cancel: LocalizedStringKey = "CancelTitle"
    }
}

struct EndFastingEarlyScreen_Previews: PreviewProvider {
    static var previews: some View {
        ModernNavigationView {
            EndFastingEarlyScreen(
                viewModel: EndFastingEarlyViewModel(
                    input: EndFastingEarlyInput(),
                    output: { _ in }
                )
            )
        }
    }
}
