//
//  PeriodOnboardingDescriptionView.swift
//  PeriodTracker
//
//  Created by Amakhin Ivan on 16.09.2024.
//

import SwiftUI
import AppStudioUI

struct PeriodOnboardingDescriptionView: View {
    let viewData: ViewData

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            HStack(spacing: .zero) {

                ZStack {
                    Circle()
                        .frame(width: .frame, height: .frame)
                        .foregroundStyle(.white)
                    viewData.type.image
                        .foregroundStyle(.black)
                        .font(.system(size: 18))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewData.type.title)
                        .font(.poppins(.body))
                    Text(viewData.subtitle)
                        .font(.poppinsBold(18))
                }
                .padding(.leading, .leadingPadding)

                Spacer()
            }

            Text(viewData.description)
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGreyText)
                .padding(.top, .topPadding)
        }
        .padding(.all, .padding)
        .background(Color.studioGreyFillCard)
        .continiousCornerRadius(.cornerRadius)
    }
}

extension PeriodOnboardingDescriptionView {
    struct ViewData: Identifiable {
        let id = UUID().uuidString
        let subtitle: String
        let description: String
        let type: DescriptionType
    }

    enum DescriptionType: String {
        case ovulationDate

        var title: String {
            NSLocalizedString("PeriodOnboarding.\(self.rawValue)", comment: "")
        }

        var image: Image {
            Image.camera
        }
    }
}

private extension CGFloat {
    static let frame: CGFloat = 48
    static let leadingPadding: CGFloat = 12
    static let padding: CGFloat = 20
    static let cornerRadius: CGFloat = 20
    static let topPadding: CGFloat = 16
}
