//
//  OnboardingDatePickerView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.12.2023.
//

import SwiftUI

struct OnboardingDatePickerView: View {

    let title: String
    let canChoosePast: Bool
    @Binding var date: Date

    var body: some View {
        VStack(spacing: .zero) {
            Text(title)
                .font(.poppins(.headerM))
                .foregroundStyle(.accent)
                .padding(.top, Layout.topPadding)
                .multilineTextAlignment(.center)

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
    }
}

#Preview {
    OnboardingDatePickerView(title: "When is your birthday?",
                             canChoosePast: true,
                             date: .constant(.now))
}
