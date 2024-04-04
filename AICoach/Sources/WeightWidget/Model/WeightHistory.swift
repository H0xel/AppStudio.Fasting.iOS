//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 15.03.2024.
//

import Foundation
import AppStudioModels

public struct WeightHistory {
    public let id: String
    public let dateCreated: Date
    public let historyDate: Date
    public let scaleWeightValue: Double
    public let trueWeightValue: Double
    public let weightUnits: WeightUnit

    public init(id: String,
                dateCreated: Date,
                historyDate: Date,
                scaleWeightValue: Double,
                trueWeightValue: Double,
                weightUnits: WeightUnit) {
        self.id = id
        self.dateCreated = dateCreated
        self.scaleWeightValue = scaleWeightValue
        self.trueWeightValue = trueWeightValue
        self.weightUnits = weightUnits
        self.historyDate = historyDate
    }

    public init(scaleWeightValue: Double,
                trueWeightValue: Double,
                weightUnits: WeightUnit,
                historyDate: Date) {
        id = UUID().uuidString
        dateCreated = .now
        self.scaleWeightValue = scaleWeightValue
        self.trueWeightValue = trueWeightValue
        self.weightUnits = weightUnits
        self.historyDate = historyDate.beginningOfDay
    }
}

public extension WeightHistory {

    static var mock: WeightHistory {
        .init(id: UUID().uuidString,
              dateCreated: .now,
              historyDate: .now.beginningOfDay,
              scaleWeightValue: .random(in: 60...70),
              trueWeightValue: .random(in: 60...70),
              weightUnits: .kg)
    }

    var scaleWeight: WeightMeasure {
        .init(value: scaleWeightValue, units: weightUnits)
    }

    var trueWeight: WeightMeasure {
        .init(value: trueWeightValue, units: weightUnits)
    }

    func updated(trueWeight: Double) -> WeightHistory {
        .init(id: id,
              dateCreated: dateCreated,
              historyDate: historyDate,
              scaleWeightValue: scaleWeightValue,
              trueWeightValue: trueWeight,
              weightUnits: weightUnits)
    }

    func updated(scaleWeight: Double) -> WeightHistory {
        .init(id: id,
              dateCreated: dateCreated,
              historyDate: historyDate,
              scaleWeightValue: scaleWeight,
              trueWeightValue: trueWeightValue,
              weightUnits: weightUnits)
    }

    func updated(historyDate: Date) -> WeightHistory {
        .init(id: UUID().uuidString,
              dateCreated: .now,
              historyDate: historyDate,
              scaleWeightValue: scaleWeightValue,
              trueWeightValue: trueWeightValue,
              weightUnits: weightUnits)
    }
}
