//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 20.02.2024.
//

import Dependencies

extension DependencyValues {
    var suggestedQuestionsService: SuggestedQuestionsService {
        self[SuggestedQuestionsServiceKey.self]
    }
}

private enum SuggestedQuestionsServiceKey: DependencyKey {
    static var liveValue: SuggestedQuestionsService = SuggestedQuestionsServiceImpl()
}
