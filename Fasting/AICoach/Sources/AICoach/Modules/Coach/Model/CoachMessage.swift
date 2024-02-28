//
//  CoachMessage.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import Foundation

struct CoachMessage: Identifiable, Hashable, Codable {
    let id: String
    let runId: String
    let text: String
    let sender: CoachMessageSender
    let date: Date
}

extension CoachMessage {
    static func mockCoach(date: Date = .now) -> CoachMessage {
        .init(
            id: UUID().uuidString,
            runId: UUID().uuidString,
            text: "Use of height-adjustable standing desks and addition of movement (See Get Active Action Plan" +
            " Ideas) throughout your day can help reduce or break up extended periods of job-related sitting. At" +
            " home, getting up and moving at least once an hour can also combat the negative effects of sitting" +
            " too much.",
            sender: .coach,
            date: date
        )
    }

    static func mockCoachShort(date: Date = .now) -> CoachMessage {
        .init(
            id: UUID().uuidString,
            runId: UUID().uuidString,
            text: "Hello World!",
            sender: .coach,
            date: date
        )
    }

    static func mockCoachLong(date: Date = .now) -> CoachMessage {
        .init(
            id: UUID().uuidString,
            runId: UUID().uuidString,
            text: "Choose something that includes carbohydrates: this could be a banana, or low-fat natural yogurt," +
            " crackers with low-fat soft cheese, a smoothie or a glass of low-fat milk. Avoid foods high in fat or" +
            " fibre, as they take longer to digest and may cause stomach discomfort during exercise." +
            "||While you can eat something anywhere from 15 minutes to 2 hours before a workout, the closer it is to" +
            " the session, the smaller the quantity of food it should be, Collingwood says. “If it's 30 to 60 minutes" +
            " before a workout, have a snack in the 100- to 200-calorie range before the workout,” she says." +
            "||Here are 11 types of food and drink that Wiener advises avoiding pre-workout, plus his snack swap" +
            " recommendations:\nFibre-filled foods. ...\nEnergy drinks. ...\nNuts. ...\nCruciferous vegetables. " +
            "...\nRefined sugar. ...\nReady meals. ...\nDairy. ...\nFried foods.",
            sender: .coach,
            date: date
        )
    }

    static func mockUser(date: Date = .now) -> CoachMessage {
        .init(id: UUID().uuidString,
              runId: UUID().uuidString,
              text: "Ways to combat a sedentary lifestyle?",
              sender: .user,
              date: date)
    }

    static var initialMessageTermsNotAgree: CoachMessage {
        .init(id: UUID().uuidString,
              runId: UUID().uuidString,
              text: "CoachScreen.initialMessage.termsNotAgree".localized(bundle: .coachBundle),
              sender: .coach,
              date: .now)
    }

    static var initialMessageTermsAgree: CoachMessage {
        .init(id: UUID().uuidString,
              runId: UUID().uuidString,
              text: "CoachScreen.initialMessage.termsAgree".localized(bundle: .coachBundle),
              sender: .coach,
              date: .now)
    }
}
