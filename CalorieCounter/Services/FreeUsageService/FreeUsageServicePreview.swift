//
//  FreeUsageServicePreview.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 19.02.2024.
//

import Foundation
import Dependencies
import MunicornFoundation


class FreeUsageServicePreview: FreeUsageService {

    func canAddToDay(_ dayDate: Date) -> Bool {
        false
    }

    func insertDate(date: Date) {}
}
