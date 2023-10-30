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
import SwiftUI

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

enum FastingStage: String, CaseIterable, Equatable {
    case sugarRises
    case sugarDrop
    case sugarNormal
    case burning
    case ketosis
    case autophagy

    var backgroundColor: Color {
        switch self {
        case .autophagy:
            return .fastingBlueLight
        case .burning:
            return .fastingOrange
        case .ketosis:
            return .fastingGreen
        case .sugarDrop:
            return .fastingPurple
        case .sugarNormal:
            return .fastingRed
        case .sugarRises:
            return .fastingBlue
        }
    }

    var whiteImage: Image {
        Image("\(rawValue)White")
    }

    var disabledImage: Image {
        Image("\(rawValue)Disabled")
    }

    var coloredImage: Image {
        Image("\(rawValue)Enabled")
    }

    static func > (lhs: FastingStage, rhs: FastingStage) -> Bool {
        guard let leftIndex = FastingStage.allCases.firstIndex(of: lhs),
              let rightIndex = FastingStage.allCases.firstIndex(of: rhs) else {
                  return true
              }
        return leftIndex > rightIndex
    }
}

struct FastingActiveState {
    let time: Date
    let stage: FastingStage
}
