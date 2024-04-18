//
//  WeightProgressAnalyticsItemView.swift
//
//
//  Created by Руслан Сафаргалеев on 02.04.2024.
//

import SwiftUI
import AppStudioModels

struct WeightProgressAnalyticsItemInput {
    let title: String
    let value: String?
    let units: String
    let description: String

    let emptyTitle: String
    let emptyDescription: String

    var isEmpty: Bool {
        value == nil
    }
}

struct WeightProgressAnalyticsItemView: View {

    let input: WeightProgressAnalyticsItemInput

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing) {
            Text(input.title)
                .font(.poppins(.body))
            HStack(alignment: .bottom, spacing: .valueSpacing) {
                Text(input.value ?? "--")
                    .font(.poppins(.headerM))
                Text(input.units)
                    .font(.poppinsMedium(.body))
                    .offset(y: .unitsOffset)
            }
            Text(input.description)
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGreyText)
                .aligned(.left)
            if input.isEmpty {
                VStack(spacing: .zero) {
                    HStack(spacing: .emptyTitleSpacing) {
                        Image(.waitingData)
                        Text(input.emptyTitle)
                            .font(.poppinsMedium(.body))
                        Spacer()
                    }
                    .padding(.vertical, .emptyTitleVerticalPadding)
                    Text(input.emptyDescription)
                        .font(.poppins(.description))
                        .aligned(.left)
                }
                .foregroundStyle(Color.studioBlackLight)
            }
        }
        .foregroundStyle(Color.studioBlackLight)
        .padding(.padding)
    }
}

extension WeightProgressAnalyticsItemInput {

    static func trueWeight(weight: WeightMeasure) -> WeightProgressAnalyticsItemInput {
        .init(
            title: "WeightProgressAnalyticsView.currentTrueWeight".localized(bundle: .module),
            value: String(format: "%.1f", weight.value),
            units: weight.units.title,
            description: "WeightProgressAnalyticsView.currentTrueWeight.description".localized(bundle: .module),
            emptyTitle: "",
            emptyDescription: ""
        )
    }

    static func weeklyChange(weight: Double?, units: WeightUnit) -> WeightProgressAnalyticsItemInput {
        let value: String? = if let weight { String(format: "%.2f", weight) } else { nil }
        let perWeek = "WeightProgressAnalyticsView.perWeek".localized(bundle: .module)
        let description = weight ?? 0 > 0 ? 
        "WeightProgressAnalyticsView.weeklyWeightChange.description.weightGain".localized(bundle: .module) :
        "WeightProgressAnalyticsView.weeklyWeightChange.description.weightLoss".localized(bundle: .module)
        return .init(
            title: "WeightProgressAnalyticsView.weeklyWeightChange".localized(bundle: .module),
            value: value,
            units: "\(units.title) \(perWeek)",
            description: description,
            emptyTitle: "WeightProgressAnalyticsView.gatheringData".localized(bundle: .module),
            emptyDescription: "WeightProgressAnalyticsView.gatheringDataDescription".localized(bundle: .module)
        )
    }

    static func projection(weight: Double?, units: WeightUnit) -> WeightProgressAnalyticsItemInput {
        let value: String? = if let weight { String(format: "%.1f", weight) } else { nil }
        let description = weight ?? 0 > 0 ?
        "WeightProgressAnalyticsView.projection.description.weightGain".localized(bundle: .module) :
        "WeightProgressAnalyticsView.projection.description.weightLoss".localized(bundle: .module)
        return .init(
            title: "WeightProgressAnalyticsView.projection".localized(bundle: .module),
            value: value,
            units: units.title,
            description: description,
            emptyTitle: "WeightProgressAnalyticsView.projectionPending".localized(bundle: .module),
            emptyDescription: "WeightProgressAnalyticsView.projectionPendingDescription".localized(bundle: .module)
        )
    }
}

private extension CGFloat {
    static let padding: CGFloat = 20
    static let spacing: CGFloat = 12
    static let unitsOffset: CGFloat = -1
    static let valueSpacing: CGFloat = 4
    static let emptyTitleVerticalPadding: CGFloat = 8
    static let emptyTitleSpacing: CGFloat = 8
}

#Preview {
    VStack {
        WeightProgressAnalyticsItemView(input: .weeklyChange(weight: 57.5, units: .kg))
    }
}
