//
//  PeriodGraphDescriptionView.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 17.09.2024.
//

import SwiftUI

struct PeriodGraphDescriptionView: View {
    let title: String
    let date: Date
    let image: Image
    let withTrailingPadding: Bool

    init(title: String, date: Date, image: Image, withTrailingPadding: Bool = false) {
        self.title = title
        self.date = date
        self.image = image
        self.withTrailingPadding = withTrailingPadding
    }

    var body: some View {
        VStack(spacing: .spacing) {
            Text(title)
                .font(.poppins(.body))
            Text(date.formatted(Date.FormatStyle().day().month()))
                .font(.poppinsBold(.buttonText))
            image
                .padding(.trailing, withTrailingPadding ? .curveLineTrailingPadding : .zero)
        }
    }
}

private extension CGFloat {
    static let curveLineTrailingPadding: CGFloat = 50
    static let spacing: CGFloat = 4
}
