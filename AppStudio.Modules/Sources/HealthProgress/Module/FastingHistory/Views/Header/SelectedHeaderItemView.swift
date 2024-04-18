//
//  SelectedHeaderItemView.swift
//
//
//  Created by Amakhin Ivan on 22.03.2024.
//

import SwiftUI
import AppStudioModels
import WaterCounter

struct SelectedHeaderItemView: View {
    let viewData: ViewData
    let action: () -> Void

    var body: some View {
        VStack(spacing: .zero) {
            HStack(alignment: .center) {
                Spacer()
                Text(viewData.dateAmount)
                    .font(.poppinsMedium(.body))
                    .padding(.vertical, .periodVerticalPadding)
                    .padding(.leading, .periodLeadingPadding)

                Spacer()

                Button {
                    action()
                } label: {
                    Image.close
                        .foregroundStyle(Color.studioGrayText)
                        .frame(height: .imageClosHeight)
                }
                .padding(.trailing, .imageClosTrailingPadding)
            }

            HStack(spacing: .zero) {
                Spacer()

                VStack(spacing: .spacing) {
                    Text(viewData.averageTitle)
                        .foregroundStyle(Color.studioGrayText)
                        .font(.poppins(.description))

                    HStack(alignment: .firstTextBaseline, spacing: .spacing) {
                        switch viewData.averageTime {
                        case .averageTime(let averageTime):
                            Text("\(averageTime.hours)")
                                .font(.poppinsBold(.headerM))
                            Text("FastingHistoryScreen.averageTime.h".localized(bundle: .module))
                                .font(.poppins(.description))
                            Text("\(averageTime.toMinutesInt)")
                                .font(.poppinsBold(.headerM))
                            Text("FastingHistoryScreen.averageTime.m".localized(bundle: .module))
                                .font(.poppins(.description))
                        case let .averageWater(averageWater, waterUnit):
                            Text(averageWater)
                                .font(.poppinsBold(.headerM))
                            Text(waterUnit.unitsGlobalFullTitle.lowercased())
                                .font(.poppins(.description))
                        }
                    }
                }

                if viewData.viewType == .fasting || viewData.selectedDateRangeType == .week  {
                    Spacer()
                    Spacer()
                }

                VStack(spacing: .spacing) {
                    switch viewData.selectedDateRangeType {
                    case .week:
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
                            Text("FastingHistoryScreen.goalReached".localized(bundle: .module))
                                .foregroundStyle(Color.studioGrayText)
                                .font(.poppins(.description))

                            HStack(spacing: .spacing) {
                                if viewData.viewType == .fasting {
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
                    case .day:
                        if viewData.viewType == .fasting {
                            viewData.stage?.image
                                .aligned(.centerVerticaly)
                                .frame(height: .imageHeight)

                            Text(viewData.stage?.title ?? "")
                                .font(.poppins(.description))
                        }
                    }
                }

                Spacer()
            }
            .padding(.bottom, .bottomPadding)

        }
        .background(Color.studioGreyFillCard)
        .continiousCornerRadius(.cornerRadius)
        .padding(.horizontal, .horizontalPadding)
    }
}

extension SelectedHeaderItemView {
    struct ViewData {
        let dateAmount: String
        let averageTitle: String
        let averageTime: AverageAmountType
        let timesAmount: Int?
        let stage: FastingHistoryStage?
        let selectedDateRangeType: SelectedDateType
        let viewType: ViewType

        enum AverageAmountType {
            case averageTime(TimeInterval)
            case averageWater(amount: String, waterUnits: WaterUnits)
        }

        enum ViewType {
            case fasting
            case water
        }
    }

    enum SelectedDateType {
        case week
        case day
    }
}

private extension CGFloat {
    static let periodVerticalPadding: CGFloat = 16
    static let periodLeadingPadding: CGFloat = 26
    static let imageClosHeight: CGFloat = 10
    static let imageClosTrailingPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 16
    static let horizontalPadding: CGFloat = 20
    static let cornerRadius: CGFloat = 20
    static let spacing: CGFloat = 4
    static let imageHeight: CGFloat = 24
    static let striveLineSpacing: CGFloat = 5
    static let striveHorizontalPadding: CGFloat = 16
    static let striveVerticalPadding: CGFloat = 6
}

extension SelectedHeaderItemView.ViewData{
    static var mock: SelectedHeaderItemView.ViewData {
        .init(dateAmount: "February 13", 
              averageTitle: "FastingHistoryScreen.waterConsumed".localized(bundle: .module),
              averageTime: .averageWater(amount: "1,2", waterUnits: .liters),
              timesAmount: 24,
              stage: .autophagy, 
              selectedDateRangeType: .day, 
              viewType: .water)
    }

    static var mockWeekly: SelectedHeaderItemView.ViewData {
        .init(dateAmount: "Feb 13 - Feb 24",
              averageTitle: "FastingHistoryScreen.weeklyTime".localized(bundle: .module),
              averageTime: .averageTime(.hour * 19 + .minute * 15),
              timesAmount: 24,
              stage: .autophagy,
              selectedDateRangeType: .week,
              viewType: .fasting)
    }

    static var mockWeeklyEmptyTarget: SelectedHeaderItemView.ViewData {
        .init(dateAmount: "Feb 13 - Feb 24", 
              averageTitle: "FastingHistoryScreen.weeklyTime".localized(bundle: .module),
              averageTime: .averageTime(.hour * 19 + .minute * 15),
              timesAmount: nil,
              stage: nil,
              selectedDateRangeType: .week,
              viewType: .water)
    }
}

extension SelectedHeaderItemView.ViewData? {
    init(context: FastingHistoryInput.Context,
         selectedItem: FastingHistoryChartItem?,
         selectedPeriod: GraphPeriod,
         items: [FastingHistoryChartItem]) {
        guard let selectedItem else {
            self = nil
            return
        }

        var averageTitle: String {
            switch selectedPeriod {
            case .week, .month:
                return context == .fasting
                ? "FastingHistoryScreen.weeklyTime".localized(bundle: .module)
                : "FastingHistoryScreen.waterConsumed".localized(bundle: .module)

            case .threeMonths:
                return "FastingHistoryScreen.weeklyTime".localized(bundle: .module)
            }
        }

        var viewType: SelectedHeaderItemView.ViewData.ViewType {
            return context == .fasting ? .fasting : .water
        }

        if selectedPeriod == .threeMonths {
            let filteredItems = items.filter {
                $0.date.year == selectedItem.date.year
                && $0.date.month == selectedItem.date.month
                && $0.date.week == selectedItem.date.week
            }

            let filteredDatesAmountWithoutEmptyData = filteredItems.filter {
                $0.value != 0
            }.count

            let firstDate = filteredItems.first?.date.formatted(Date.FormatStyle().day().month()) ?? ""
            let lastDate = filteredItems.last?.date.formatted(Date.FormatStyle().day().month()) ?? ""

            var averageAmountType: SelectedHeaderItemView.ViewData.AverageAmountType {
                let totalAmount = filteredItems
                    .map { $0.value }
                    .reduce(0, +)

                switch context {
                case .fasting:
                    var averageTimeInterval: TimeInterval {
                        guard filteredDatesAmountWithoutEmptyData != 0 else { return .init(minutes: 0)}
                        return .init(minutes: Int((totalAmount * 60) / Double(filteredDatesAmountWithoutEmptyData)))
                    }
                    return .averageTime(averageTimeInterval)
                case let .water(waterUnits):
                    var averageWater: String {
                        guard filteredDatesAmountWithoutEmptyData != 0 else { return "0" }
                        var format: String {
                            waterUnits == .liters ? "%.1f" : "%.0f"
                        }
                        return String(format: format, totalAmount / Double(filteredDatesAmountWithoutEmptyData))
                    }
                    return .averageWater(amount: averageWater, waterUnits: waterUnits)
                }
            }

            var timesAmount: (stage: FastingHistoryStage?, amount: Int?) {
                let timesAmount = filteredItems
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
                dateAmount: "\(firstDate) - \(lastDate)", 
                averageTitle: averageTitle,
                averageTime: averageAmountType,
                timesAmount: timesAmount.amount,
                stage: timesAmount.stage,
                selectedDateRangeType: .week, 
                viewType: viewType
            )

            return
        }

        var averageAmountType: SelectedHeaderItemView.ViewData.AverageAmountType {
            switch context {
            case .fasting:
                return .averageTime(.init(minutes: Int(selectedItem.value * 60)))
            case let .water(waterUnits):
                return .averageWater(amount: String(format: "%.1f", selectedItem.value), waterUnits: waterUnits)
            }
        }

        self = .init(
            dateAmount: selectedItem.date.formatted(Date.FormatStyle().day().month(.wide)), 
            averageTitle: averageTitle,
            averageTime: averageAmountType,
            timesAmount: nil,
            stage: selectedItem.stage,
            selectedDateRangeType: .day, 
            viewType: viewType)
    }
}

#Preview {
    VStack {
        SelectedHeaderItemView(viewData: .mock) {}
        SelectedHeaderItemView(viewData: .mockWeekly) {}
        SelectedHeaderItemView(viewData: .mockWeeklyEmptyTarget) {}
    }
}
