//
//  FastingWidgetView.swift
//  
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI
import Combine

public struct FastingWidgetView: View {

    private let day: Date
    @ObservedObject private var viewModel: FastingWidgetViewModel

    public init(day: Date, viewModel: FastingWidgetViewModel) {
        self.day = day
        self._viewModel = ObservedObject(wrappedValue: viewModel)
    }

    public var body: some View {
        switch viewModel.fastingState(for: day) {
        case .active(let state):
            ActiveFastingWidgetView(state: state)
        case .inactive(let state):
            InActiveFastingWidgetView(state: state)
        case let .finished(state, onLog):
            FinishedFastingWidgetView(state: state, onLog: onLog)
        }
    }
}

#Preview {
    FastingWidgetView(
        day: .now,
        viewModel: .init(
            input: .init(fastingStatePublisher: Just(.mockActive).eraseToAnyPublisher()),
            output: { _ in }
        )
    )
}
