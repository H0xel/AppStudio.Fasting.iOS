//
//  FastingHistoryPeriodView.swift
//
//
//  Created by Amakhin Ivan on 22.03.2024.
//

import SwiftUI

struct FastingHistoryPeriodView: View {
    let selectedPeriod: GraphPeriod
    var action: (GraphPeriod) -> Void

    var body: some View {
        HStack(spacing: .periodSpacing) {
            ForEach(GraphPeriod.allCases, id: \.hashValue) { period in
                Text(period.title)
                    .font(.poppins(.description))
                    .padding(.vertical, .periodVerticalPadding)
                    .padding(.horizontal, .periodHorizontalPadding)
                    .background(selectedPeriod == period ? Color.studioGreyFillProgress : Color.clear)
                    .border(configuration: .init(cornerRadius: .periodCornerRadius, color: Color.studioGreyFillProgress))
                    .continiousCornerRadius(.periodCornerRadius)
                    .onTapGesture {
                        action(period)
                    }
            }
        }
        .padding(.vertical, .verticalPadding)
    }
}

private extension CGFloat {
    static let periodSpacing: CGFloat = 4
    static let periodVerticalPadding: CGFloat = 10
    static let periodHorizontalPadding: CGFloat = 20
    static let periodCornerRadius: CGFloat = 32
    static let verticalPadding: CGFloat = 16
}


#Preview {
    FastingHistoryPeriodView(selectedPeriod: .threeMonths) { _ in }
}
