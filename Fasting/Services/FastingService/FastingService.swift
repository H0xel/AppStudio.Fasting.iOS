//
//  FastingService.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import Foundation

protocol FastingService {
    func status() -> FastingStatus
    func startFasting()
    func endFasting()
}
