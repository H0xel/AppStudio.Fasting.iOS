//  
//  NotificationsForStagesViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 18.06.2024.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI

class NotificationsForStagesViewModel: BaseViewModel<NotificationsForStagesOutput> {
    var router: NotificationsForStagesRouter!
    @Published var selectedStages: Set<FastingStage> = []

    init(input: NotificationsForStagesInput, output: @escaping NotificationsForStagesOutputBlock) {
        selectedStages = Set(input.selectedStages)
        super.init(output: output)
    }

    func stageSelected(stage: FastingStage) {
        selectedStages.insert(stage)
    }

    func stageDeselected(stage: FastingStage) {
        selectedStages.remove(stage)
    }

    func saveTapped() {
        output(.save(Array(selectedStages)))
    }

    func closeTapped() {
        output(.close)
    }
}
