//  
//  MultiplePaywallScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 11.04.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

struct MultiplePaywallScreen: View {
    @StateObject var viewModel: MultiplePaywallViewModel

    var body: some View {
        MultipleProductPaywallScreen(
            selectedProduct: $viewModel.selectedProduct,
            popularProduct: viewModel.popularProduct,
            bestValueProduct: viewModel.bestValueProduct,
            weeklyProduct: viewModel.weeklySubscription,
            type: .fasting,
            action: viewModel.handle)
    }
}

struct MultiplePaywallScreen_Previews: PreviewProvider {
    static var previews: some View {
        MultiplePaywallScreen(
            viewModel: MultiplePaywallViewModel(
                input: MultiplePaywallInput(paywallContext: .barcodeScanner),
                output: { _ in }
            )
        )
    }
}
