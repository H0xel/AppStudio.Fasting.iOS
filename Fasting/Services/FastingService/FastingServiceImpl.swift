//  
//  FastingServiceImpl.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

class FastingServiceImpl: FastingService {
    var isFastingRunning: Bool  = false
    let parameters = FastingParametersServiceImpl()

    func status() -> FastingStatus {
        if isFastingRunning {
            return .active(.init(interval: .hour, stage: .sugarRises, isFinished: false))
        }
        return .inActive(.left(.second * 30))
    }

    func startFasting() {
        isFastingRunning = true
    }

    func endFasting() {
        isFastingRunning = false
        parameters.clearCurrentDate()
    }
}
