//
//  AppSyncServiceImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 22.06.2023.
//

import Foundation
import Dependencies
import RxSwift

final class AppSyncServiceImpl: ServiceBaseImpl, AppSyncService {
    @Dependency(\.storageService) private var storageService
    @Dependency(\.subscriptionService) private var subscriptionService
    @Dependency(\.identifiersSyncService) private var identifiersSyncService
    @Dependency(\.accountSyncService) private var accountSyncService
    @Dependency(\.firstLaunchService) private var firstLaunchService

    private let disposeBag = DisposeBag()

    override init() {
        super.init()
    }

    func initialize() {
        configureMessages()
    }

    private func configureMessages() {
        let scheduler = ConcurrentDispatchQueueScheduler(queue: concurrentQueue)

        messenger.onReplayMessage(AppInitializedMessage.self)
            .throttle(.seconds(1), scheduler: scheduler)
            .take(1)
            .subscribe(onNext: onAppInitializedMessage)
            .disposed(by: disposeBag)

        messenger.onMessage(UpdateIdentifiersMessage.self)
            .throttle(.seconds(1), scheduler: scheduler)
            .subscribe(onNext: onUpdateIdentifiers)
            .disposed(by: disposeBag)
    }

    private func onAppInitializedMessage(_ message: AppInitializedMessage) {
        Task {
            try? await syncIdentifiers(force: true)
            try? await syncAccount(force: true)
            // Upload receipt only for the first time at launch
            uploadReceiptIfNeeded()
        }
    }

    private func onUpdateIdentifiers(_ message: UpdateIdentifiersMessage) {
        Task {
            try? await syncIdentifiers(force: true)
        }
    }

    private func syncAccount(force: Bool) async throws {
        try await accountSyncService.sync(isForce: force)
        try await syncIdentifiers(force: false)
        uploadReceipt()
    }

    private func syncIdentifiers(force: Bool) async throws {
        try await identifiersSyncService.sync(isForce: force)
    }

    private func uploadReceiptIfNeeded() {
        guard firstLaunchService.isFirstTimeLaunch else { return }
        uploadReceipt()
    }

    private func uploadReceipt() {
        subscriptionService.uploadReceipt()
            .subscribe()
            .disposed(by: disposeBag)
    }
}
