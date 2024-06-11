//
//  MealVotingViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 30.05.2024.
//

import Foundation
import AppStudioUI
import Dependencies

class MealVotingViewModel: BaseViewModel<Meal> {

    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.userPropertyService) private var userPropertyService
    @Dependency(\.mealService) private var mealService

    @Published private var mealVoting: MealVoting?
    private var meal: Meal
    private var votingTimeInterval: TimeInterval = .second * 3
    private var votingTimer: Timer?

    init(meal: Meal, output: @escaping (Meal) -> Void) {
        self.meal = meal
        super.init(output: output)
    }

    var voting: MealVoting {
        if let mealVoting {
            return mealVoting
        }
        return meal.voting
    }

    func vote(voting: MealVoting) {
        trackVoting(voting: voting)
        mealVoting = voting
        startVotingTimer()
    }

    func startVotingTimer() {
        if votingTimer == nil {
            votingTimer = Timer.scheduledTimer(withTimeInterval: .second, repeats: true) { [weak self] timer in
                self?.decreaseVotingTime()
                self?.checkVotings()
            }
        }
    }

    private func decreaseVotingTime() {
        votingTimeInterval -= .second
    }

    private func checkVotings() {
        if votingTimeInterval <= 0 {
            votingTimeInterval = .second * 3
            if let mealVoting {
                self.mealVoting = nil
                votingTimer?.invalidate()
                votingTimer = nil
                update(voting: mealVoting)
            }
        }
    }

    private func update(voting: MealVoting) {
        Task { [weak self] in
            guard let self else { return }
            self.meal.voting = voting
            let savedMeal = try await self.mealService.save(meal: meal)
            trackMealFeedback(meal: savedMeal)
            await MainActor.run {
                output(savedMeal)
            }
        }
    }

    private func trackVoting(voting: MealVoting) {
        switch voting {
        case .notVoted, .disabled:
            break
        case .like:
            trackerService.track(.tapLike)
        case .dislike:
            trackerService.track(.tapDislike)
        }
    }

    private func trackMealFeedback(meal: Meal) {
        guard meal.voting == .like || meal.voting == .dislike else {
            return
        }
        trackerService.track(.mealFeedbackSent(
            type: meal.voting == .like ? "like" : "dislike",
            name: meal.mealItem.mealName,
            calories: "\(Int(meal.calories))",
            carbs: "\(Int(meal.mealItem.nutritionProfile.carbohydrates))",
            fat: "\(Int(meal.mealItem.nutritionProfile.fats))",
            protein: "\(Int(meal.mealItem.nutritionProfile.proteins))",
            ingredients: "\(meal.mealItem.nameFromIngredients)")
        )
        if meal.voting == .like {
            userPropertyService.incrementProperty(property: "feedback_like_count", value: 1)
        } else {
            userPropertyService.incrementProperty(property: "feedback_dislike_count", value: 1)
        }
    }
}

