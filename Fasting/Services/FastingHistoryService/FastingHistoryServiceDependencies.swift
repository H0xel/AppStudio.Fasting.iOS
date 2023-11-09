//  
//  FastingHistoryServiceDependencies.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//

import Dependencies

extension DependencyValues {
    var fastingHistoryService: FastingHistoryService {
        self[FastingHistoryServiceKey.self]
    }
}

private enum FastingHistoryServiceKey: DependencyKey {
    static var liveValue: FastingHistoryService = FastingHistoryServiceImpl()
    static var testValue: FastingHistoryService = FastingHistoryServiceImpl()
}
