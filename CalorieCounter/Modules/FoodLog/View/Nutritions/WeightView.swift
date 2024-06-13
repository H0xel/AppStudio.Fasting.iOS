//
//  WeightView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 12.06.2024.
//

import SwiftUI

struct WeightView: View {
    let amount: String

    var body: some View {
        HStack(spacing: 4) {
            Image(.weightIcon)
            Text(amount)
        }
        .foregroundStyle(Color.studioBlackLight)
        .font(.poppins(.description))
    }
}


#Preview {
    WeightView(amount: "25 g")
}
