//  
//  RootViewModel.swift
//  Fasting
//
//  Created by Denis Khlopin on 19.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI

enum AppTab {
    case fasting
    case profile
    case paywall

    var navigationTitle: String? {
        switch self {
        case .profile:
            return NSLocalizedString("ProfileScreen.navigationTitle", comment: "Profile")
        case .fasting, .paywall:
            return nil
        }
    }
}

class RootViewModel: BaseViewModel<RootOutput> {

    @Published var currentTab: AppTab = .fasting

    var router: RootRouter!

    init(input: RootInput, output: @escaping RootOutputBlock) {
        super.init(output: output)
        // initialization code here
    }

    var fasringScreen: some View {
        router.fastingScreen
    }

    var profileScreen: some View {
        router.profileScreen
    }

    func showPaywall() {
        router.presentPaywall()
    }
}
