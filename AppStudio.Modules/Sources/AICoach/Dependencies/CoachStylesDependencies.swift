//
//  CoachStylesDependencies.swift
//
//
//  Created by Руслан Сафаргалеев on 16.02.2024.
//

import Dependencies

extension DependencyValues {
    var styles: CoachStyles {
        self[CoachStylesKey.self]!
    }
}

enum CoachStylesKey: DependencyKey {
    static var liveValue: CoachStyles?
    static var previewValue: CoachStyles? = .mock
}
