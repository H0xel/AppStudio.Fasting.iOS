//  
//  ProfileRouter.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.01.2024.
//

import SwiftUI
import AppStudioNavigation
import Dependencies

class ProfileRouter: BaseRouter {
    @Dependency(\.openURL) private var openURL

    func open(url: URL) {
        let route = SafariRoute(url: url) { [weak self] in
            self?.dismiss()
        }
        present(route: route)
    }

    func presentSupport() {
        guard EmailRoute.canPresent else {
            sendEmailWithOpenUrl()
            return
        }
        let subject = NSLocalizedString("ProfileScreen.supportEmailSubject", comment: "")
        let route = EmailRoute(recipient: GlobalConstants.contactEmail, subject: subject) { [weak self] in
            self?.dismiss()
        }
        present(route: route)
    }

    func presentDailyCalorie(input: DailyCalorieBudgetInput, output: @escaping DailyCalorieBudgetOutputBlock) {
        let route = DailyCalorieBudgetRoute(navigator: navigator,
                                            mode: .profileInfo,
                                            input: input,
                                            output: output)
        present(route: route)
    }

    func presentChangeSex(currentSex: Sex,
                          onDismiss: @escaping() -> Void,
                          onSave: @escaping (Sex) -> Void) {
        let route = ChangeSexRoute(sex: currentSex) { [weak self] in
            self?.dismiss()
            onDismiss()
        } onSave: { [weak self] sex in
            self?.dismiss()
            onSave(sex)
        }
        push(route: route)
    }

    func presentChangeBirthday(currentBirthday: Date,
                               onDismiss: @escaping() -> Void,
                               onSave: @escaping (Date) -> Void) {
        let route = ChangeBirthdayRoute(birthday: currentBirthday) { [weak self] in
            self?.dismiss()
            onDismiss()
        } onSave: { [weak self] date in
            self?.dismiss()
            onSave(date)
        }
        push(route: route)
    }

    func presentChangeHeight(currentHeight: HeightMeasure,
                             onDismiss: @escaping() -> Void,
                             onSave: @escaping (HeightMeasure) -> Void) {
        let route = ChangeHeightRoute(height: currentHeight) { [weak self] in
            self?.dismiss()
            onDismiss()
        } onSave: { [weak self] height in
            self?.dismiss()
            onSave(height)
        }
        push(route: route)
    }

    func presentChageGoal(steps: [OnboardingFlowStep], output: @escaping OnboardingOutputBlock) {
        let route = OnboardingRoute(navigator: navigator,
                                    input: .init(context: .planChange, steps: steps),
                                    output: output)
        present(route: route)
    }

    private func sendEmailWithOpenUrl() {
        Task {
            guard let url = URL(string: GlobalConstants.contactEmail) else { return }
            await openURL(url)
        }
    }
}
