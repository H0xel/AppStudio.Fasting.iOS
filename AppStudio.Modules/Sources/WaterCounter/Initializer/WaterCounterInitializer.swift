//
//  File.swift
//  
//
//  Created by Denis Khlopin on 26.03.2024.
//

import Foundation

public class WaterCounterInitializer {
    public init() {}
    
    public func initialize(waterIntakeService: WaterIntakeService) {
        WaterIntakeServiceKey.liveValue = waterIntakeService
    }
}
