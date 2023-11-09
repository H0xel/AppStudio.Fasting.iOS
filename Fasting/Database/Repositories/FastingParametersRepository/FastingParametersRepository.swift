//
//  FastingParametersRepository.swift
//  Fasting
//
//  Created by Denis Khlopin on 31.10.2023.
//

import MunicornCoreData
import Foundation

protocol FastingParametersRepository {
    func current() async throws -> FastingParameters
    func update(currentDate: Date) async throws -> FastingParameters
    func clearCurrentDate() async throws -> FastingParameters
    func save(interval: FastingInterval) async throws -> FastingParameters
}
