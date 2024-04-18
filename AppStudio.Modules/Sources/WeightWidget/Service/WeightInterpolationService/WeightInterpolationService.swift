//  
//  WeightInterpolationService.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 21.03.2024.
//

public protocol WeightInterpolationService {
    func interpolate(weightHistory: [WeightHistory]) -> [WeightHistory]
}
