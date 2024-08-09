//
//  StartFastingScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import Combine

struct StartFastingScreen: View {
    @StateObject var viewModel: StartFastingViewModel

    var body: some View {
        VStack(spacing: .zero) {
            Text(viewModel.title)
                .font(.poppins(.headerM))
                .fontWeight(.semibold)

            DatePicker("",
                       selection: $viewModel.fastTime,
                       in: viewModel.datesRange,
                       displayedComponents: viewModel.dateComponents)
            .datePickerStyle(.wheel)
            .frame(height: Layout.datePickerHeight)
            .padding(.vertical, Layout.datePickerVerticalPadding)
            .padding(.horizontal, Layout.horizontalPadding)

            HStack(spacing: Layout.buttonsSpacing) {
                BorderedButton(title: Localization.cancel, action: viewModel.cancel)
                AccentButton(title: .localizedString(Localization.save), action: viewModel.save)
            }
            .padding(.horizontal, Layout.horizontalPadding)
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(Color.studioBlackLight)
        .padding(.top, Layout.topPadding)
        .padding(.bottom, Layout.bottomPadding)
    }
}

// MARK: - Layout properties
private extension StartFastingScreen {
    enum Layout {
        static let topPadding: CGFloat = 48
        static let bottomPadding: CGFloat = 8
        static let titleBottomPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 32
        static let buttonsSpacing: CGFloat = 8
        static let datePickerVerticalPadding: CGFloat = 48
        static let datePickerHeight: CGFloat = 182
    }
}

// MARK: - Localization
private extension StartFastingScreen {
    enum Localization {
        static let save: LocalizedStringKey = "SaveTitle"
        static let cancel: LocalizedStringKey = "CancelTitle"
    }
}

struct StartFastingScreen_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = StartFastingViewModel(
            input: .startFasting(context: .endFasting, isActiveState: true, initialDate: .now, minDate: .now,
                                 maxDate: .now.adding(.year, value: 1),
                                 components: .hourAndMinute),
            output: { _ in })
        viewModel.router = .init(navigator: .init())

        return FastingScreen(viewModel: .init(input: .init(isMonetizationAvailable: Just(false).eraseToAnyPublisher()),
                                              output: { _ in }))
            .sheet(isPresented: .constant(true)) {
                ModernNavigationView {
                    StartFastingScreen(viewModel: viewModel)
                }
                .presentationDetents([.height(474)])
            }
    }
}
