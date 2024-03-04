//
//  OnboardingLoadingViewScreen.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 07.12.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

struct OnboardingLoadingViewScreen: View {
    @StateObject var viewModel: OnboardingLoadingViewViewModel
    @State private var totalInterval: CGFloat = 0.0
    @State private var timer = Timer.publish(every: Layout.timerInterval,
                                             on: .main,
                                             in: .common).autoconnect()

    var body: some View {
        ZStackWith(color: Color.white) {
            OnboardingLoadingAnimationBackgroundView(angle: viewModel.angle)

            OnboardingLoadingHeaderView(progress: viewModel.progress,
                                        title: viewModel.title)
        }
        .onReceive(timer) { _ in
            totalInterval += Layout.timerInterval
            viewModel.updateOnboardingCalculationProccessData(interval: totalInterval)
        }
    }
}

// MARK: - Layout properties
private extension OnboardingLoadingViewScreen {
    enum Layout {
        static let timerInterval: CGFloat = 0.1
    }
}

struct OnboardingLoadingViewScreen_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingLoadingViewRoute(navigator: Navigator(), output: { _ in }).view
    }
}
