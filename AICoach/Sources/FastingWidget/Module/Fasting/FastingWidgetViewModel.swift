//
//  FastingWidgetViewModel.swift
//  
//
//  Created by Руслан Сафаргалеев on 12.03.2024.
//

import Dependencies
import AppStudioUI
import Foundation
import Combine
import AppStudioModels

public class FastingWidgetViewModel: BaseViewModel<FastingWidgetOutput> {

    @Dependency(\.fastingWidgetService) private var fastingWidgetService

    @Published var currentFastingState: FastingWidgetState = .inactive(.empty)
    @Published private var fastingStateStore: [Date: FastingWidgetState] = [:]

    public init(input: FastingWidgetInput, output: @escaping ViewOutput<FastingWidgetOutput>) {
        super.init(output: output)
        observeFastingState(publisher: input.fastingStatePublisher)
    }

    func fastingState(for date: Date) -> FastingWidgetState {
        date == .now.startOfTheDay ? currentFastingState : fastingStateStore[date] ?? currentFastingState
    }

    public func loadData(weeks: [Week]) {
        Task { [weak self] in
            guard let self else { return }
            let state = try await fastingWidgetService.fastingState(for: weeks)
            var store = fastingStateStore
            for (day, state) in state {
                store[day] = .finished(state) { id in
                    if let id {
                        self.output(.updateFasting(fastingId: id))
                    } else {
                        self.output(.logFasting(date: day))
                    }
                }
            }
            await MainActor.run { [store] in
                self.fastingStateStore = store
            }
        }
    }

    private func observeFastingState(publisher: AnyPublisher<FastingWidgetState, Never>) {
        publisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentFastingState)
    }
}
