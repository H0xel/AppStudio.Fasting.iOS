//  
//  FacebookInitializerDependencies.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 07.02.2024.
//

import Dependencies

extension DependencyValues {
    var facebookInitializerService: FacebookInitializerService {
        self[FacebookInitializerServiceKey.self]
    }
}

private enum FacebookInitializerServiceKey: DependencyKey {
    static var liveValue: FacebookInitializerService = FacebookInitializerServiceImpl()
    static var previewValue: FacebookInitializerService = FacebookInitializerServicePreview()
}
