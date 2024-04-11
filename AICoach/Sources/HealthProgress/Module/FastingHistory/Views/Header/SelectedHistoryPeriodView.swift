//
//  FastingHistoryHeaderView.swift
//
//
//  Created by Amakhin Ivan on 19.03.2024.
//

import SwiftUI

@available(iOS 17.0, *)
struct SelectedHistoryPeriodView: View {
    @EnvironmentObject var viewModel: FastingHistoryViewModel
    var action: () -> Void
    @State private var date: Date = .now

    var body: some View {
        VStack(spacing: .zero) {
            if let selectedViewData = .init(context: viewModel.context,
                                            selectedItem: viewModel.selectedItem,
                                            selectedPeriod: viewModel.selectedPeriod,
                                            items: viewModel.chartItems
            ) {
                SelectedHeaderItemView(viewData: selectedViewData) {
                    action()
                }
            } else {
                UnSelectedHeaderItemView(viewData: .init(
                    context: viewModel.context, 
                    date: date,
                    selectedPeriod: viewModel.selectedPeriod,
                    items: viewModel.chartItems))
            }
        }
        .onReceive(viewModel.scrollDate) { date in
            self.date = date
        }
    }
}

private extension CGFloat {
    static let periodSpacing: CGFloat = 4
    static let periodVerticalPadding: CGFloat = 10
    static let periodHorizontalPadding: CGFloat = 20
    static let periodCornerRadius: CGFloat = 32
}
