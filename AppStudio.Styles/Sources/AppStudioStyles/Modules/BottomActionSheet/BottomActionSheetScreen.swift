//  
//  BottomActionSheetScreen.swift
//  
//
//  Created by Amakhin Ivan on 10.07.2024.
//

import SwiftUI
import AppStudioNavigation

struct BottomActionSheetScreen: View {
    @StateObject var viewModel: BottomActionSheetViewModel

    var body: some View {
        VStack(spacing: .zero) {
            Text(viewModel.configuration.title)
                .font(.poppins(.headerS))

            if let subtitle = viewModel.configuration.subtitle {
                Text(subtitle)
                    .font(.poppins(.body))
                    .padding(.top, .subTitleTopPadding)
            }

            HStack(spacing: .spacing) {
                Button(viewModel.configuration.leftButtonTitle, action: viewModel.leftButtonTapped)
                    .font(.poppins(.buttonText))
                    .foregroundStyle(Color.black)
                    .frame(height: .buttonHeight)
                    .continiousCornerRadius(.cornerRadius)
                    .aligned(.centerHorizontaly)
                    .border(configuration: .init(cornerRadius: .cornerRadius, color: Color.studioGreyStrokeFill))

                Button(viewModel.configuration.rightButtonTitle, action: viewModel.rightButtonTapped)
                    .font(.poppins(.buttonText))
                    .foregroundStyle(Color.white)
                    .frame(height: .buttonHeight)
                    .aligned(.centerHorizontaly)
                    .background(Color.studioBlackLight)
                    .continiousCornerRadius(.cornerRadius)

            }
            .padding(.horizontal, .horizontalPadding)
            .padding(.top, .topPadding)
        }
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let titleTopPadding: CGFloat = 32
    static let subTitleTopPadding: CGFloat = 12
    static let spacing: CGFloat = 8

    static let leftButtonVerticalPadding: CGFloat = 22
    static let rightButtonVerticalPadding: CGFloat = 22
    static let cornerRadius: CGFloat = 20

    static let horizontalPadding: CGFloat = 24
    static let topPadding: CGFloat = 40

    static let buttonHeight: CGFloat = 64
}


struct BottomActionSheetScreen_Previews: PreviewProvider {
    static var previews: some View {
        BottomActionSheetScreen(
            viewModel: BottomActionSheetViewModel(
                input: BottomActionSheetInput(configuration: .init(
                    title: "Discard changes?",
                    subtitle: "This food will not be saved",
                    leftButtonTitle: "Keep Editing",
                    rightButtonTitle: "Discard")
                ),
                output: { _ in }
            )
        )
    }
}
