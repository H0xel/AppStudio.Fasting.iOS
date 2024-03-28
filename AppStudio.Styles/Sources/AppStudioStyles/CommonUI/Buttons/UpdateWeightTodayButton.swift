//
//  UpdateWeightTodayButton.swift
//
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import SwiftUI

public struct UpdateWeightTodayButton: View {

    let onTap: () -> Void

    public init(onTap: @escaping () -> Void) {
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: onTap) {
            HStack(spacing: .spacing) {
                Text(String.today)
                Image.arrowRight
            }
            .font(.poppinsMedium(.body))
            .foregroundStyle(Color.studioBlackLight)
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 8
}

private extension String {
    static let today = "UpdateWeightTodayButton.today".localized(bundle: .module)
}

#Preview {
    UpdateWeightTodayButton {}
}
