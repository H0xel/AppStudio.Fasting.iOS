//
//  FoodLogHistoryView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 04.06.2024.
//

import SwiftUI
import Combine
import AppStudioUI

struct FoodLogHistoryView: View {

    let logType: LogType
    let isPresented: Bool
    @StateObject var viewModel: FoodHistoryViewModel
    @State private var suggestionsScrollOffset: CGFloat = 0
    @FocusState private var isFocused: Bool
    @State private var numberOfLines = 1


    var body: some View {
        ZStack {
            FoodSuggestionsView(
                scrollOffset: $suggestionsScrollOffset,
                isFocused: isFocused,
                inputHeight: inputHeight,
                logType: logType,
                viewModel: viewModel.foodSuggestionsViewModel
            )
            .id(viewModel.mealType)
            .aligned(.bottom)
            VStack(spacing: .zero) {
                textFieldView
                    .onViewHeightPreferenceKeyChange { height in
                        numberOfLines = Int((height / .lineHeight).rounded(.up))
                    }
                if canShowChips {
                    LogChipsView(logType: logType) { type in
                        viewModel.changeLogType(to: type, isFocused: isFocused)
                    } onClose: {
                        viewModel.changeLogType(to: .log, isFocused: isFocused)
                    }
                }
            }
            .aligned(.bottom)
            .modifier(HideOnScrollModifier(scrollOffset: suggestionsScrollOffset,
                                           canHide: !isFocused && viewModel.suggestionsState.isPresented))
        }
        .onChange(of: viewModel.suggestionsState) { state in
            suggestionsScrollOffset = 0
            isFocused = state.isKeyboardFocused
        }
        .onAppear {
            isFocused = viewModel.suggestionsState.isKeyboardFocused
        }
        .onChange(of: isPresented) { isPresented in
            if !isPresented {
                isFocused = false
            }
        }
    }

    private var canShowChips: Bool {
        if logType == .log {
            return viewModel.suggestionsState.isPresented || viewModel.suggestionsState.isKeyboardFocused
        }
        return true
    }

    private var inputHeight: CGFloat {
        let extraLinesHeight = CGFloat(numberOfLines - 1) * .lineHeight
        if logType == .log {
            return (canShowChips ? 124 : 80) + extraLinesHeight
        }
        return 124 + extraLinesHeight
    }

    private var textFieldView: some View {
        FoodLogTextField(text: $viewModel.mealRequest,
                         context: .addMeal,
                         showTopBorder: false,
                         onTap: viewModel.logMeal(text:),
                         onBarcodeScan: { accessGranted in
            viewModel.trackBarcodeScannerOpen()
            viewModel.barcodeScan(accessGranted: accessGranted)
        })
        .focused($isFocused)
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
        .background(.white)
    }

    private var canShowDoneButton: Bool {
        !isFocused &&
        viewModel.hasMeals &&
        !viewModel.suggestionsState.isPresented
    }
}

private extension CGFloat {
    static let logButtonTrailingPadding: CGFloat = 10
    static let doneButtonOffset: CGFloat = -65
    static let lineHeight: CGFloat = 23
}

#Preview {
    FoodLogHistoryView(
        logType: .history,
        isPresented: true,
        viewModel: .init(
            input: .init(
                mealTypePublusher: Just(.breakfast).eraseToAnyPublisher(),
                dayDate: .now,
                suggestionsState: .init(isPresented: true, isKeyboardFocused: true),
                hasSubscription: false,
                presentScannerPublusher: Just(()).eraseToAnyPublisher(),
                mealPublisher: Just([]).eraseToAnyPublisher()),
            router: .init(navigator: .init()),
            output: { _ in })
    )
}
