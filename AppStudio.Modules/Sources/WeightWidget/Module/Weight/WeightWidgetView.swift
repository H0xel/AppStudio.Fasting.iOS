//
//  WeightWidgetView.swift
//
//
//  Created by Руслан Сафаргалеев on 13.03.2024.
//

import SwiftUI
import AppStudioModels
import AppStudioStyles

public struct WeightWidgetView: View {

    let date: Date
    @ObservedObject var viewModel: WeightWidgetViewModel

    public var body: some View {
        VStack(spacing: .zero) {
            VStack(spacing: .spacing) {
                WidgetTitleView(title: .title,
                                icon: .widgetInfo) {
                    viewModel.presentHint(source: "info")
                }
                HStack(alignment: .top, spacing: .zero) {
                    WeightValueView(title: .scaleWeight,
                                    weight: viewModel.weight(for: date),
                                    isBig: true)
                    .aligned(.left)
                    WeightValueView(title: .trueWeight,
                                    weight: viewModel.trueWeight(for: date),
                                    isBig: false)
                    .aligned(.left)
                }
                WidgetActionButton(title: .update,
                                   isActive: false,
                                   onTap: viewModel.updateWeight)
            }
            .modifier(WidgetModifier())
            .modifier(BottomHealthWidgetHintModifier(isHintPresented: viewModel.isHintPresented,
                                                     hint: .weight,
                                                     onClose: viewModel.hideHint) {
                viewModel.presentHint(source: "learn_more")
            })
        }
        .animation(.bouncy, value: viewModel.isHintPresented)
    }
}

private extension String {
    static let title = "WeightWidgetView.title".localized(bundle: .module)
    static let scaleWeight = "WeightWidgetView.scaleWeight".localized(bundle: .module)
    static let trueWeight = "WeightWidgetView.trueWeight".localized(bundle: .module)
    static let update = "WeightWidgetView.update".localized(bundle: .module)
}

private extension CGFloat {
    static let spacing: CGFloat = 16
    static let verticalSpacing: CGFloat = 4
    static let weightSpacing: CGFloat = 4
    static let trueWeightTopPadding: CGFloat = 4
    static let weightUnitOffset: CGFloat = -2
}

#Preview {
    ZStack {
        Color.red
        WeightWidgetView(date: .now, viewModel: .init())
    }

}
