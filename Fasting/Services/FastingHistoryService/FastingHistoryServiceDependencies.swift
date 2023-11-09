//  
//  FastingHistoryServiceDependencies.swift
//  Fasting
//
//  Created by Denis Khlopin on 09.11.2023.
//

import Dependencies

extension DependencyValues {
    var fastingHistoryServiceService: FastingHistoryServiceService {
        self[FastingHistoryServiceServiceKey.self]
    }
}

private enum FastingHistoryServiceServiceKey: DependencyKey {
    static var liveValue: FastingHistoryServiceService = FastingHistoryServiceServiceImpl()
    static var testValue: FastingHistoryServiceService = FastingHistoryServiceServiceImpl()
}
