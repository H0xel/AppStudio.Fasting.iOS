//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

import Foundation
import MunicornCoreData
import Dependencies

typealias CoachMessageObserver = CoreDataObserver<CoachMessage>

extension CoachMessageObserver {
    convenience init() {
        @Dependency(\.coreDataService) var coreDataService
        self.init(coreDataService: coreDataService)
    }
}
