//  
//  SetupFastingScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 31.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioFoundation

struct SetupFastingScreen: View {
    @StateObject var viewModel: SetupFastingViewModel

    var body: some View {
        VStack(spacing: 0) {
            SetupFastingBanner(plan: viewModel.plan) {
                viewModel.changeTapped()
            }

            VStack(spacing: 0) {
                Text(Localization.title)
                    .font(.poppins(.headerM))
                Text(viewModel.title)
                    .font(.poppins(.buttonText))
            }
            .multilineTextAlignment(.center)
            .padding(.top, Layout.topTextPadding)

            Spacer()

            DatePicker("", selection: $viewModel.startFastingDate, displayedComponents: [.hourAndMinute])
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(height: Layout.pickerHeight, alignment: .center)
                .clipped()

            Spacer()

            AccentButton(title: Localization.buttonTitle) {
                viewModel.saveTapped()
            }
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .navBarButton(
            isVisible: true,
            content: viewModel.context == .onboarding
            ? Image.chevronLeft.foregroundColor(.black)
            : Image.xmark.foregroundColor(.black)) {
                viewModel.backButtonTapped()
        }
    }
}

// MARK: - Layout properties
private extension SetupFastingScreen {
    enum Layout {
        static let topTextPadding: CGFloat = 56
        static let horizontalPadding: CGFloat = 32
        static let pickerBottomPadding: CGFloat = 44
        static let pickerHeight: CGFloat = 178
    }
}

// MARK: - Localization
private extension SetupFastingScreen {
    enum Localization {
        static let title: LocalizedStringKey = "SetupFasting.title"
        static let description: LocalizedStringKey = "SetupFasting.description"
        static let buttonTitle: LocalizedStringKey = "SetupFasting.buttonTitle"
    }
}

struct SetupFastingScreen_Previews: PreviewProvider {
    static var previews: some View {
        SetupFastingScreen(
            viewModel: SetupFastingViewModel(
                input: SetupFastingInput(plan: .beginner, context: .onboarding),
                output: { _ in }
            )
        )
    }
}
