//  
//  MessageRunDependencies.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 23.02.2024.
//

import Dependencies

extension DependencyValues {
    var messageRunService: MessageRunService {
        self[MessageRunServiceKey.self]
    }
}

private enum MessageRunServiceKey: DependencyKey {
    static var liveValue: MessageRunService = MessageRunServiceImpl()
}
