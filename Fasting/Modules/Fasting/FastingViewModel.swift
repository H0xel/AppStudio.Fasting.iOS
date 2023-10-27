//  
//  FastingViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import Foundation
import NotificationCenter

class FastingViewModel: BaseViewModel<FastingOutput> {
    var router: FastingRouter!

    init(input: FastingInput, output: @escaping FastingOutputBlock) {
        super.init(output: output)
        // initialization code here
    }

    func startFasting() {
        router.presentStartFastingDialog()
    }
}

protocol FastingService {
    func status(for date: Date) -> FastingStatus
    func startFasting(interval: FastingInterval)
}

struct FastingInterval {
    let start: Date
    let duration: TimeInterval
}

enum FastingStatus {
    case active(FastingActiveState)
    case inActive(FastingInterval)
}

enum FastingStage {
    case bloodSugarRises
}

struct FastingActiveState {
    let time: Date
    let stage: FastingStage
}
