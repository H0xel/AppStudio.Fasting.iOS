//
//  DatabaseDependencies.swift
//  Fasting
//
//  Created by Denis Khlopin on 31.10.2023.
//

import Dependencies
import MunicornCoreData

extension DependencyValues {

    var coreDataService: CoreDataService {
        self[CoreDataServiceKey.self]
    }

    var fastingParametersRepository: FastingParametersRepository {
        self[FastingParametersRepositoryKey.self]
    }
}

private enum FastingParametersRepositoryKey: DependencyKey {
    static let liveValue: FastingParametersRepository = FastingParametersRepositoryImpl()
    static let testValue: FastingParametersRepository = FastingParametersRepositoryImpl()
}

private enum CoreDataServiceKey: DependencyKey {
    static let liveValue = MunicornCoreDataFactory.instance.coreDataService
    static let testValue = MunicornCoreDataFactory.instance.coreDataService
}
