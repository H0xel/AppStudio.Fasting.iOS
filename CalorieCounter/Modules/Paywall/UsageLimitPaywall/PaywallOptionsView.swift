//
//  PaywallOptionsView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 22.01.2024.
//

import SwiftUI
import AppStudioUI

struct PaywallOptionsView: View {

    let popularSubscription: SubscriptionProduct
    let bestValueSubscription: SubscriptionProduct
    let weeklySubscription: SubscriptionProduct

    @Binding var selectedProduct: SubscriptionProduct?

    var body: some View {
        HStack(spacing: .horizontalSpacing) {
            PaywallOptionView(product: popularSubscription,
                              title: .popular,
                              weekTitle: LocalizedStringKey.weekPrice(price: popularSubscription.pricePerWeek),
                              isSelected: selectedProduct == popularSubscription)
            .onTapGesture {
                selectedProduct = popularSubscription
            }
            PaywallOptionView(product: bestValueSubscription,
                              title: .bestValue,
                              weekTitle: LocalizedStringKey.weekPrice(price: bestValueSubscription.pricePerWeek),
                              isSelected: selectedProduct == bestValueSubscription)
            .onTapGesture {
                selectedProduct = bestValueSubscription
            }
            PaywallOptionView(product: weeklySubscription,
                              title: nil,
                              weekTitle: LocalizedStringKey.perWeek,
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
    static let popular: LocalizedStringKey = "PaywallOptionsView.popular"
    static let bestValue: LocalizedStringKey = "PaywallOptionsView.bestValue"
    static let perWeek = NSLocalizedString("PaywallOptionsView.perWeek", comment: "")
    static func weekPrice(price: String) -> String {
        let week = NSLocalizedString("PaywallOptionsView.week", comment: "")
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
