//  
//  MenstrualCycleCalendarRepositoryImpl.swift
//  PeriodTracker
//
//  Created by Denis Khlopin on 06.09.2024.
//
import Foundation
import Dependencies
import MunicornCoreData

class MenstrualCycleCalendarRepositoryImpl: CoreDataBaseRepository<MenstrualCycleCalendar> {
    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }
}

extension MenstrualCycleCalendarRepositoryImpl: MenstrualCycleCalendarRepository {
    func dates(type: CalendarDayType) async throws -> [MenstrualCycleCalendar] {
        let request = MenstrualCycleCalendar.request()
        request.predicate = NSPredicate(format: "type == %@", type.rawValue)
        request.sortDescriptors = [NSSortDescriptor(key: "dayDate", ascending: true)]
        return try await select(request: request)
    }

    func set(dates: [Date], type: CalendarDayType) async throws {
        for date in dates where (try await exists(date: date, type: type)) == nil {
            let calendar = MenstrualCycleCalendar(type: type, date: date)
            try await insert(calendar)
        }
    }

    func clear(dates: [Date], type: CalendarDayType) async throws {
        let request = MenstrualCycleCalendar.request()
        let dates = dates.map { $0.dayDate }.map { $0 as NSDate }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "type == %@", type.rawValue),
            NSPredicate(format: "dayDate IN %@", dates)
        ])
        let deleteRequest = MenstrualCycleCalendar.batchDeleteRequest(fetchRequest: request)
        try await delete(batchDeleteRequest: deleteRequest)
    }

    func exists(date: Date, type: CalendarDayType) async throws -> MenstrualCycleCalendar? {
        let request = MenstrualCycleCalendar.request()
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "type == %@", type.rawValue),
            NSPredicate(format: "dayDate == %@", date.dayDate as NSDate)
        ])
        return try await select(request: request).first
    }
}
