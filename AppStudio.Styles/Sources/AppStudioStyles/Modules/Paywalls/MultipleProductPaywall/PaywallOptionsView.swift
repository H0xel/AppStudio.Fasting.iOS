//
//  PaywallOptionsView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 22.01.2024.
//

import SwiftUI
import AppStudioUI
import AppStudioModels

struct PaywallOptionsView: View {

    let popularSubscription: SubscriptionProduct
    let bestValueSubscription: SubscriptionProduct
    let weeklySubscription: SubscriptionProduct

    @Binding var selectedProduct: SubscriptionProduct?

    var body: some View {
        HStack(spacing: .horizontalSpacing) {
            PaywallOptionView(product: popularSubscription,
                              title: "Paywall.popular".localized(bundle: .module),
                              weekTitle: LocalizedStringKey.weekPrice(price: popularSubscription.pricePerWeek),
                              isSelected: selectedProduct == popularSubscription)
            .onTapGesture {
                selectedProduct = popularSubscription
            }
            PaywallOptionView(product: bestValueSubscription,
                              title: "Paywall.bestValue".localized(bundle: .module),
                              weekTitle: LocalizedStringKey.weekPrice(price: bestValueSubscription.pricePerWeek),
                              isSelected: selectedProduct == bestValueSubscription)
            .onTapGesture {
                selectedProduct = bestValueSubscription
            }
            PaywallOptionView(product: weeklySubscription,
                              title: nil,
                              weekTitle: "Paywall.perWeek".localized(bundle: .module),
                              isSelected: selectedProduct == weeklySubscription)
            .onTapGesture {
                selectedProduct = weeklySubscription
            }
        }
    }
}

private extension CGFloat {
    static let horizontalSpacing: CGFloat = 4
}

private extension LocalizedStringKey {
    static func weekPrice(price: String) -> String {
        let week = NSLocalizedString("Paywall.week", bundle: .module, comment: "")
        return "\(price)\(week)"
    }
}

#Preview {
    PaywallOptionsView(popularSubscription: .mock,
                       bestValueSubscription: .mock,
                       weeklySubscription: .mock,
                       selectedProduct: .constant(.mock))
    .padding(.horizontal, 20)
}
