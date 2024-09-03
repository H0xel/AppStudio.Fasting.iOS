//
//  NutritionFoodErrors.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 18.06.2024.
//

import Foundation


// MARK: 400 error code
struct NutritionFoodBadRequest: Codable {
    let type: String?
    let title: String?
    let status: String?
    let detail: String?
    let instance: String?
}

// MARK: 500 error code
struct NutritionFoodInternalServerError: Codable {
    let error: NutritionFoodError
}

enum NutritionFoodErrorCode: Int16, Codable {
    case wrongParameters = 1
    case authenticationFailed = 2
    case notFound = 3
    case operationIsNotAllowed = 4
    case internalError = 10
    case noSubscription = 20
    case notEnoughSubscriptionLevel = 21
    case noAvailablePhoneNumbers = 30
    case phoneNumberProvisionAlreadyCompleted = 31
}

struct NutritionFoodError: Codable {
    let code: NutritionFoodErrorCode
    let message: String
    let traceId: String?
    let detail: NutritionFoodErrorDetail
}

struct NutritionFoodErrorDetail: Codable {
    let type: String
    let title: String
    let message: String?
    let errors: [NutritionFoodErrorValidationModel]?
}
struct NutritionFoodErrorValidationModel: Codable {
    let field: String
    let message: String
}
