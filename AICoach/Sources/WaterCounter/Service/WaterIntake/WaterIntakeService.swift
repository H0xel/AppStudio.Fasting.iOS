//  
//  WaterIntakeService.swift
//  
//
//  Created by Denis Khlopin on 26.03.2024.
//

public protocol WaterIntakeService {
    var waterIntake: Double? { get }
    var waterUnits: WaterUnits? { get }
}

class WaterIntakeServiceMock: WaterIntakeService {
    var waterUnits: WaterUnits?
    var waterIntake: Double? = 2500
}
