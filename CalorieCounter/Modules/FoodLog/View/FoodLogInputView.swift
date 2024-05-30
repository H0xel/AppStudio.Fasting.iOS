//
//  FoodLogInputView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.05.2024.
//

import SwiftUI
import AppStudioStyles

struct FoodLogInputView: View {

    let isFocused: Bool
    @ObservedObject var viewModel: FoodLogViewModel

    @State private var suggestionsScrollOffset: CGFloat = 0
    @State private var textFieldBottomPadding: CGFloat = 0
    @State private var previousSuggestionsScrollOffset: CGFloat = 0
    @State private var textFieldPaddingTask: Task<Void, Never>?

    var body: some View {
        ZStack {
            VStack(spacing: .zero) {
                Spacer()
                switch viewModel.logType {
                case .log, .history:
                    FoodSuggestionsView(
                        scrollOffset: $suggestionsScrollOffset,
                        isFocused: isFocused && viewModel.mealSelectedState == .notSelected,
                        inputHeight: inputHeight,
                        viewModel: .init(
                            input: viewModel.foodSuggestionsInput,
                            output: viewModel.handle
                        )
                    )
                case .quickAdd:
                    if !viewModel.mealSelectedState.isAddingIngredient {
                        QuickAddView(viewModel: .init(meal: viewModel.quickAddMeal,
                                                      output: viewModel.handle(quickAddOutput:)),
                                     isPresented: $viewModel.isQuickAddPresented)
                        Color.white.frame(height: viewModel.isQuickAddPresented ? .logChipsHeight : 0)
                    }
                case .addRecipe:
                    Color.clear.frame(height: 1)
                }
            }
            .opacity(viewModel.mealSelectedState == .notSelected ? 1 : 0)
            if isTextFieldPresented {
                VStack(spacing: .zero) {
                    if viewModel.logType != .quickAdd || viewModel.mealSelectedState.isAddingIngredient {
                        FoodLogTextField(text: $viewModel.mealRequest,
                                         context: viewModel.foodLogContext,
                                         showTopBorder: false,
                                         onTap: viewModel.logMeal(text:),
                                         onBarcodeScan: { accessGranted in
                            viewModel.trackBarcodeScannerOpen()
                            viewModel.barcodeScan(accessGranted: accessGranted)
                        })
                        .onTapGesture {
                            viewModel.isKeyboardFocused = true
                        }
                        .overlay {
                            if canShowDoneButton {
                                LogButton {
                                    viewModel.trackTapFinishLogging()
                                    viewModel.dismiss()
                                }
                                .aligned(.topRight)
                                .padding(.trailing, .logButtonTrailingPadding)
                                .offset(y: .doneButtonOffset)
                            }
                        }
                    }
                    if isChipsPresented {
                        LogChipsView(selected: $viewModel.logType, onClose: viewModel.closeChip)
                            .padding(.top, .chipsTopPadding)
                            .background(.white)
                            .padding(.bottom, .bottomPadding)
                            .padding(.horizontal, .horizontalChipsPadding)
                            .transition(.identity)
                            .padding(.top, -.chipsTopPadding)
                    }
                }
                .background(.white)
                .aligned(.bottom)
                .padding(.bottom, textFieldBottomPadding)
            }
        }
        .onChange(of: suggestionsScrollOffset) { offset in
            textFieldPaddingTask?.cancel()
            guard !isFocused, viewModel.isSuggestionsPresented else {
                textFieldBottomPadding = 0
                return
            }
            guard offset >= 0 else { return }
            let difference = offset - previousSuggestionsScrollOffset

            if difference > 0 { // Go Down
                textFieldBottomPadding = max(.maxInputPadding, textFieldBottomPadding - difference)
            } else { // Go Up
                textFieldBottomPadding = min(0, textFieldBottomPadding - difference)
            }
            previousSuggestionsScrollOffset = offset
            guard textFieldBottomPadding < 0 else {
                return
            }
            textFieldPaddingTask = Task {
                try? await Task.sleep(seconds: 0.5)
                guard !Task.isCancelled else { return }
                withAnimation(.bouncy) {
                    if textFieldBottomPadding >= .maxInputPadding / 2 {
                        textFieldBottomPadding = 0
                    } else {
                        textFieldBottomPadding = .maxInputPadding
                    }
                }
            }
        }
        .animation(.linear(duration: 0.2), value: inputHeight)
        .animation(.linear(duration: 0.2), value: isTextFieldPresented)
        .onChange(of: viewModel.isSuggestionsPresented) { _ in
            textFieldPaddingTask?.cancel()
            suggestionsScrollOffset = 0
            textFieldBottomPadding = 0
        }
    }

    var isChipsPresented: Bool {
        switch viewModel.logType {
        case .log:
            viewModel.isSuggestionsPresented && viewModel.mealSelectedState == .notSelected
        case .history:
            true
        case .quickAdd:
            viewModel.isQuickAddPresented
        case .addRecipe:
            true
        }
    }

    var inputHeight: CGFloat {
        isChipsPresented ? 121 : 80
    }

    var isTextFieldPresented: Bool {
        switch viewModel.mealSelectedState {
        case .notSelected:
            return textFieldBottomPadding > .maxInputPadding
        case .delete, .ingredient, .ingredientWeight, .mealWeight:
            return false
        case .addIngredients:
            return true
        }
    }

    private var canShowDoneButton: Bool {
        !isFocused &&
        hasItems &&
        viewModel.mealSelectedState.isNotSelected &&
        !viewModel.isSuggestionsPresented
    }

    private var hasItems: Bool {
        !viewModel.logItems.isEmpty
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let navBarSpacing: CGFloat = 8
    static let backButtonFontSize: CGFloat = 14
    static let horizontalPadding: CGFloat = 16
    static let textFieldSpacing: CGFloat = 12
    static let logButtonTrailingPadding: CGFloat = 10
    static let bottomPadding: CGFloat = 8
    static let horizontalChipsPadding: CGFloat = 10
    static let doneButtonOffset: CGFloat = -65

    static let maxInputPadding: CGFloat = -100
    static let logChipsHeight: CGFloat = 52
    static let chipsTopPadding: CGFloat = 10
}

#Preview {
    FoodLogInputView(isFocused: true,
                     viewModel: .init(input: .init(
                        mealType: .breakfast,
                        dayDate: .now,
                        context: .input,
                        initialMeal: [],
                        hasSubscription: false,
                        mealsCountInDay: 1),
                                      output: { _ in }))
}
