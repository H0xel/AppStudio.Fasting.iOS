//  
//  WeightGoalWidgetViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 22.03.2024.
//

import AppStudioNavigation
import AppStudioUI
import Foundation
import AppStudioModels
import Dependencies

class WeightGoalWidgetViewModel: BaseViewModel<WeightGoalWidgetOutput> {

    @Dependency(\.weightGoalService) private var weightGoalService

    var router: WeightGoalWidgetRouter!
    @Published var goal: WeightGoal = .empty
    @Published var currentWeight: WeightMeasure = .init(value: 0)
    @Published var startWeight: WeightMeasure = .init(value: 0)

    init(input: WeightGoalWidgetInput, output: @escaping WeightGoalWidgetOutputBlock) {
        super.init(output: output)
        input.currentWeightPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$currentWeight)
        input.startWeightPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$startWeight)
    }

    var goalWeight: WeightMeasure {
        goal.goalWeight
    }

    var progress: WeightMeasure {
        .init(value: currentWeight.value - startWeight.value, units: goal.weightUnit)
    }

    var daysSinceStart: Int {
        Int(Date().timeIntervalSince(goal.dateCreated) / .day) + 1
    }

    func presentGoalUpdate() {
        router.presentWeightUpdate(weightUnits: goal.goalWeight.units) { [weak self] output in
            switch output {
            case .save(let weight):
                self?.updateGoal(with: weight)
            }
        }
    }

    func updateGoal() {
        Task {
            let currentGoal = try await weightGoalService.currentGoal()
            await MainActor.run {
                goal = currentGoal
            }
        }
    }

    private func updateGoal(with newWeight: WeightMeasure) {
        guard newWeight.value > 0 else {
            return
        }
        let goal = WeightGoal(goal: newWeight.value, weightUnit: newWeight.units)
        Task { [weak self] in
            guard let self else { return }
            let newGoal = try await weightGoalService.save(goal)
            await MainActor.run {
                self.goal = newGoal
            }
        }
    }
}
