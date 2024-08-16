//
//  CustomKeyboardScreen.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles
import Combine
import AudioToolbox

struct CustomKeyboardScreen<Output>: View {
    @ObservedObject var viewModel: CustomKeyboardViewModel<Output>
    @State private var feedbackGenerator: UIImpactFeedbackGenerator?

    var body: some View {
        VStack(spacing: .zero) {
            if viewModel.shouldShowTextField || !viewModel.mealServings.isEmpty {
                CustomKeyboardTextField(isTextSelected: $viewModel.isTextSelected,
                                        isFocused: $viewModel.isFocused,
                                        title: viewModel.title,
                                        text: viewModel.displayText,
                                        units: viewModel.units,
                                        grammsValue: viewModel.grammsValue,
                                        isPresented: viewModel.shouldShowTextField)
            }
            if viewModel.isFocused {
                VStack(spacing: .zero) {
                    if !viewModel.mealServings.isEmpty {
                        CustomKeyboardServingsView(currentServing: viewModel.currentServing,
                                                   servings: viewModel.mealServings,
                                                   onChange: viewModel.changeServing)
                        .padding(.bottom, .servingsBottomPadding)
                        .background(.white)
                    }
                    HStack(spacing: .spacing) {
                        numbersStack(numbers: [1, 4, 7], bottomButton: viewModel.style.bottomLeftButton)
                        numbersStack(numbers: [2, 5, 8, 0])
                        numbersStack(numbers: [3, 6, 9], bottomButton: viewModel.style.bottomRightButton)
                        rightButtons
                    }
                    .padding(.spacing)
                    .background(Color.studioGreyStrokeFill)
                }
                .transition(.asymmetric(insertion: .push(from: .bottom),
                                        removal: .push(from: .top)))
            }
        }
        .modifier(TopBorderModifier(cornerRadius: viewModel.shouldShowTextField ? .cornerRadius : .zero))
        .aligned(.bottom)
        .onAppear {
            vibrate()
        }
        .animation(.linear(duration: 0.15), value: viewModel.isFocused)
    }

    private var rightButtons: some View {
        VStack(spacing: .spacing) {
            ForEach(viewModel.style.rightButtons, id: \.self) { button in
                CustomKeyboardButtonView(
                    button: button,
                    isAccent: button == viewModel.style.rightButtons.last,
                    action: viewModel.buttonTapped
                )
            }
        }
    }

    private func numbersStack(numbers: [Int], bottomButton: CustomKeyboardButton? = nil) -> some View {
        VStack(spacing: .spacing) {
            ForEach(numbers, id: \.self) { number in
                Button {
                    AudioServicesPlaySystemSound(1104)
                    viewModel.numberTapped(number)
                } label: {
                    CustomKeyboardNumberView(number: number)
                }
            }
            if let bottomButton {
                CustomKeyboardButtonView(
                    button: bottomButton,
                    isAccent: false,
                    action: viewModel.buttonTapped
                )
            }
        }
    }

    private func vibrate() {
        feedbackGenerator = UIImpactFeedbackGenerator(style: .soft)
        feedbackGenerator?.impactOccurred()
        feedbackGenerator = nil
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 6
    static let servingsBottomPadding: CGFloat = 10
    static let cornerRadius: CGFloat = 20
}

struct CustomKeyboardScreen_Previews: PreviewProvider {
    static var previews: some View {
        CustomKeyboardScreen(
            viewModel: ContainerKeyboardViewModel(
                input: CustomKeyboardInput(title: "Eggs",
                                           text: "",
                                           servings: [],
                                           currentServing: .init(weight: 100, measure: "g", quantity: 100),
                                           isPresentedPublisher: Just(true).eraseToAnyPublisher(),
                                           shouldShowTextField: true, 
                                           isTextSelectedPublisher: Just(true).eraseToAnyPublisher()),
                output: { _ in }
            )
        )
    }
}
