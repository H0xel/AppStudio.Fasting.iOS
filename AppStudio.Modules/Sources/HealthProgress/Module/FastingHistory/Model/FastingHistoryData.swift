//
//  File.swift
//  
//
//  Created by Denis Khlopin on 13.03.2024.
//

import Foundation

public struct FastingHistoryData {
    let records: [FastingHistoryRecord]

    public init(records: [FastingHistoryRecord]) {
        self.records = records
    }
}

extension FastingHistoryData {
    static var mock = FastingHistoryData(
        records: [
            .init(
                id: UUID().uuidString,
                startDate: .utcNow.beginningOfDay.add(days: -5),
                endDate: .utcNow.add(days: -5)
            ),
            .init(
                id: UUID().uuidString,
                startDate: .utcNow.beginningOfDay.add(days: -4),
                endDate: .utcNow.add(days: -4).adding(.hour, value: -3)
            ),
            .init(
                id: UUID().uuidString,
                startDate: .utcNow.beginningOfDay.add(days: -3),
                endDate: .utcNow.add(days: -3).adding(.hour, value: 3)
            ),
            .init(
                id: UUID().uuidString,
                startDate: .utcNow.beginningOfDay.add(days: -2),
                endDate: .utcNow.add(days: -2)
            ),
            .init(
                id: UUID().uuidString,
                startDate: .utcNow.beginningOfDay.add(days: -1),
                endDate: .utcNow.add(days: -1)
            ),
            .init(id: UUID().uuidString, startDate: .utcNow.beginningOfDay, endDate: .utcNow)
        ]
    )
}
