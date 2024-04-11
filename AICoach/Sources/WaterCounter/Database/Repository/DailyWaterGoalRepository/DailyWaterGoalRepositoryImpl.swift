//  
//  DailyWaterGoalRepositoryImpl.swift
//  
//
//  Created by Denis Khlopin on 14.03.2024.
//
import MunicornCoreData
import Foundation
import Dependencies

class DailyWaterGoalRepositoryImpl: CoreDataBaseRepository<DailyWaterGoal>,  DailyWaterGoalRepository {

    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }

    func goal() async throws -> DailyWaterGoal {
        let request = DailyWaterGoal.request()
        request.sortDescriptors = [.init(key: "date", ascending: false)]
        request.fetchLimit = 1

        if let result = try await select(request: request).first {
            return result
        }
        @Dependency(\.waterIntakeService) var waterIntakeService
        if let waterIntake = waterIntakeService.waterIntake {
            return try await set(goal: DailyWaterGoal(quantity: waterIntake, date: .now))
        }
        return DailyWaterGoal.default
    }
    
    func goal(at date: Date) async throws -> DailyWaterGoal? {
        let date = date.startOfTheDay

        let request = DailyWaterGoal.request()
        request.predicate = NSPredicate(format: "date <= %@", date as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1

        return try await select(request: request).first
    }

    private func exactGoal(at date: Date) async throws -> DailyWaterGoal? {
        let date = date.startOfTheDay

        let request = DailyWaterGoal.request()
        request.predicate = NSPredicate(format: "date == %@", date as NSDate)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = 1

        return try await select(request: request).first
    }

    func goals(from: Date, to: Date) async throws -> [DailyWaterGoal] {
        let request = DailyWaterGoal.request()
        request.sortDescriptors = [.init(key: "date", ascending: false)]
        request.predicate = NSPredicate(format: "date >= %@ and date <= %@",
                                        from.startOfTheDay as NSDate, to.endOfDay as NSDate)
        return try await select(request: request)
    }
    
    func set(goal: DailyWaterGoal) async throws -> DailyWaterGoal {
        if var existedGoal = try await self.exactGoal(at: goal.date) {
            existedGoal.quantity = goal.quantity
            return try await save(existedGoal)
        }
        return try await save(goal)
    }
}
