//
//  MessengerService.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 20.05.2023.
//

public protocol MessengerService: MessagePublisherService, MessageSubjectService {
    func initialize()
}
