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
    @Dependency(\.fastingLocalNotificationService) private var fastingLocalNotificationService
    @Dependency(\.storageService) private var storageService

    private var cancellables = Set<AnyCancellable>()
    private var fastingIntervalTrigger: CurrentValueSubject<FastingData, Never> = .init(.empty)

    var fastingIntervalPublisher: AnyPublisher <FastingInterval, Never> {
        fastingIntervalTrigger
            .map(\.interval)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }

    var isFastingProcess: Bool {
        get { cloudStorage.get(key: isFastingProcessKey, defaultValue: false) }
        set { cloudStorage.set(key: isFastingProcessKey, value: newValue)}
    }

    func startFastingProcess() async throws {
        isFastingProcess = true
        try await sync()
    }

    func endFastingProcess() async throws {
        isFastingProcess = false
        try await sync()
    }

    func set(currentDate date: Date) async throws {
        let parameters = try await self.fastingParametersRepository.update(currentDate: date.withoutSeconds)
        await update(interval: parameters.asInterval)
    }

    func clearCurrentDate() async throws {
        let parameters = try await self.fastingParametersRepository.clearCurrentDate()
        await update(interval: parameters.asInterval)
    }

    func set(fastingInterval interval: FastingInterval) async throws {
        var interval = interval
        if isFastingProcess {
            let currentParameters = try await self.fastingParametersRepository.current()
            interval.currentDate = currentParameters.currentDate
        }
        let parameters = try await self.fastingParametersRepository.save(interval: interval)
        await update(interval: parameters.asInterval)
    }
}

extension FastingParametersServiceImpl: AppInitializer {
    func initialize() {
        guard storageService.onboardingIsFinished else { return }
        Task { [unowned self] in
            let parameters = try await self.fastingParametersRepository.current()
            await update(interval: parameters.asInterval)
            subscribeForLocalNotifications()
        }
    }
}

extension FastingParametersServiceImpl {
    private func sync() async throws {
        let parameters = try await self.fastingParametersRepository.current()
        await update(interval: parameters.asInterval)
    }

    private func update(interval: FastingInterval) async {
        fastingIntervalTrigger.send(
            FastingData(interval: interval,
                        isFastingProcess: isFastingProcess)
        )
    }

    private func subscribeForLocalNotifications() {
        fastingIntervalTrigger
            .sink(with: self) { this, data in
                this.fastingLocalNotificationService
                    .updateNotifications(
                        interval: data.interval,
                        isProcessing: data.isFastingProcess
                    )
            }
            .store(in: &cancellables)
    }
}

private struct FastingData {
    let interval: FastingInterval
    let isFastingProcess: Bool

    static let empty = FastingData(interval: .empty, isFastingProcess: false)
}
