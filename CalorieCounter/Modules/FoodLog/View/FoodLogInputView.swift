//
//  FoodLogInputView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 18.05.2024.
//

import SwiftUI
import AppStudioStyles
import Combine

struct FoodLogInputView: View {

    let isPresented: Bool
    @StateObject var viewModel: FoodLogInputViewModel

    var body: some View {
        view
            .onAppear {
                viewModel.onAppear()
            }
    }

    @ViewBuilder
    var view: some View {
        switch viewModel.logType {
        case .log, .history:
            FoodLogHistoryView(logType: viewModel.logType,
                               isPresented: isPresented,
                               viewModel: viewModel.historyViewModel)
        case .quickAdd:
            QuickAddView(viewModel: viewModel.quickAddViewModel)
                .opacity(viewModel.logType == .quickAdd ? 1 : 0)
        case .addRecipe:
            Color.clear.frame(height: 1)
        }
    }
}

#Preview {
    FoodLogInputView(
        isPresented: true,
        viewModel: .init(
            router: .init(navigator: .init()),
            input: .init(
                mealTypePublisher: Just(.breakfast).eraseToAnyPublisher(),
                dayDate: .now,
                isKeyboardFocused: true,
                hasSubscription: false,
                shouldPresentScannerOnAppear: false,
                mealPublisher: Just([]).eraseToAnyPublisher(),
                editQuickAddPublisher: Just(.mock).eraseToAnyPublisher()),
            output: { _ in })
    )
}
