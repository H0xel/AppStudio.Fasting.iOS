//
//  FastingTimeView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI
import AppStudioUI

struct FastingTimeView: View {

    let title: LocalizedStringKey
    let time: String
    var onEdit: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: Layout.spacing) {
            Text(title)
                .foregroundStyle(.fastingGrayText)
                .font(.poppins(.description))
                .frame(height: Layout.titleHeight)
            HStack(spacing: Layout.horizontalSpacing) {
                Text(time)
                    .font(.poppins(.buttonText))
                    .frame(height: Layout.timeLineHeight)
                if let onEdit {
                    Button(action: onEdit) {
                        Image.pen
                            .resizable()
                            .frame(width: Layout.imageHeight, height: Layout.imageHeight)
                            .padding(Layout.penPadding)
                    }
                }
            }
        }
        .aligned(.centerHorizontaly)
        .padding(.vertical, Layout.verticalPadding)
        .background(Color.fastingGrayFillCard)
        .continiousCornerRadius(Layout.cornerRadius)
    }
}

private extension FastingTimeView {
    enum Layout {
        static let titleHeight: CGFloat = 20
        static let timeLineHeight: CGFloat = 27
        static let spacing: CGFloat = 4
        static let horizontalSpacing: CGFloat = 2
        static let imageHeight: CGFloat = 14
        static let cornerRadius: CGFloat = 20
        static let verticalPadding: CGFloat = 12
        static let penPadding: CGFloat = 5
    }
}

#Preview {
    FastingTimeView(title: "Fasting started", time: "20:40") {}
}
