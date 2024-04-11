//
//  UnSelectedHeaderItemView.swift
//
//
//  Created by Amakhin Ivan on 22.03.2024.
//

import SwiftUI
import AppStudioModels
import WaterCounter

struct UnSelectedHeaderItemView: View {
    let viewData: ViewData

    var body: some View {
        VStack(spacing: .zero) {
            Text("\(viewData.startDate) - \(viewData.endDate)")
                .font(.poppinsMedium(.body))
                .padding(.top, .periodTopPadding)
                .padding(.bottom, .periodBottomPadding)

            HStack(spacing: .zero) {
                Spacer()

                VStack(spacing: .spacing) {
                    Text(viewData.type.averageTitle)
                        .foregroundStyle(Color.studioGrayText)
                        .font(.poppins(.description))

                    HStack(alignment: .firstTextBaseline, spacing: .spacing) {
                        
                        switch viewData.averageAmountType {
                        case .averageTime(let averageTime):
                            Text("\(averageTime.hours)")
                                .font(.poppinsBold(.headerM))
                            Text("FastingHistoryScreen.averageTime.h".localized(bundle: .module))
                                .font(.poppins(.description))
                            Text("\(averageTime.toMinutesInt)")
                                .font(.poppinsBold(.headerM))
                            Text("FastingHistoryScreen.averageTime.m".localized(bundle: .module))
                                .font(.poppins(.description))
                        case let .averageWater(averageWater, waterUnits):
                            Text(averageWater)
                                .font(.poppinsBold(.headerM))
                            Text(waterUnits.unitsGlobalFullTitle.lowercased())
                                .font(.poppins(.description))
                        }
                    }
                }

                Spacer()
                Spacer()

                if viewData.stage == nil {
                    Text("FastingHistoryScreen.striveForProgress".localized(bundle: .module))
                        .lineSpacing(.striveLineSpacing)
                        .foregroundStyle(Color.black)
                        .font(.poppins(.description))
                        .padding(.horizontal, .striveHorizontalPadding)
                        .padding(.vertical, .striveVerticalPadding)
                        .background(Color.studioOrange.opacity(0.15))
                        .continiousCornerRadius(.cornerRadius)
                } else {
                    VStack(spacing: .spacing) {
                        Text("FastingHistoryScreen.goalReached".localized(bundle: .module))
                            .foregroundStyle(Color.studioGrayText)
                            .font(.poppins(.description))


                        HStack(spacing: .spacing) {
                            if viewData.type == .fasting {
                                viewData.stage?.image
                                    .aligned(.centerVerticaly)
                                    .frame(height: .imageHeight)
                            }

                            HStack(alignment: .firstTextBaseline, spacing: .spacing) {
                                Text("\(viewData.timesAmount ?? 0)")
                                    .font(.poppinsBold(.headerM))
                                Text("FastingHistoryScreen.times".localized(bundle: .module))
                                    .font(.poppins(.description))
                            }
                        }
                    }
                }

                Spacer()
            }
            .padding(.bottom, .bottomPadding)
        }
        .padding(.horizontal, .horizontalPadding)
    }
}

private extension CGFloat {
    static let periodTopPadding: CGFloat = 8
    static let periodBottomPadding: CGFloat = 24
    static let bottomPadding: CGFloat = 16
    static let horizontalPadding: CGFloat = 20
    static let striveLineSpacing: CGFloat = 5
    static let striveHorizontalPadding: CGFloat = 16
    static let striveVerticalPadding: CGFloat = 6
    static let spacing: CGFloat = 4
    static let imageHeight: CGFloat = 24
    static let cornerRadius: CGFloat = 16
}

extension TimeInterval {
    var toMinutesInt: String {
        let left = Int(self)
        let minutes = left / 60
        let minutesLeft = minutes % 60
        return minutesLeft < 10 ? "\(0)\(minutesLeft)" : "\(minutesLeft)"
    }
}

extension UnSelectedHeaderItemView {
    struct ViewData {
        let startDate: String
        let endDate: String
        let averageAmountType: AverageAmountType
        let timesAmount: Int?
        let stage: FastingHistoryStage?
        let type: ViewType

        enum AverageAmountType {
            case averageTime(TimeInterval)
            case averageWater(amount: String, waterUnits: WaterUnits)
        }

        enum ViewType {
            case fasting
            case water

            var averageTitle: String {
                switch self {
                case .fasting:
                   return "FastingHistoryScreen.averageTime".localized(bundle: .module)
                case .water:
                   return "FastingHistoryScreen.averageIntake".localized(bundle: .module)
                }
            }
        }
    }
}

extension UnSelectedHeaderItemView.ViewData {
    static var mock: UnSelectedHeaderItemView.ViewData {
        .init(startDate: "Feb 13",
              endDate:  "Feb 14",
              averageAmountType: .averageWater(amount: "12,4", waterUnits: .liters),
              timesAmount: 28,
              stage: .autophagy, 
              type: .water)
    }

    static var mockWithoutGoal: UnSelectedHeaderItemView.ViewData {
        .init(startDate: "Feb 13",
              endDate:  "Feb 14",
              averageAmountType: .averageTime(.hour * 16 + .minute * 11),
              timesAmount: nil,
              stage: nil,
              type: .fasting)
    }
}

extension UnSelectedHeaderItemView.ViewData {
    init(context: FastingHistoryInput.Context,
         date: Date,
         selectedPeriod: GraphPeriod,
         items: [FastingHistoryChartItem]) {

        let startDate = date
        let endDate = date.addingTimeInterval(.day * Double(selectedPeriod.fastingHistoryVisibleDomain))

        let filteredDates = items.filter { item in
            return item.date >= startDate && item.date <= endDate
        }

        let filteredDatesAmountWithoutEmptyState = filteredDates.filter {
            $0.value != 0
        }.count

        var viewType: UnSelectedHeaderItemView.ViewData.ViewType {
            return context == .fasting ? .fasting : .water
        }

        var averageAmountType: UnSelectedHeaderItemView.ViewData.AverageAmountType {
            let totalAmount = filteredDates
                .map { $0.value }
                .reduce(0, +)

            switch context {
            case .fasting:
                var averageTimeInterval: TimeInterval {
                    guard filteredDatesAmountWithoutEmptyState != 0 else { return .init(minutes: 0)}
                    return .init(minutes: Int((totalAmount * 60) / Double(filteredDatesAmountWithoutEmptyState)))
                }
                return .averageTime(averageTimeInterval)
            case let .water(waterUnits):
                var averageWater: String {
                    guard filteredDatesAmountWithoutEmptyState != 0 else { return "0" }

                    var format: String {
                        waterUnits == .liters ? "%.1f" : "%.0f"
                    }

                    return String(format: format, totalAmount / Double(filteredDatesAmountWithoutEmptyState))
                }
                return .averageWater(amount: averageWater, waterUnits: waterUnits)
            }
        }

        var timesAmount: (stage: FastingHistoryStage?, amount: Int?) {
            let timesAmount = filteredDates
                .filter { $0.value >= $0.lineValue }

            if timesAmount.isEmpty {
                return (nil, nil)
            }

            var stagesCounts: [FastingHistoryStage: Int] = [:]

            for stage in timesAmount.map({ $0.stage }) {
                if let count = stagesCounts[stage] {
                    stagesCounts[stage] = count + 1
                } else {
                    stagesCounts[stage] = 1
                }
            }

            var mostFrequentElement: FastingHistoryStage?
            var maxCount = 0

            for (element, count) in stagesCounts {
                if count > maxCount {
                    mostFrequentElement = element
                    maxCount = count
                }
            }

            return (mostFrequentElement, timesAmount.count)
        }

        self = .init(
            startDate: startDate.formatted(Date.FormatStyle().day().month()),
            endDate: endDate.formatted(Date.FormatStyle().day().month()),
            averageAmountType: averageAmountType,
            timesAmount: timesAmount.amount,
            stage: timesAmount.stage,
            type: viewType
        )
    }
}

#Preview {
    VStack {
        UnSelectedHeaderItemView(viewData: .mock)
        UnSelectedHeaderItemView(viewData: .mockWithoutGoal)
    }
}
