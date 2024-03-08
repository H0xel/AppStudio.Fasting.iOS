//
//  FastingParametersRepositoryImpl.swift
//  Fasting
//
//  Created by Denis Khlopin on 31.10.2023.
//

import Foundation
import Dependencies
import MunicornCoreData

class FastingParametersRepositoryImpl: CoreDataBaseRepository<FastingParameters>, FastingParametersRepository {

    init() {
        @Dependency(\.coreDataService) var coreDataService
        super.init(coreDataService: coreDataService)
    }

    func current() async throws -> FastingParameters {
        if let current = try await getCurrentParameters() {
            return current
        }
        // create new default parameters
        let newDefault = try await save(.defaultParameters)
        return newDefault
    }

    func update(currentDate: Date) async throws -> FastingParameters {
        var currentParameters = try await current()
        currentParameters.currentDate = currentDate

        return try await save(currentParameters)
    }

    func clearCurrentDate() async throws -> FastingParameters {
        var currentParameters = try await current()
        currentParameters.currentDate = nil

        return try await save(currentParameters)
    }

    func save(interval: FastingInterval) async throws -> FastingParameters {
        let currentParameters = try await current()
        let currentInterval = currentParameters.asInterval
        let isChanged = currentInterval.isParametersChanged(interval)

        if interval == currentInterval {
            return currentParameters
        }

        var newParameters = isChanged ? interval.asNewParameters : currentParameters
        newParameters.currentDate = interval.currentDate

        return try await save(newParameters)
    }

    func parameters(for date: Date) async throws -> FastingParameters {
        let request = FastingParameters.request()
        request.predicate = .init(format: "creationDate <= %@", date as NSDate)
        request.sortDescriptors = [.init(key: "creationDate", ascending: false)]
        request.fetchLimit = 1
        if let parameter = try await select(request: request).first {
            return parameter
        }
        return try await current()
    }

    private func getCurrentParameters() async throws -> FastingParameters? {
        let request = FastingParameters.request()
        request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        request.fetchLimit = 1
        return try await select(request: request).first
    }
}

extension FastingInterval {
    var asNewParameters: FastingParameters {
        FastingParameters(id: UUID().uuidString,
                          start: self.start,
                          plan: self.plan,
                          currentDate: self.currentDate,
                          creationDate: .now)
    }
}

private extension FastingParameters {
    static let defaultParameters = FastingParameters(id: UUID().uuidString,
                                                     start: .now.withoutSeconds,
                                                     plan: .beginner,
                                                     currentDate: nil,
                                                     creationDate: .now)
}
