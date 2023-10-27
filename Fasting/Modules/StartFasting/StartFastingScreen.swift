//  
//  StartFastingScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

struct StartFastingScreen: View {
    @StateObject var viewModel: StartFastingViewModel

    var body: some View {
        VStack(spacing: .zero) {
            Text(Localization.whenToStart)
                .font(.semiTitle)
                .fontWeight(.semibold)
                .padding(.bottom, Layout.titleBottomPadding)
            Text("Fast will end the following day, 13:00")
                .font(.casual)

            DatePicker("", selection: $viewModel.fastTime, displayedComponents: .hourAndMinute)
                .datePickerStyle(.wheel)
                .padding(.vertical, Layout.datePickerVerticalPadding)

            HStack(spacing: Layout.buttonsSpacing) {

                BorderedButton(title: Localization.cancel, action: viewModel.cancel)
                AccentButton(title: Localization.save, action: viewModel.save)
            }
        }
        .multilineTextAlignment(.center)
        .foregroundStyle(Color.accentColor)
        .padding(.top, Layout.topPadding)
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.bottom, Layout.bottomPadding)
        .aligned(.bottom)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
    }
}

// MARK: - Layout properties
private extension StartFastingScreen {
    enum Layout {
        static let topPadding: CGFloat = 40
        static let bottomPadding: CGFloat = 16
        static let titleBottomPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 32
        static let buttonsSpacing: CGFloat = 8
        static let datePickerVerticalPadding: CGFloat = 48
    }
}

// MARK: - Localization
private extension StartFastingScreen {
    enum Localization {
        static let whenToStart: LocalizedStringKey = "StartFastingScreen.whenToStart"
        static let save: LocalizedStringKey = "SaveTitle"
        static let cancel: LocalizedStringKey = "CancelTitle"
    }
}

struct StartFastingScreen_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = StartFastingViewModel(input: .init(), output: { _ in })
        viewModel.router = .init(navigator: .init())
        return StartFastingScreen(viewModel: viewModel)
    }
}
