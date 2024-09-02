//  
//  W2WLoadingService.swift
//  Fasting
//
//  Created by Amakhin Ivan on 28.08.2024.
//

import Combine

protocol W2WLoadingService {
    var isLoaded: AnyPublisher<Bool, Never> { get }
    func setLoaded()
}
