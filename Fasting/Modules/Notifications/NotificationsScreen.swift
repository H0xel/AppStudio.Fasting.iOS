//  
//  NotificationsScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 14.06.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles
import UIKit

struct NotificationsScreen: View {
    @StateObject var viewModel: NotificationsViewModel

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: .itemSpacing) {
                    Spacer(minLength: .minSpacing)
                    QuiteModeSectionView(
                        isQuietModeToggled: $viewModel.notificationSettings.isQuietModeToggled,
                        fromTimeSelected: $viewModel.notificationSettings.quiteModeFromTime,
                        toTomeSelected: $viewModel.notificationSettings.quiteModeToTime,
                        isCollapsedType: $viewModel.collapsedSection,
                        notificationAccessIsGranted: viewModel.notificationsIsGranted,
                        isLocked: viewModel.isLocked,
                        lockedToggleTapped: viewModel.handleToggleEvent
                    )
                    .withNotificationSectionModifier()

                    NotificationSeparatorText(text: "NotificationsScreen.separatorText.reminders")

                    FastingRemindersSectionView(
                        startToFastToggled: $viewModel.notificationSettings.startToFastToggled,
                        endToFastToggled: $viewModel.notificationSettings.endToFastToggled,
                        advanceRemindersToggled: $viewModel.notificationSettings.advanceRemindersToggled,
                        beforeStartPriorSelection: $viewModel.notificationSettings.beforeStartPriorSelection,
                        beforeEndPriorSelection: $viewModel.notificationSettings.beforeEndPriorSelection,
                        isCollapsedType: $viewModel.collapsedSection,
                        notificationAccessIsGranted: viewModel.notificationsIsGranted,
                        isLocked: false,
                        lockedToggleTapped: viewModel.handleToggleEvent
                    )

                    NotificationSeparatorText(text: "NotificationsScreen.separatorText.stages")

                    FastingStagesSectionView(
                        isFastingStagesToggled: $viewModel.notificationSettings.isFastingStagesToggled,
                        selectedFastingStages: viewModel.notificationSettings.selectedFastingStages,
                        notificationAccessIsGranted: viewModel.notificationsIsGranted,
                        isLocked: viewModel.isLocked,
                        action: viewModel.handleFastingStagesSectionEvents
                    )
                    .withNotificationSectionModifier()

                    NotificationSeparatorText(text: "NotificationsScreen.separatorText.weightInReminders")

                    WeightInSectionView(
                        isWeightToggled: $viewModel.notificationSettings.isWeightToggled,
                        timeToWeight: $viewModel.notificationSettings.timeToWeight,
                        weightFrequency: $viewModel.notificationSettings.weightFrequency,
                        collapsedType: $viewModel.collapsedSection,
                        notificationAccessIsGranted: viewModel.notificationsIsGranted,
                        isLocked: viewModel.isLocked,
                        lockedToggleTapped: viewModel.handleToggleEvent
                    )
                    .withNotificationSectionModifier()

                    NotificationSeparatorText(text: "NotificationsScreen.separatorText.hydrationReminders")

                    HydrationSectionView(
                        isHydrationToggled: $viewModel.notificationSettings.isHydrationToggled,
                        timeToDrink: $viewModel.notificationSettings.startTimeHydration,
                        endTimeToDrink: $viewModel.notificationSettings.endTimeHydration,
                        hydrationFrequency: $viewModel.notificationSettings.hydrationFrequency,
                        collapsedType: $viewModel.collapsedSection,
                        notificationAccessIsGranted: viewModel.notificationsIsGranted,
                        isLocked: viewModel.isLocked,
                        lockedToggleTapped: viewModel.handleToggleEvent
                    )
                    .withNotificationSectionModifier()
                    .id(SectionId.hydration)

                    if viewModel.context == .onboarding {
                        Spacer(minLength: .bottomSpacerMinSpacing)
                    }
                }
            }
            .onReceive(viewModel.$collapsedSection.eraseToAnyPublisher()) {
                if $0 == .hydrationFrequency || $0 == .hydrationEndTime || $0 == .hydrationStartTime {
                    proxy.scrollTo(SectionId.hydration, anchor: .bottom)
                }
            }
        }
        .overlay {
            if viewModel.context == .onboarding {
                NotificationBottomView(action: viewModel.handleBottomEvent)
                    .aligned(.bottom)
            }
        }
        .scrollIndicators(.hidden)
        .background(Color.studioGreyFillProgress)
        .navBarButton(placement: .principal,
                      isVisible: true,
                      content: Text("NotificationsScreen.title")
                                    .font(.poppins(.buttonText))
                                    .foregroundStyle(Color.studioBlackLight),
                      action: {})
        .navBarButton(isVisible: viewModel.context == .settings,
                      content: Image(systemName: "chevron.backward").foregroundStyle(Color.studioBlackLight),
                      action: viewModel.onBackTap)
        .onReceive(
            NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification),
            perform: { _ in viewModel.updateNotificationAuthorizationStatus() }
        )
        .onDisappear {
            viewModel.disappeared()
        }
    }
}

private extension CGFloat {
    static let minSpacing: CGFloat = 16
    static let bottomSpacerMinSpacing: CGFloat = 100
    static let itemSpacing: CGFloat = 8
}

private struct SectionId: Hashable {
    static let hydration = "HydrationID"
}

struct NotificationsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NotificationsScreen(
                viewModel: NotificationsViewModel(
                    input: NotificationsInput(context: .onboarding),
                    output: { _ in }
                )
            )
        }
    }
}
