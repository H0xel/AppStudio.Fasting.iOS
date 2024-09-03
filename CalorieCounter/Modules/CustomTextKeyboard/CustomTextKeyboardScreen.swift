//
//  CustomTextKeyboardScreen.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.07.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

struct CustomTextKeyboardScreen: View {
    @StateObject var viewModel: CustomTextKeyboardViewModel
    @FocusState var textKeyboardIsFocused: Bool
    @State private var text: String
    @State private var isFocused = true

    init(viewModel: CustomTextKeyboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
        text = viewModel.text
    }

    var body: some View {
        VStack(spacing: .zero) {
            CustomKeyboardTextField(isTextSelected: $viewModel.isTextSelected,
                                    isFocused: $isFocused,
                                    title: viewModel.title,
                                    text: viewModel.text,
                                    units: "",
                                    grammsValue: nil,
                                    isPresented: true)
            TextField("", text: $text)
                .submitLabel(.next)
                .onSubmit {
                    viewModel.nextButtonTapped()
                }
                .frame(height: 0)
                .opacity(0)
                .focused($textKeyboardIsFocused)
                .onAppear {
                    textKeyboardIsFocused = true
                }
                .disableAutocorrection(true)
                .onChange(of: text) { newValue in
                    if viewModel.isTextSelected {
                        if viewModel.text.count - newValue.count == 1 {
                            viewModel.text = ""
                            text = ""
                        } else {
                            viewModel.text = newValue.last?.description ?? ""
                            text = newValue.last?.description ?? ""
                        }
                        viewModel.isTextSelected = false
                    } else {
                        viewModel.text = newValue
                    }
                }
        }
        .modifier(TopBorderModifier())
        .aligned(.bottom)
    }
}

// MARK: - Layout properties
private extension CustomTextKeyboardScreen {
    enum Layout {
    }
}

// MARK: - Localization
private extension CustomTextKeyboardScreen {
    enum Localization {
        static let title: LocalizedStringKey = "CustomTextKeyboardScreen"
    }
}

struct CustomTextKeyboardScreen_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextKeyboardScreen(
            viewModel: CustomTextKeyboardViewModel(
                input: CustomTextKeyboardInput(title: "", text: ""),
                output: { _ in }
            )
        )
    }
}
