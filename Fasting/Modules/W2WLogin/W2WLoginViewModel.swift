//  
//  W2WLoginViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.06.2024.
//

import AppStudioNavigation
import AppStudioUI
import Dependencies
import SwiftUI
import MunicornFoundation
import AppStudioFoundation

class W2WLoginViewModel: BaseViewModel<W2WLoginOutput> {
    @Published var emailText = "" {
        didSet {
            DispatchQueue.main.async {
                self.isButtonEnabled = true
                self.errorState = nil
            }
        }
    }
    @Published var isButtonEnabled = true
    @Published var errorState: W2WError?

    @Dependency(\.onboardingApi) private var onboardingAPI
    @Dependency(\.onboardingService) private var onboardingService
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.newSubscriptionService) private var newSubscriptionService

    private let context: W2WLoginInput.Context

    var router: W2WLoginRouter!

    init(input: W2WLoginInput, output: @escaping W2WLoginOutputBlock) {
        context = input.context
        super.init(output: output)
    }

    func backButtonTapped() {
        output(.close)
    }

    func signInTapped() {
        guard emailText.isValidEmail() else {
            errorState = .invalidEmail
            isButtonEnabled = false
            return
        }

        Task { @MainActor in
            do {
                let onboardingData = try await onboardingAPI.onboarding(.init(clientEmail: emailText))
                guard let onboardingData = onboardingData.onboarding else {
                    errorState = .accountNotFound
                    return
                }
                newSubscriptionService.restoreWithoutAppstore()

                if context == .onboarding {
                    onboardingService.save(data: .init(onboardingData))
                    cloudStorage.userWithOnboardingApi = true
                }

                cloudStorage.w2wUserEmail = emailText
                output(.userSaved)
            } catch {
                errorState = .internetConnection
            }
        }
    }
}

enum W2WError: String {
    case invalidEmail
    case accountNotFound
    case internetConnection

    var title: String {
        NSLocalizedString("W2W.error.\(rawValue)", comment: "error")
    }
}

private let userWithOnboardingApiKey = "AppStudio.w2wUserKey"
extension CloudStorage {
    var w2wUserEmail: String? {
        set { set(key: userWithOnboardingApiKey, value: newValue) }
        get { get(key: userWithOnboardingApiKey) }
    }
}
