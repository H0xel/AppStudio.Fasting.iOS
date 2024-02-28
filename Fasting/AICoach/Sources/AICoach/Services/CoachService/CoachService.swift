//  
//  CoachService.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

public protocol CoachService {
    var isInitialized: Bool { get }
    var isCoachEnable: Bool { get }
    var userData: AICoachUserData { get }
    func agreeToTerms()
    func setAsInitialized()
    func reset()
    func deleteAllMessages() async  throws
    func updateUserData(_ data: AICoachUserData)
}
