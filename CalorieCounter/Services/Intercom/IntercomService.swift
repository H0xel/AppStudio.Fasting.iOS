//
//  IntercomService.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 25.08.2023.
//

import Foundation
import Combine

protocol IntercomService {
    func initialize()
    func presentIntercom() -> AnyPublisher<Void, Never>
    func hideIntercom()
}
