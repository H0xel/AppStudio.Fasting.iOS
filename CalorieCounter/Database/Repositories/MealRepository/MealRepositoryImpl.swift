//
//  MealRepositoryImpl.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 21.12.2023.
//

import Foundation
import MunicornCoreData
import Dependencies

typealias MealObserver = CoreDataObserver<Meal>

class MealRepositoryImpl: CoreDataBaseRepository<Meal> {
    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }
}

extension MealRepositoryImpl: MealRepository {

    func mealObserver(dayDate: Date) -> MealObserver {
        @Dependency(\.coreDataService) var coreDataService
        let observer = MealObserver(coreDataService: coreDataService)
        let request = Meal.request()
        request.predicate = .init(format: "dayDate == %@", dayDate.beginningOfDay as NSDate)
        request.sortDescriptors = [.init(key: "creationDate", ascending: false)]
        observer.fetch(request: request)
        return observer
    }

    func save(meal: Meal) async throws -> Meal {
        try await save(meal)
    }

    func meals(forDay dayDate: Date, type: MealType?) async throws -> [Meal] {
        let dayDate = dayDate.beginningOfDay
        let request = Meal.request()
        var predicates: [NSPredicate] = [
            NSPredicate(format: "dayDate == %@", dayDate as NSDate)
        ]
        if let type {
            predicates.append(NSPredicate(format: "type == %@", type.rawValue))
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [.init(key: "creationDate", ascending: false)]

        return try await select(request: request)
    }

    func meals(for dates: [Date]) async throws -> [Meal] {
        let request = Meal.request()
        let predicate = NSPredicate(format: "dayDate IN %@", dates.map { $0 as NSDate })
        request.predicate = predicate
        return try await select(request: request)
    }
}
