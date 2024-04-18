//  
//  DoubleValueEditorScreen.swift
//  
//
//  Created by Denis Khlopin on 21.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

struct DoubleValueEditorScreen: View {
    @StateObject var viewModel: DoubleValueEditorViewModel

    var body: some View {
        VStack(alignment: .center, spacing: .spacing) {
            // MARK: - Title
            VStack(spacing: 24) {
                Text(viewModel.title)
                    .font(.poppinsBold(.headerS))
                    .foregroundStyle(Color.studioBlackLight)

                if let description = viewModel.description {
                    Text(description)
                        .multilineTextAlignment(.center)
                        .font(.poppins(.body))
                        .foregroundStyle(Color.studioGreyText)
                }
            }
            .padding(.top, .topPadding)

            VStack(spacing: 16) {
                UpdateWeightTextField(weight: $viewModel.value,
                                      units: viewModel.unitsTitle,
                                      type: viewModel.textfieldType)

                if let values = viewModel.predefinedValues {
                    HStack(spacing: 8) {
                        ForEach(values, id: \.self) { value in
                            Button(action: {
                                viewModel.update(value: value)
                            }, label: {
                                Text("\(value.title) \(viewModel.unitsTitle)")
                                    .font(.poppins(.description))
                                    .foregroundStyle(Color.studioBlackLight)
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 20)
                                    .border(configuration: .init(cornerRadius: 44, color: .studioGreyStrokeFill, lineWidth: 0.5))
                            })

                        }
                    }
                }


            }

            HStack(spacing: 8) {
                if viewModel.hasBackButton {
                    BorderedIconButton(icon: .arrowLeft, title: nil, action: viewModel.close)
                        .frame(width: 64)
                }
                AccentButton(title: .string(viewModel.buttonTitle ?? "Save"), action: viewModel.submit)
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

struct DoubleValueEditorScreen_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            DoubleValueEditorScreen(
                viewModel: DoubleValueEditorViewModel(
                    input: DoubleValueEditorInput(
                        title: "Daily Goal",
                        description: "Based on your profile data, the recommended daily water intake is ~2.5 liters",
                        predefinedValues: nil,
                        value: 2.5,
                        unitsTitle: "L",
                        buttonTitle: nil,
                        hasBackButton: true, textfieldType: .double(maxTail: nil)
                    ),
                    output: { _ in }
                )
            )

            DoubleValueEditorScreen(
                viewModel: DoubleValueEditorViewModel(
                    input: DoubleValueEditorInput(
                        title: "Preferred Volume",
                        description: nil,
                        predefinedValues: [.init(value: 200), .init(value: 500), .init(value: 750)],
                        value: 250,
                        unitsTitle: "ml",
                        buttonTitle: "Add",
                        hasBackButton: false, textfieldType: .integer
                    ),
                    output: { _ in }
                )
            )
        }
    }
}
