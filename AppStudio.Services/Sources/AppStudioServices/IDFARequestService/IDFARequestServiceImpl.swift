//
//  IDFARequestServiceImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 01.06.2023.
//

import AppTrackingTransparency
import Foundation
import Dependencies

final class IDFARequestServiceImpl: IDFARequestService {
    @Dependency(\.trackerService) private var trackService
    @Dependency(\.analyticKeyStore) private var analyticKeyStore
    @Dependency(\.storageService) private var storageService

    public func requestIDFATracking() {
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else {
            return
        }
        trackService.track(.idfaShown(afId: analyticKeyStore.currentAppsFlyerId))
        DispatchQueue.main.async {
            ATTrackingManager.requestTrackingAuthorization { [weak self] status in
                guard let self else { return }
                self.trackService.track(.idfaAnswered(isGranted: status == .authorized,
                                                      afId: self.analyticKeyStore.currentAppsFlyerId))
            }
        }
    }
}
