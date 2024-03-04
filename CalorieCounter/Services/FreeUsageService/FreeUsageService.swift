//  
//  FreeUsageService.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 23.01.2024.
//

import Foundation

protocol FreeUsageService {
    func canAddToDay(_ dayDate: Date) -> Bool
    func insertDate(date: Date)
}
