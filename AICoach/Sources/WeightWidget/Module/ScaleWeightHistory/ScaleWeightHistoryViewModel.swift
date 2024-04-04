//  
//  ScaleWeightHistoryViewModel.swift
//  
//
//  Created by Руслан Сафаргалеев on 03.04.2024.
//

import AppStudioNavigation
import AppStudioUI
import Foundation
import Combine
import AppStudioModels
import Dependencies

struct ScaleWeight: Identifiable, Equatable {
    let id: String
    let weight: WeightMeasure
    let changeOverPrevDay: WeightMeasure?
    let date: Date
}

class ScaleWeightHistoryViewModel: BaseViewModel<Void> {

    @Dependency(\.weightService) private var weightService

    var router: ScaleWeightHistoryRouter!
    @Published var weight: [ScaleWeight] = []
    private var weightHistoryCancellable: AnyCancellable?
    private let weightUnits: WeightUnit

    init(weightPublisher: AnyPublisher<[WeightHistory], Never>,
         weightUnits: WeightUnit,
         router: ScaleWeightHistoryRouter) {
        self.router = router
        self.weightUnits = weightUnits
        super.init()
        observeWeight(weightPublisher)
    }

    func delete(weight: ScaleWeight) {
        Task {
            try await weightService.delete(byId: weight.id)
            updateTrueWeightIfNeeded(historyDate: weight.date)
        }
    }

    func update(weight: ScaleWeight) {
        router.presentWeightUpdate(date: weight.date, weightUnits: weight.weight.units) { [weak self] output in
            switch output {
            case .weightUpdated(let history):
                self?.updateTrueWeightIfNeeded(historyDate: history.historyDate)
            }
        }
    }

    func addWeight() {
        router.presentWeightUpdate(date: .now.beginningOfDay, weightUnits: weightUnits) { [weak self] output in
            switch output {
            case .weightUpdated(let history):
                self?.updateTrueWeightIfNeeded(historyDate: history.historyDate)
            }
        }
    }

    private func updateTrueWeightIfNeeded(historyDate: Date) {
        guard historyDate < .now.beginningOfDay else {
            return
        }
        Task {
            try await weightService.updateTrueWeight(after: historyDate.add(days: 1))
        }
    }

    private func observeWeight(_ publisher: AnyPublisher<[WeightHistory], Never>) {
        weightHistoryCancellable = publisher
            .sink { [weak self] history in
                self?.configureScaleWeight(from: history)
            }
    }

    private func configureScaleWeight(from history: [WeightHistory]) {
        var lastHistory: WeightHistory?
        var result: [ScaleWeight] = []
        for history in history {
            let changeOverPrevDay: WeightMeasure? = if let lastHistory {
                .init(value: history.scaleWeightValue - lastHistory.scaleWeightValue,
                      units: history.weightUnits)
            } else {
                nil
            }
            let weight = ScaleWeight(id: history.id,
                                     weight: history.scaleWeight,
                                     changeOverPrevDay: changeOverPrevDay,
                                     date: history.historyDate)
            result.append(weight)
            lastHistory = history
        }
        DispatchQueue.main.async {
            self.weight = result.reversed()
        }
    }
}
