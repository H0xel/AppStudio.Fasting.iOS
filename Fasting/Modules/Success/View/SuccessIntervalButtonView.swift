//
//  SuccessIntervalButtonView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 03.11.2023.
//

import SwiftUI

struct SuccessIntervalButtonView: View {

    let title: LocalizedStringKey
    let date: String
    let roundedCorners: UIRectCorner
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: Layout.verticalSpacing) {
            Text(title)
                .font(.poppins(.description))
                .foregroundStyle(.fastingGrayText)
            HStack {
                Text(date)
                    .font(.poppins(.buttonText))
                    .foregroundStyle(.accent)
                Spacer()
                Button(action: action) {
                    Image.pen
                }
            }
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .padding(.vertical, Layout.verticalPadding)
        .background(.fastingGrayFillCard)
        .corners(roundedCorners, with: Layout.cornerRadius)
    }
}

private extension SuccessIntervalButtonView {
    enum Layout {
        static let verticalSpacing: CGFloat = 8
        static let verticalPadding: CGFloat = 16
        static let horizontalPadding: CGFloat = 24
        static let cornerRadius: CGFloat = 20
    }
}

#Preview {
    SuccessIntervalButtonView(title: "Fasting started",
                              date: "October 10, 8:40 pm", 
                              roundedCorners: [.topLeft, .topRight],
                              action: {})
}
