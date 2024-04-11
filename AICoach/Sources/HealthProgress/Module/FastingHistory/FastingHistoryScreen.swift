//  
//  FastingHistoryScreen.swift
//  
//
//  Created by Denis Khlopin on 12.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles
import Combine

@available(iOS 17.0, *)
struct FastingHistoryScreen: View {
    @StateObject var viewModel: FastingHistoryViewModel

    var body: some View {
        ScrollView(showsIndicators: false) {
            FastingHistoryPeriodView(selectedPeriod: viewModel.selectedPeriod) { period in
                viewModel.periodSelected(period)
            }

            SelectedHistoryPeriodView() {
                viewModel.resetSelectedItem()
            }
            .environmentObject(viewModel)

            FastingHistoryChart(
                selectedItem: $viewModel.selectedItem,
                context: viewModel.context,
                initialPosition: viewModel.initialPosition,
                selectedPeriod: viewModel.selectedPeriod,
                items: viewModel.chartItems
            ) {
                viewModel.updateScrollDate($0)
            }

            switch viewModel.context {
            case .fasting:
                FastingHistoryBottomView(
                    records: viewModel.fastingHistoryData.records,
                    onDelete: viewModel.delete(historyId:),
                    onEdit: viewModel.edit(historyId:),
                    onAdd: viewModel.addHistory
                )
            case .water:
                WaterHistoryBottomView(
                    history: viewModel.waterHistoryData,
                    onDelete: viewModel.deleteWater(at:),
                    onEdit: viewModel.editWater(at:),
                    onAdd: viewModel.addWater)
            }


        }
        .navBarButton(placement: .navigationBarTrailing,
                      isVisible: viewModel.context == .fasting,
                      content: Image(.circleInfo),
                      action: viewModel.infoTapped)
        .navBarButton(content: Image(systemName: "chevron.left").foregroundStyle(.black),
                      action: viewModel.backTapped)
        .navBarButton(placement: .principal,
                      content: navigationTitle,
                      action: {})
        .navigationBarTitleDisplayMode(.inline)
    }

    private var navigationTitle: some View {
        Text(viewModel.context.title)
            .font(.poppins(.buttonText))
            .foregroundStyle(Color.studioBlackLight)
    }
}

@available(iOS 17.0, *)
struct FastingHistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FastingHistoryScreen(
                viewModel: FastingHistoryViewModel(
                    input: FastingHistoryInput(
                        context: .water(.liters),
                        historyData: .mock,
                        chartItems: .mock,
                        inputHistoryPublisher: Empty().eraseToAnyPublisher()
                    ),
                    output: { _ in }
                )
            )
        }
    }
}
