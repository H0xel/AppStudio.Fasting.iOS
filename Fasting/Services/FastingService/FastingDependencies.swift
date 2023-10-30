//  
//  FastingDependencies.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Dependencies

extension DependencyValues {
    var fastingService: FastingService {
        self[FastingServiceKey.self]
    }
}

private enum FastingServiceKey: DependencyKey {
    static var liveValue: FastingService = FastingServiceImpl()
}
