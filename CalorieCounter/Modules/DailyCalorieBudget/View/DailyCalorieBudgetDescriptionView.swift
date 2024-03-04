//
//  DailyCalorieBudgetDescriptionView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 11.01.2024.
//

import SwiftUI
import AppStudioUI

struct DailyCalorieBudgetDescriptionView: View {
    let viewData: ViewData

    var body: some View {
        VStack(spacing: .zero) {
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

extension DailyCalorieBudgetDescriptionView {
    struct ViewData: Identifiable {
        let id = UUID().uuidString
        let subtitle: String
        let description: String
        let type: DescriptionType
    }

    enum DescriptionType: String {
        case estimatedExpenditure
        case dailyCalorieGoal
        case estimatedAchievementDate
        case targetProtein
        case dietType

        var title: String {
            NSLocalizedString("DailyCalorieBudget.\(self.rawValue)", comment: "")
        }

        var image: Image {
            switch self {
            case .estimatedExpenditure:
                Image.figureRun
            case .dailyCalorieGoal:
                Image.flameFill
            case .estimatedAchievementDate:
                Image.calendarBadgeCheckmark
            case .targetProtein:
                Image.dumbbellFill
            case .dietType:
                Image.forkKnife
            }
        }
    }
}

extension DailyCalorieBudgetDescriptionView.ViewData {
    static var mock: DailyCalorieBudgetDescriptionView.ViewData {
        .init(subtitle: "2,710 kcal",
              description: "Upon analyzing your data on physical activity and body metrics, we determined that your daily energy expenditure is approximately 2,710 kcal.",
              type: .estimatedExpenditure)
    }
}

private extension CGFloat {
    static let frame: CGFloat = 48
    static let leadingPadding: CGFloat = 12
    static let padding: CGFloat = 20
    static let cornerRadius: CGFloat = 20
    static let topPadding: CGFloat = 16
}

#Preview {
    DailyCalorieBudgetDescriptionView(viewData: .mock)
}
