//  
//  CameraAccessServiceImpl.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.05.2024.
//

import AVFoundation

class CameraAccessServiceImpl: CameraAccessService {
    func requestAccess() async -> Bool {
       await AVCaptureDevice.requestAccess(for: .video)
    }
}
