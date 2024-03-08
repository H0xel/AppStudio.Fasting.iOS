//  
//  HealthProgressViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 04.03.2024.
//

import AppStudioNavigation
import AppStudioUI
import Foundation
import Combine
import Dependencies
import MunicornFoundation

private let isBodyMassIndexHintPresentedKey = "isBodyMassIndexHintPresented"

class HealthProgressViewModel: BaseViewModel<HealthProgressOutput> {

    @Dependency(\.storageService) private var storageService

    var router: HealthProgressRouter!
    @Published var isBodyMassHintPresented = true
    @Published var bodyMassIndex: Double = 0
    @Published var fastingChartItems: [HealthProgressBarChartItem] = []
    private var inputCancellable: AnyCancellable?

    init(inputPublisher: AnyPublisher<FastingHealthProgressInput, Never>,
         output: @escaping HealthProgressOutputBlock) {
        super.init(output: output)
        observeInput(inputPublisher: inputPublisher)
        isBodyMassHintPresented = storageService.isBodyMassIndexHintPresented
    }

    func closeBodyMassIndexHint() {
        isBodyMassHintPresented = false
        storageService.isBodyMassIndexHintPresented = false
    }

    func presentFastingInfo() {
        router.presentFastingHint { [weak self] question in
            self?.output(.novaQuestion(question))
        }
    }

    func presentBodyMassIndexInfo() {
        router.presentBodyMassIndexHint(bodyMassIndex: bodyMassIndex.bodyMassIndex) { [weak self] question in
            self?.output(.novaQuestion(question))
        }
    }

    private func observeInput(inputPublisher: AnyPublisher<FastingHealthProgressInput, Never>) {
        inputCancellable = inputPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] input in
                self?.bodyMassIndex = input.bodyMassIndex
                self?.fastingChartItems = input.fastingChartItems
            }
    }
}

private extension StorageService {
    var isBodyMassIndexHintPresented: Bool {
        get { get(key: isBodyMassIndexHintPresentedKey, defaultValue: true) }
        set { set(key: isBodyMassIndexHintPresentedKey, value: newValue) }
    }
}
