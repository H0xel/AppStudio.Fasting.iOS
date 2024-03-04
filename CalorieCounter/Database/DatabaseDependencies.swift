//
//  DatabaseDependencies.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 21.12.2023.
//

import Dependencies
import MunicornCoreData

extension DependencyValues {
    var coreDataService: CoreDataService {
        self[CoreDataServiceKey.self]
    }

    var mealRepository: MealRepository {
        self[MealRepositoryKey.self]
    }

    var nutritionProfileRepository: NutritionProfileRepository {
        self[NutritionProfileRepositoryKey.self]
    }

    var codableCacheRepository: CodableCacheRepository {
        self[CodableCacheRepositoryKey.self]
    }
}

private enum CoreDataServiceKey: DependencyKey {
    static let liveValue = MunicornCoreDataFactory.instance.coreDataService
    static let testValue = MunicornCoreDataFactory.instance.coreDataService
}

private enum MealRepositoryKey: DependencyKey {
    static let liveValue: MealRepository = MealRepositoryImpl()
    static let testValue: MealRepository = MealRepositoryImpl()
}

private enum NutritionProfileRepositoryKey: DependencyKey {
    static let liveValue: NutritionProfileRepository = NutritionProfileRepositoryImpl()
    static let testValue: NutritionProfileRepository = NutritionProfileRepositoryImpl()
}

private enum CodableCacheRepositoryKey: DependencyKey {
    static let liveValue: CodableCacheRepository = CodableCacheRepositoryImpl()
    static let testValue: CodableCacheRepository = CodableCacheRepositoryImpl()
}
