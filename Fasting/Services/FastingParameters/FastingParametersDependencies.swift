//  
//  FastingParametersDependencies.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Dependencies

extension DependencyValues {
    var FastingParametersService: FastingParametersService {
        self[FastingParametersServiceKey.self]
    }
}

private enum FastingParametersServiceKey: DependencyKey {
    static var liveValue: FastingParametersService = FastingParametersServiceImpl()
}
