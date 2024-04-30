//  
//  DeepLinkService.swift
//  
//
//  Created by Amakhin Ivan on 24.04.2024.
//

import Combine

public protocol DeepLinkService {
    var deepLinkPublisher: AnyPublisher<DeepLink?, Never> { get }
    func set(_ deeplink: DeepLink)
    func reset()
}
