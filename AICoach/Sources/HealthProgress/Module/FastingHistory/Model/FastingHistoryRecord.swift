//
//  File.swift
//  
//
//  Created by Denis Khlopin on 13.03.2024.
//

import Foundation
import SwiftUI

public struct FastingHistoryRecord: Hashable {
    let id: String
    let startDate: Date
    let endDate: Date

    public init(id: String, startDate: Date, endDate: Date) {
        self.id = id
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension FastingHistoryRecord {
    var totalDurationInMinutes: Int {
        abs(endDate.timeIntervalSince(startDate).minutes)
    }

    var hours: Int {
        totalDurationInMinutes / 60
    }

    var minutes: Int {
        totalDurationInMinutes % 60
    }

    var intervalDateTitle: String {
        "\(startDate.currentLocaleFormatted(short: true)) - \(endDate.currentLocaleFormatted(short: true))"
    }

    var intervalTimeTitle: String {
        "\(startDate.currentLocaleFormatted(with: "hh:mm")) - \(endDate.currentLocaleFormatted(with: "hh:mm"))"
    }

    var durationTitle: String {
        String(format: NSLocalizedString("FastingHistoryRecord.duration.title", bundle: .module, comment: ""),
               arguments: ["\(hours)", minutes.withDoubleZero])
    }

    var icon: Image {
        switch CGFloat(totalDurationInMinutes) / 60.0 {
        case 0..<2: return .sugarRises
        case 2..<8: return .sugarDrop
        case 8..<10: return .sugarNormal
        case 10..<14: return .burning
        case 14..<16: return .ketosis
        case 16..<CGFloat.infinity: return .autophagy
        default:
            return .sugarRises
        }
    }
}

private extension Int {
    var withDoubleZero: String {
        let sign = self < 0 ? "-" : ""
        let absoluteValue = abs(self)
        if absoluteValue < 10 {
            return "\(sign)0\(absoluteValue)"
        }
        return "\(self)"
    }
}

