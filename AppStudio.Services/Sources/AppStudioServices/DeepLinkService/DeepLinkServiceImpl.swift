//  
//  DeepLinkServiceImpl.swift
//  
//
//  Created by Amakhin Ivan on 24.04.2024.
//

import Combine
import Dependencies

class DeepLinkServiceImpl: DeepLinkService {
    @Dependency(\.trackerService) private var trackerService
    
    var deepLinkPublisher: AnyPublisher<DeepLink?, Never> {
        deepLInkTrigger.eraseToAnyPublisher()
    }
    private let deepLInkTrigger: CurrentValueSubject<DeepLink?, Never> = .init(nil)
    
    func set(_ deeplink: DeepLink) {
        deepLInkTrigger.send(deeplink)
        trackerService.track(.notificationTapped(type: deeplink))
    }
    
    func reset() {
        deepLInkTrigger.send(nil)
    }
}
