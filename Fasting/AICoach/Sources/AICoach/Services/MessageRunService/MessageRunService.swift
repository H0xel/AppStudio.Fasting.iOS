//  
//  MessageRunService.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 23.02.2024.
//

import Combine

protocol MessageRunService {
    var isRunningPublisher: AnyPublisher<Bool, Never> { get }
    func observeResponse(for message: CoachMessage)
    func observeDraftMessage()
}
