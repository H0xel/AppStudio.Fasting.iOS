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
    case AuthenticationFailed = 2
    case NotFound = 3
    case OperationIsNotAllowed = 4
    case InternalError = 10
    case NoSubscription = 20
    case NotEnoughSubscriptionLevel = 21
    case NoAvailablePhoneNumbers = 30
    case PhoneNumberProvisionAlreadyCompleted = 31
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
