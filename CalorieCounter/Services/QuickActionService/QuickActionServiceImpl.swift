//
//  QuickActionServiceImpl.swift
//  Fasting
//
//  Created by Amakhin Ivan on 26.12.2023.
//

import Combine

class QuickActionServiceImpl: QuickActionService {
    var quickActiveType: AnyPublisher<QuickAction?, Never> {
        activeTypeTrigger.eraseToAnyPublisher()
    }

    private let activeTypeTrigger = CurrentValueSubject<QuickAction?, Never>(nil)

    func set(_ type: QuickAction?) {
        activeTypeTrigger.send(type)
    }

    func resetType() {
        activeTypeTrigger.send(nil)
    }
}
