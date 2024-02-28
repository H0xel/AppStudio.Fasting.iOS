//  
//  CoachServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import Dependencies
import MunicornFoundation

private let didAgreeToTermsKey = "didAgreeToTermsKey"
private let isInitializedKey = "isInitializedKey"
private let userDataKey = "userDataKey"

class CoachServiceImpl: CoachService {

    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.coachMessageService) private var coachMessageService

    var userData: AICoachUserData {
        cloudStorage.userData ?? .empty
    }

    var isCoachEnable: Bool {
        cloudStorage.didAgreeToTerms
    }

    var isInitialized: Bool {
        cloudStorage.isInitialized
    }

    func updateUserData(_ data: AICoachUserData) {
        cloudStorage.userData = data
    }

    func setAsInitialized() {
        cloudStorage.isInitialized = true
    }

    func agreeToTerms() {
        cloudStorage.didAgreeToTerms = true
    }

    func reset() {
        cloudStorage.didAgreeToTerms = false
        cloudStorage.isInitialized = false
    }

    func deleteAllMessages() async  throws {
        try await coachMessageService.deleteAll()
    }
}

private extension CloudStorage {
    var didAgreeToTerms: Bool {
        get { get(key: didAgreeToTermsKey, defaultValue: false) }
        set { set(key: didAgreeToTermsKey, value: newValue) }
    }

    var isInitialized: Bool {
        get { get(key: isInitializedKey, defaultValue: false) }
        set { set(key: isInitializedKey, value: newValue) }
    }

    var userData: AICoachUserData? {
        get {
            let data: String? = get(key: userDataKey)
            return try? AICoachUserData(json: data ?? "")
        }
        set {
            set(key: userDataKey, value: newValue?.json())
        }
    }
}
