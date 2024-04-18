//
//  WeightRepositoryDependencies.swift
//  
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Dependencies

extension DependencyValues {
    var weightHistoryRepository: WeightHistoryRepository {
        self[WeightHistoryRepositoryKey.self]
    }
}

private enum WeightHistoryRepositoryKey: DependencyKey {
    static var liveValue: WeightHistoryRepository = WeightHistoryRepositoryImpl()
}
