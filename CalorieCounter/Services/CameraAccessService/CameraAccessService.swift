//  
//  CameraAccessService.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.05.2024.
//

protocol CameraAccessService {
    func requestAccess() async -> Bool
}
