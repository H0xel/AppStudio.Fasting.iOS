//  
//  ProfileRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.11.2023.
//

import SwiftUI
import AppStudioNavigation
import Dependencies
import AppStudioStyles
import AppStudioModels

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

    func presentChooseFastingPlan() {
        let route = ChooseFastingPlanRoute(navigator: navigator, input: .init(context: .profile)) { event in
            switch event {
            case .onboardingIsFinished: break
            }
        }

        present(route: route)
    }

    func presentChangeSex(currentSex: Sex,
                          onSave: @escaping (Sex) -> Void) {
        let route = ChangeSexRoute(sex: currentSex, showDescription: false) { [weak self] in
            self?.dismiss()
        } onSave: { [weak self] sex in
            self?.dismiss()
            onSave(sex)
        }
        push(route: route)
    }

    func presentChangeBirthday(currentBirthday: Date,
                               onSave: @escaping (Date) -> Void) {
        let route = ChangeBirthdayRoute(birthday: currentBirthday, showDescription: false) { [weak self] in
            self?.dismiss()
        } onSave: { [weak self] date in
            self?.dismiss()
            onSave(date)
        }
        push(route: route)
    }

    func presentChangeHeight(currentHeight: HeightMeasure,
                             onSave: @escaping (HeightMeasure) -> Void) {
        let route = ChangeHeightRoute(height: currentHeight, showDescription: false) { [weak self] in
            self?.dismiss()
        } onSave: { [weak self] height in
            self?.dismiss()
            onSave(height)
        }
        push(route: route)
    }

    private func sendEmailWithOpenUrl() {
        Task {
            guard let url = URL(string: GlobalConstants.contactEmail) else { return }
            await openURL(url)
        }
    }
}
