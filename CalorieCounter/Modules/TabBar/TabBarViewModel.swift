//  
//  TabBarViewModel.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.01.2024.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI
import Combine
import Dependencies

class TabBarViewModel: BaseViewModel<TabBarOutput> {

    @Dependency(\.trackerService) private var trackerService

    var router: TabBarRouter!
    @Published var activeTab: AppTab = .counter
    @Published var isTabBarPresented = true
    private let foodPickerSubject = PassthroughSubject<MealType, Never>()
    private let coachNextMessageSubject = CurrentValueSubject<String, Never>("")

    init(input: TabBarInput, output: @escaping TabBarOutputBlock) {
        super.init(output: output)
    }

    lazy var foodScreen: some View = {
        let input = FoodInput(presentFoodLogPublisher: foodPickerSubject.eraseToAnyPublisher())
        return router.foodScreen(input: input) { [weak self] output in
            switch output {
            case .switchTabBar(let isHidden):
                self?.switchTabBar(isHidden: isHidden)
            }
        }
    }()

    lazy var coachScreen: some View = {
        router.coachScreen(nextMessagePublisher: coachNextMessageSubject.eraseToAnyPublisher()) { [weak self] output in
            switch output {
            case .focusChanged(let isFocused):
                self?.switchTabBar(isHidden: isFocused)
            case .presentMultiplePaywall:
                break
            }
        }
    }()

    func changeTab(to tab: AppTab) {
        trackerService.track(.tabSwitched(currentTab: tab.rawValue, previousTab: activeTab.rawValue))
        activeTab = tab
        router.dismissRoutes()
    }

    func addMeal() {
        trackerService.track(.tapPlus)
        router.presentMealTypePicker(from: activeTab) { [weak self] type in
            DispatchQueue.main.async {
                self?.activeTab = .counter
                self?.foodPickerSubject.send(type)
            }
        }
    }

    private func switchTabBar(isHidden: Bool) {
        DispatchQueue.main.async {
            self.isTabBarPresented = !isHidden
        }
    }
}
