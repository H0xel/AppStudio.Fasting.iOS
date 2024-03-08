//
//  WidgetTitleView.swift
//
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI

struct WidgetTitleView: View {

    let title: String
    let onTap: () -> Void

    var body: some View {
        HStack {
            Text(title)
                .font(.poppinsBold(.buttonText))
                .foregroundStyle(Color.studioBlackLight)
            Spacer()
            Button(action: onTap) {
                Image(.widgetSettings)
            }
        }
    }
}

#Preview {
    WidgetTitleView(title: "Next fast in", onTap: {})
}
