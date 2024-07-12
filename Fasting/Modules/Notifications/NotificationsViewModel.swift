//  
//  NotificationsViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 14.06.2024.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI
import Dependencies
import AppStudioStyles

class NotificationsViewModel: BaseViewModel<NotificationsOutput> {
    @Dependency(\.newSubscriptionService) private var newSubscriptionService
    @Dependency(\.cloudStorage) private var cloudStorage
    @Dependency(\.fastingLocalNotificationService) private var fastingLocalNotificationService
    @Dependency(\.fastingParametersService) private var fastingParametersService
    @Dependency(\.trackerService) private var trackerService

    var router: NotificationsRouter!
    let context: NotificationsInput.Context

    @Published var isLocked = false
    @Published var notificationsIsGranted = false
    @Published var notificationSettings: NotificationSettings = .initial
    @Published var collapsedSection: CollapsedType = .close

    @Published private var fastingData: FastingData = .empty

    init(input: NotificationsInput, output: @escaping NotificationsOutputBlock) {
        context = input.context
        super.init(output: output)
        updateNotificationAuthorizationStatus()
        subscribeToHasSubscription()
        fastingParametersService.fastingData
            .assign(to: &$fastingData)
    }

    func onBackTap() {
        output(.close)
    }

    func handleBottomEvent( _ event: NotificationBottomView.Action) {
        switch event {
        case .skip:
            trackSkipTapped()
            output(.close)
        case .save:
            saveSettings(hasSubscription: !isLocked)
            registerNotifications()
            trackSaveTapped()
            trackUpdated()
            output(.close)
        }
    }

    func handleFastingStagesSectionEvents(_ event: FastingStagesSectionView.Action) {
        switch event {
        case .showFastingStages:
            router.presentNotificationsForStages(
                input: .init(selectedStages: notificationSettings.selectedFastingStages)
            ) { [weak self] event in
                switch event {
                case .close:
                    self?.router.dismiss()
                case .save(let stages):
                    self?.notificationSettings.selectedFastingStages = stages
                    self?.router.dismiss()
                }
            }
        case .lockedToggleTapped:
            showPaywall()
        case .notificationsAccessNotGranted:
            router.presentNotificationAlert()
        }
    }

    func handleToggleEvent(_ event: ToggleWithIconStyle.Action) {
        switch event {
        case .isLocked:
            showPaywall()
        case .notificationsAccessNotGranted:
            router.presentNotificationAlert()
        }
    }

    func updateNotificationAuthorizationStatus() {
        Task {
            let granted = try await UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
            await UIApplication.shared.registerForRemoteNotifications()
            await MainActor.run {
                notificationsIsGranted = granted
            }
        }
    }

    func disappeared() {
        if context == .settings {
            saveSettings(hasSubscription: !isLocked)
            registerNotifications()
            trackUpdated()
        }
    }
}


private extension NotificationsViewModel {
    func showPaywall() {
        router.presentMultipleProductPaywall(context: context.paywallContext)
    }

    func subscribeToHasSubscription() {
        newSubscriptionService.hasSubscription
            .removeDuplicates()
            .map { [weak self] hasSubscription in
                self?.initializeNotifications(hasSubscription: hasSubscription)
                return !hasSubscription
            }
            .receive(on: DispatchQueue.main)
            .assign(to: &$isLocked)
    }

    func initializeNotifications(hasSubscription: Bool) {
        if let savedSettings = cloudStorage.lastSavedNotificationSettingsWithSubscription, hasSubscription {
            notificationSettings = savedSettings
            return
        }

        notificationSettings = .initial(isLocked: !hasSubscription)
    }

    func saveSettings(hasSubscription: Bool) {
        cloudStorage.notificationSettings = notificationSettings
        if hasSubscription {
            cloudStorage.lastSavedNotificationSettingsWithSubscription = notificationSettings
        }
    }

    func registerNotifications() {
        fastingLocalNotificationService.updateNotifications(
            interval: fastingData.interval,
            isProcessing: fastingData.isFastingProcess
        )
    }
}


// MARK: Analytic

private extension NotificationsViewModel {
    func trackSaveTapped() {
        trackerService.track(.tapSaveNotificationsSettings)
    }

    func trackSkipTapped() {
        trackerService.track(.skipNotificationsSetUp)
    }

    func trackUpdated() {
        trackerService.track(.notificationSettingsUpdated(
            quietMode: notificationSettings.isQuietModeToggled,
            quietModeFrom: notificationSettings.quiteModeFromTime.description,
            quietModeTo: notificationSettings.quiteModeToTime.description,
            startFast: notificationSettings.startToFastToggled,
            endFast: notificationSettings.endToFastToggled,
            advanceReminders: notificationSettings.advanceRemindersToggled,
            beforeStart: notificationSettings.beforeStartPriorSelection.rawValue,
            beforeEnd: notificationSettings.beforeEndPriorSelection.rawValue,
            stageNotifications: notificationSettings.isFastingStagesToggled,
            sugarRises: notificationSettings.selectedFastingStages.contains(.sugarRises),
            sugarDrops: notificationSettings.selectedFastingStages.contains(.sugarDrop),
            fatBurning: notificationSettings.selectedFastingStages.contains(.burning),
            kethosis: notificationSettings.selectedFastingStages.contains(.ketosis),
            autofagy: notificationSettings.selectedFastingStages.contains(.autophagy),
            weighInReminders: notificationSettings.isWeightToggled,
            weighInFrequency: notificationSettings.weightFrequency.rawValue,
            waterReminders: notificationSettings.isHydrationToggled,
            waterFrequency: notificationSettings.hydrationFrequency.rawValue
        ))
    }
}
