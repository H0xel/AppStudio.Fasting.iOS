//  
//  FastingParametersServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation
import Dependencies
import Combine

private let isFastingProcessKey = "Fasting.isFastingProcessKey"

class FastingParametersServiceImpl: FastingParametersService {
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.fastingParametersRepository) private var fastingParametersRepository
    private var fastingIntervalTrigger: CurrentValueSubject<FastingInterval, Never> = .init(.empty)

    var fastingIntervalPublisher: AnyPublisher <FastingInterval, Never> {
        fastingIntervalTrigger
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var isFastingProcess: Bool {
        get { cloudStorage.get(key: isFastingProcessKey, defaultValue: false) }
        set { cloudStorage.set(key: isFastingProcessKey, value: newValue)}
    }

    func startFastingProcess() {
        isFastingProcess = true
    }

    func endFastingProcess() {
        isFastingProcess = false
    }

   func set(currentDate date: Date) {
        Task { [unowned self] in
            let parameters = try await self.fastingParametersRepository.update(currentDate: date)
            self.fastingIntervalTrigger.send(parameters.asInterval)
        }
    }

    func clearCurrentDate() {
        Task { [unowned self] in
            let parameters = try await self.fastingParametersRepository.clearCurrentDate()
            self.fastingIntervalTrigger.send(parameters.asInterval)
        }
    }

    func set(fastingInterval interval: FastingInterval) {
        Task { [unowned self] in
            let parameters = try await self.fastingParametersRepository.save(interval: interval)
            self.fastingIntervalTrigger.send(parameters.asInterval)
        }
    }
}

extension FastingParametersServiceImpl: AppInitializer {
    func initialize() {
        Task { [unowned self] in
            let parameters = try await self.fastingParametersRepository.current()
            self.fastingIntervalTrigger.send(parameters.asInterval)
        }
    }
}
