//
//  QuickActionService.swift
//  Fasting
//
//  Created by Amakhin Ivan on 26.12.2023.
//

import Combine

protocol QuickActionService {
    var quickActiveType: AnyPublisher<QuickAction?, Never> { get }

    func set(_ type: QuickAction?)
    func resetType()
}
