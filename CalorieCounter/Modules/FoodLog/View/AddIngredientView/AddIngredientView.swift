//
//  AddIngredientTextField.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 29.05.2024.
//

import SwiftUI
import Combine
import AppStudioNavigation

enum AddIngredientOutput {
    case search(String)
    case scanBarcode(Bool)
    case add(MealItem)
    case remove(MealItem)
    case dismiss
    case present(MealItem)
}

struct AddIngredientTextField: View {

    let mealPublisher: AnyPublisher<Meal, Never>
    let output: (AddIngredientOutput) -> Void

    @State private var meal: Meal = .mock
    @State private var text = ""
    @FocusState private var isFocused: Bool
    @State private var suggestionsScrollOffset: CGFloat = 0
    private let requestSubject = CurrentValueSubject<String, Never>("")
    private let collapsePublisher = PassthroughSubject<Void, Never>()

    var body: some View {
        ZStack(alignment: .bottom) {
            FoodSuggestionsView(
                scrollOffset: $suggestionsScrollOffset,
                isFocused: isFocused,
                inputHeight: .inputHeight,
                logType: .history,
                minTopPadding: .minTopPadding,
                viewModel: .init(
                    input: foodSuggestionsInput,
                    output: handle
                )
            )

            FoodLogTextField(text: $text,
                             context: .addIngredients(meal),
                             isDisableEditing: false,
                             showTopBorder: false,
                             isBarcodeShown: true,
                             onTap: search,
                             onBarcodeScan: scanBarcode)
            .focused($isFocused)
            .background(.white)
            .onAppear {
                isFocused = true
            }
            .modifier(HideOnScrollModifier(scrollOffset: suggestionsScrollOffset,
                                           canHide: true))
        }
        .onChange(of: text) { newValue in
            requestSubject.send(newValue)
        }
        .onReceive(mealPublisher) { meal in
            self.meal = meal
        }
    }

    private var foodSuggestionsInput: FoodSuggestionsInput {
        .init(mealPublisher: mealItemsPublisher,
              mealType: .breakfast,
              mealRequestPublisher: requestSubject.eraseToAnyPublisher(),
              isPresented: true,
              collapsePublisher: collapsePublisher.eraseToAnyPublisher(),
              searchRequest: text, 
              showOnlyIngredients: true)
    }

    private var mealItemsPublisher: AnyPublisher<[MealItem], Never> {
        mealPublisher
            .map {
                $0.mealItem.type == .ingredient ? [$0.mealItem] : $0.mealItem.ingredients
            }
            .eraseToAnyPublisher()
    }

    private func handle(foodSuggestionsOutput output: FoodSuggestionsOutput) {
        switch output {
        case .add(let mealItem):
            self.output(.add(mealItem))
        case .remove(let mealItem):
            self.output(.remove(mealItem))
        case .togglePresented(let isPresented):
            if !isPresented {
                self.output(.dismiss)
            }
        case .present(let mealItem):
            self.output(.present(mealItem))
        }
    }

    private func search(_ text: String) {
        output(.search(text))
    }

    private func scanBarcode(_ isAccessGranted: Bool) {
        output(.scanBarcode(isAccessGranted))
    }
}

private extension CGFloat {
    static let inputHeight: CGFloat = 107
    static let minTopPadding: CGFloat = 100
}

#Preview {
    AddIngredientTextField(mealPublisher: Just(.mock).eraseToAnyPublisher(), output: { _ in })
}
