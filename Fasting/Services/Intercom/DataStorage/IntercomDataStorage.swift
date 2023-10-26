//
//  IntercomDataStorage.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 25.08.2023.
//

import Combine
import Foundation

protocol IntercomDataStorage {
    func initialize()
    func sync(userId: String?, hash: String?)
    var intercomData: AnyPublisher<IntercomData?, Never> { get }
}
