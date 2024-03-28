//  
//  ComboBoxEditorScreen.swift
//  
//
//  Created by Denis Khlopin on 22.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

struct ComboBoxEditorScreen: View {
    @StateObject var viewModel: ComboBoxEditorViewModel

    var body: some View {
        VStack(alignment: .center, spacing: .spacing) {
            // MARK: - Title
                Text(viewModel.title)
                    .font(.poppinsBold(.headerS))
                    .foregroundStyle(Color.studioBlackLight)
                    .padding(.top, .topPadding)

            VStack(spacing: 2) {
                ForEach(viewModel.values, id: \.value) { item in
                    HStack {
                        Text(item.title)
                        Spacer()
                        if item.value == viewModel.value {
                            Image.checkmark
                        }
                    }
                    .padding(.vertical, 16)
                    .padding(.leading, 20)
                    .padding(.trailing, 16)
                    .background(Color.studioGrayFillCard)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewModel.update(value: item)
                    }
                }
            }

            .continiousCornerRadius(20)

            HStack(spacing: 8) {
                BorderedIconButton(icon: .arrowLeft, title: nil, action: viewModel.close)
                    .frame(width: 64)
                AccentButton(title: .string(viewModel.buttonTitle), action: viewModel.submit)
            }
            Spacer()
        }
        .padding(.horizontal, .horizontalPadding)
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let spacing: CGFloat = 48
    static let topPadding: CGFloat = 32
    static let horizontalPadding: CGFloat = 24
}


// MARK: - Localization
private extension ComboBoxEditorScreen {
    enum Localization {
        static let title: LocalizedStringKey = "ComboBoxEditorScreen"
    }
}

struct ComboBoxEditorScreen_Previews: PreviewProvider {
    static var previews: some View {
        ComboBoxEditorScreen(
            viewModel: ComboBoxEditorViewModel(
                input: ComboBoxEditorInput(
                    title: "Units",
                    values: [
                        .init(title: "Liters", value: "1"),
                        .init(title: "Ounces", value: "2")
                    ],
                    value: "1", buttonTitle: "Save"
                ),
                output: { _ in }
            )
        )
    }
}
