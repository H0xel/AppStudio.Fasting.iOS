//
//  AICoachUserData.swift
//  
//
//  Created by Руслан Сафаргалеев on 27.02.2024.
//

import Foundation

public struct AICoachUserData: Codable {
    let currentWeight: String
    let goalWeight: String
    let height: String
    let dateOfBirth: Date
    let sex: String

    public init(currentWeight: String,
                goalWeight: String,
                height: String,
                dateOfBirth: Date,
                sex: String) {
        self.currentWeight = currentWeight
        self.goalWeight = goalWeight
        self.height = height
        self.dateOfBirth = dateOfBirth
        self.sex = sex
    }
}

extension AICoachUserData {
    static var empty: AICoachUserData {
        .init(currentWeight: "",
              goalWeight: "",
              height: "",
              dateOfBirth: .now,
              sex: "")
    }
}
