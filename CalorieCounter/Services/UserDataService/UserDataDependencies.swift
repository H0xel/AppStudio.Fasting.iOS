//  
//  UserDataDependencies.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.01.2024.
//

import Dependencies

extension DependencyValues {
    var userDataService: UserDataService {
        self[UserDataServiceKey.self]
    }
}

private enum UserDataServiceKey: DependencyKey {
    static var liveValue: UserDataService = UserDataServiceImpl()
    static var previewValue: UserDataService = UserDataServicePreview()
}
