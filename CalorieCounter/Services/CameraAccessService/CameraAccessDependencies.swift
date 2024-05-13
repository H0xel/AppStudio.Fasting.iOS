//  
//  CameraAccessDependencies.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.05.2024.
//

import Dependencies

extension DependencyValues {
    var cameraAccessService: CameraAccessService {
        self[CameraAccessServiceKey.self]
    }
}

private enum CameraAccessServiceKey: DependencyKey {
    static var liveValue: CameraAccessService = CameraAccessServiceImpl()
    static var testValue: CameraAccessService = CameraAccessServiceImpl()
    static var previewValue: CameraAccessService = CameraAccessServiceImpl()
}
