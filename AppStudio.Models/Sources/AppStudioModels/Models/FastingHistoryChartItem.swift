//
//  FastingHistoryChartItem.swift
//
//
//  Created by Amakhin Ivan on 22.03.2024.
//

import SwiftUI

public struct FastingHistoryChartItem: Identifiable, Equatable {
    public let id = UUID()
    public let value: Double
    public let lineValue: Double
    public let date: Date
    public let stage: FastingHistoryStage

    public init(value: Double, lineValue: Double, date: Date, stage: FastingHistoryStage) {
        self.value = value
        self.lineValue = lineValue
        self.date = date
        self.stage = stage
    }
}


public extension [FastingHistoryChartItem] {
    static var mock: [FastingHistoryChartItem] {
        [
            .init(value: 4, lineValue: 16, date: .now.add(days: -80), stage: .sugarDrop),
            .init(value: 4, lineValue: 16, date: .now.add(days: -79), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -78), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -77), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -76), stage: .burning),
            .init(value: 9, lineValue: 12, date: .now.add(days: -75), stage: .sugarNormal),
            .init(value: 13, lineValue: 16, date: .now.add(days: -74), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -73), stage: .sugarDrop),
            .init(value: 4, lineValue: 16, date: .now.add(days: -72), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -71), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -70), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -69), stage: .burning),
            .init(value: 9, lineValue: 12, date: .now.add(days: -68), stage: .sugarNormal),
            .init(value: 13, lineValue: 16, date: .now.add(days: -67), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -66), stage: .sugarDrop),
            .init(value: 4, lineValue: 16, date: .now.add(days: -65), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -64), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -63), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -62), stage: .burning),
            .init(value: 9, lineValue: 12, date: .now.add(days: -61), stage: .sugarNormal),
            .init(value: 4, lineValue: 16, date: .now.add(days: -60), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -59), stage: .burning),
            .init(value: 9, lineValue: 12, date: .now.add(days: -58), stage: .sugarNormal),
            .init(value: 13, lineValue: 16, date: .now.add(days: -57), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -56), stage: .sugarDrop),
            .init(value: 4, lineValue: 16, date: .now.add(days: -55), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -54), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -53), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -52), stage: .burning),
            .init(value: 9, lineValue: 12, date: .now.add(days: -51), stage: .sugarNormal),
            .init(value: 13, lineValue: 16, date: .now.add(days: -50), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -49), stage: .sugarDrop),
            .init(value: 4, lineValue: 16, date: .now.add(days: -48), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -47), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -46), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -45), stage: .burning),
            .init(value: 9, lineValue: 12, date: .now.add(days: -44), stage: .sugarNormal),
            .init(value: 13, lineValue: 16, date: .now.add(days: -43), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -42), stage: .sugarDrop),
            .init(value: 4, lineValue: 16, date: .now.add(days: -41), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -40), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -39), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -38), stage: .burning),
            .init(value: 9, lineValue: 12, date: .now.add(days: -37), stage: .sugarNormal),
            .init(value: 13, lineValue: 16, date: .now.add(days: -36), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -35), stage: .sugarDrop),
            .init(value: 4, lineValue: 16, date: .now.add(days: -34), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -33), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -32), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -31), stage: .burning),
            .init(value: 9, lineValue: 12, date: .now.add(days: -30), stage: .sugarNormal),
            .init(value: 13, lineValue: 16, date: .now.add(days: -29), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -28), stage: .sugarDrop),
            .init(value: 4, lineValue: 16, date: .now.add(days: -27), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -26), stage: .burning),
            .init(value: 9, lineValue: 12, date: .now.add(days: -25), stage: .sugarNormal),
            .init(value: 13, lineValue: 16, date: .now.add(days: -24), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -23), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -22), stage: .burning),
            .init(value: 9, lineValue: 12, date: .now.add(days: -21), stage: .sugarNormal),
            .init(value: 13, lineValue: 16, date: .now.add(days: -20), stage: .burning),
            .init(value: 9, lineValue: 16, date: .now.add(days: -19), stage: .sugarNormal),
            .init(value: 17, lineValue: 16, date: .now.add(days: -18), stage: .autophagy),
            .init(value: 9, lineValue: 14, date: .now.add(days: -17), stage: .sugarNormal),
            .init(value: 4, lineValue: 16, date: .now.add(days: -16), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -15), stage: .burning),
            .init(value: 9, lineValue: 12, date: .now.add(days: -14), stage: .burning),
            .init(value: 13, lineValue: 16, date: .now.add(days: -13), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -12), stage: .sugarDrop),
            .init(value: 4, lineValue: 16, date: .now.add(days: -11), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -10), stage: .burning),
            .init(value: 9, lineValue: 12, date: .now.add(days: -9), stage: .sugarNormal),
            .init(value: 13, lineValue: 16, date: .now.add(days: -8), stage: .burning),
            .init(value: 4, lineValue: 16, date: .now.add(days: -7), stage: .sugarDrop),
            .init(value: 12, lineValue: 16, date: .now.add(days: -6), stage: .burning),
            .init(value: 9, lineValue: 12, date: .now.add(days: -5), stage: .sugarNormal),
            .init(value: 13, lineValue: 16, date: .now.add(days: -4), stage: .burning),
            .init(value: 9, lineValue: 9, date: .now.add(days: -3), stage: .sugarNormal),
            .init(value: 17, lineValue: 16, date: .now.add(days: -2), stage: .autophagy),
            .init(value: 9, lineValue: 9, date: .now.add(days: -1), stage: .sugarNormal),
            .init(value: 7.5, lineValue: 7, date: .now, stage: .sugarDrop),
        ]
    }
}

public extension FastingHistoryChartItem {
    static var mock: FastingHistoryChartItem {
        .init(value: 4, lineValue: 16, date: .now.add(days: -16), stage: .sugarDrop)
    }
}
