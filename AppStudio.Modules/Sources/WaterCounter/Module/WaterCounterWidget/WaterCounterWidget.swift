//
//  WaterCounterWidget.swift
//
//
//  Created by Denis Khlopin on 14.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

public struct WaterCounterWidget: View {
    let date: Date
    @ObservedObject var viewModel: WaterCounterWidgetViewModel

    public init(date: Date, viewModel: WaterCounterWidgetViewModel) {
        self.date = date
        self._viewModel = ObservedObject(wrappedValue: viewModel)
        viewModel.update(for: date)
    }

    var percent: Double {
        viewModel.percent(for: date)
    }

    public var body: some View {
        VStack(spacing: .spacing) {
            // MARK: - Widget Title
            WidgetTitleView(title: Localization.title, icon: .widgetSettings) {
                viewModel.showSettings(for: date)
            }

            // MARK: - Water quantity and glass image
            HStack(alignment: .center, spacing: .emptySpacing) {

                // MARK: - current water title
                VStack(alignment: .leading, spacing: .titleSpacing) {
                    Text(viewModel.currentWaterTitle(for: date))
                        .font(.poppinsBold(.headerM))
                        .foregroundStyle(Color.studioBlackLight)
                    Text(viewModel.totalWaterTitle(for: date))
                        .font(.poppins(.description))
                        .foregroundStyle(Color.studioGrayText)
                }

                Spacer()

                // MARK: - Glass
                ZStack {
                    VStack(spacing: .emptySpacing) {
                        Spacer()
                        Rectangle()
                            .padding(.horizontal, .glassHorizontalPadding)
                            .foregroundColor(.studioSky)
                            .frame(height: percent * .glassHeight)
                    }
                    VStack(spacing: .emptySpacing) {
                        Spacer()
                        Image.emptyGlass
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: .glassWidth, height: .glassHeight)
                    }
                }
                .frame(width: .glassWidth, height: .glassHeight)
                .animation(.bouncy(duration: 0.7), value: percent)
            }
            // MARK: - Buttons
            HStack(spacing: .emptySpacing) {
                button(image: .keyboard, action: {
                    viewModel.showAddWater(for: date)
                })
                .background(Color.studioGrayFillProgress)
                .continiousCornerRadius(.continiousRadius)

                Spacer()

                ZStack {
                    HStack(spacing: .emptySpacing) {
                        button(image: .minusEx) { viewModel.removeWater(for: date) }
                            .padding(.horizontal, .buttonHorizontalPadding)

                        Spacer().frame(width: .betweenButtonsSpace)

                        button(image: .plusEx) { viewModel.addWater(for: date) }
                            .padding(.horizontal, .buttonHorizontalPadding)
                    }
                    .background(Color.studioGrayFillProgress)
                    .continiousCornerRadius(.continiousRadius)

                    Text(viewModel.prefferdWaterValueTitle)
                        .font(.poppins(.description))
                        .foregroundStyle(Color.studioBlackLight)
                }
            }
        }
        .modifier(WidgetModifier())
    }

    private func button(image: Image, action: @escaping () -> Void) -> some View {
        Button(action: action, label: {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .buttonSize, height: .buttonSize)
                .padding(.buttonPadding)
                .contentShape(Rectangle())
        })
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let emptySpacing: CGFloat = 0
    static let spacing: CGFloat = 16
    static let titleSpacing: CGFloat = 4
    static let glassWidth: CGFloat = 205
    static let glassHeight: CGFloat = 96
    static let glassHorizontalPadding: CGFloat = 65
    static let buttonHorizontalPadding: CGFloat = 14.25
    static let betweenButtonsSpace: CGFloat = 60
    static let buttonSize: CGFloat = 24
    static let buttonPadding: CGFloat = 10
    static let continiousRadius: CGFloat = 44
}

// MARK: - Localization
private extension WaterCounterWidget {
    enum Localization {
        static let title: String = NSLocalizedString("WaterCounterWidget.title", bundle: .module, comment: "")
    }
}

struct WaterCounterWidgetScreen_Previews: PreviewProvider {
    static var previews: some View {
        WaterCounterWidget(
            date: .now,
            viewModel: WaterCounterWidgetViewModel(
                output: { _ in })
        )
    }
}
