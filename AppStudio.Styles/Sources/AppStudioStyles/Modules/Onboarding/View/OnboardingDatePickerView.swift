//
//  OnboardingDatePickerView.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import SwiftUI

public struct OnboardingDatePickerView: View {

    private let title: String
    private let description: String?
    private let canChoosePast: Bool
    @Binding private var date: Date

    public init(title: String, description: String? = nil, canChoosePast: Bool, date: Binding<Date>) {
        self.title = title
        self.description = description
        self.canChoosePast = canChoosePast
        self._date = date
    }

    public var body: some View {
        VStack(spacing: .zero) {
            Text(title)
                .font(.poppins(.headerM))
                .foregroundStyle(Color.studioBlackLight)
                .padding(.top, Layout.topPadding)
                .multilineTextAlignment(.center)

            if let description {
                Text(description)
                    .foregroundStyle(Color.studioGrayText)
                    .font(.poppins(.body))
                    .padding(.top, Layout.descriptionTopPadding)
                    .multilineTextAlignment(.center)
            }

            Spacer()
            if canChoosePast {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            } else {
                DatePicker("", selection: $date, in: PartialRangeFrom(.now), displayedComponents: .date)
                    .datePickerStyle(.wheel)
                    .labelsHidden()
            }
            Spacer()
        }
        .padding(.bottom, Layout.bottomPadding)
    }
}

private extension OnboardingDatePickerView {
    enum Layout {
        static let topPadding: CGFloat = 24
        static let bottomPadding: CGFloat = 80
        static var descriptionTopPadding: CGFloat = 16
    }
}

#Preview {
    OnboardingDatePickerView(title: "When is your birthday?",
                             canChoosePast: true,
                             date: .constant(.now))
}

