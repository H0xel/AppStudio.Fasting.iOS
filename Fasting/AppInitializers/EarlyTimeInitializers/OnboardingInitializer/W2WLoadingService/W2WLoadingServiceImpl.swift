//  
//  W2WLoadingServiceImpl.swift
//  Fasting
//
//  Created by Amakhin Ivan on 28.08.2024.
//

import Combine

class W2WLoadingServiceImpl: W2WLoadingService {
    var isLoaded: AnyPublisher<Bool, Never> {
        isLoadedTrigger.eraseToAnyPublisher()
    }

    private var isLoadedTrigger = PassthroughSubject<Bool, Never>()

    func setLoaded() {
        isLoadedTrigger.send(true)
    }
}
