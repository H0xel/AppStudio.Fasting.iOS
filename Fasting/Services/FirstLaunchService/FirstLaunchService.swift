//
//  FirstLaunchService.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 19.05.2023.
//

import Foundation

protocol FirstLaunchService {
    var isFirstTimeLaunch: Bool { get }
    func markAsLaunched()
}
