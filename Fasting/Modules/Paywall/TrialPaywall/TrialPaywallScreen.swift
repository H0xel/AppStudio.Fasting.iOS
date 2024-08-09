//  
//  TrialPaywallScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 05.08.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

struct TrialPaywallScreen: View {
    @StateObject var viewModel: TrialPaywallViewModel

    var body: some View {
        TrialProductPaywallScreen(price: viewModel.price,
                                  trialPeriod: viewModel.trialPeriod,
                                  type: .fasting,
                                  action: viewModel.handle)
    }
}

struct TrialPaywallScreen_Previews: PreviewProvider {
    static var previews: some View {
        TrialPaywallScreen(
            viewModel: TrialPaywallViewModel(
                input: TrialPaywallInput(),
                output: { _ in }
            )
        )
    }
}
