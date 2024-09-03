//  
//  RootInitializationService.swift
//  Fasting
//
//  Created by Amakhin Ivan on 07.08.2024.
//

import Combine

protocol RootInitializationService {
    var rootSetup: AnyPublisher<RootSetup, Never> { get }
}
