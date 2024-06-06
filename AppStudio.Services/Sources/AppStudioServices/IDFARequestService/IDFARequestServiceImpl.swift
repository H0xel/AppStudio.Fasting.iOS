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

    public func requestIDFATracking() async {
        do {
            try await Task.sleep(seconds: 1)
            let osVersion = ProcessInfo.processInfo.operatingSystemVersion
            if osVersion.majorVersion == 17 && osVersion.minorVersion == 4 {
                await requestIDFATrackingFixed()
            } else {
                requestIDFATrackingDefault()
            }
            await retryIDFARequestIfNeeded()
        } catch {}
    }

    public func requestIDFATrackingDefault() {
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

    private func requestIDFATrackingFixed() async {
        var status = ATTrackingManager.trackingAuthorizationStatus
        if status != .notDetermined {
            return
        }
        trackService.track(.idfaShown(afId: analyticKeyStore.currentAppsFlyerId))
        status = await ATTrackingManager.requestTrackingAuthorization()
        if status == ATTrackingManager.trackingAuthorizationStatus {
            trackService.track(.idfaAnswered(isGranted: status == .authorized,
                                             afId: analyticKeyStore.currentAppsFlyerId))
        }
    }

    private func retryIDFARequestIfNeeded() async {
        do {
            try await Task.sleep(seconds: 9)
            await requestIDFATracking()
        } catch {}
    }
}
