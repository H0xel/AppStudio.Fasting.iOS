//  
//  FastingParametersDependencies.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Dependencies

extension DependencyValues {
    var fastingParametersService: FastingParametersService {
        fastingParametersServiceImpl
    }

    var fastingParametersInitializer: AppInitializer {
        fastingParametersServiceImpl
    }

    private var fastingParametersServiceImpl: FastingParametersServiceImpl {
        self[FastingParametersServiceImplKey.self]
    }
}

private enum FastingParametersServiceImplKey: DependencyKey {
    static var liveValue = FastingParametersServiceImpl()
    static var testValue = FastingParametersServiceImpl()
}
