//  
//  ScaleWeightHistoryScreen.swift
//  
//
//  Created by Руслан Сафаргалеев on 03.04.2024.
//

import SwiftUI
import AppStudioNavigation
import Combine

struct ScaleWeightHistoryScreen: View {
    @StateObject var viewModel: ScaleWeightHistoryViewModel

    var body: some View {
        VStack(spacing: .zero) {
            ScaleWeightHistoryTitleView(onPlusTap: viewModel.addWeight)
                .padding(.bottom, .titleBottomPadding)
            VStack(spacing: .spacing) {
                ForEach(viewModel.weight) { weight in
                    Button(action: {
                        viewModel.update(weight: weight)
                    }, label: {
                        ScaleWeightHistoryWeightView(weight: weight)
                            .withRightSwipeActions(
                                [.delete(onTap: {
                                    viewModel.delete(weight: weight)
                                })]
                            )
                    })
                }
            }
            .continiousCornerRadius(.cornerRadius)
        }
        .animation(.bouncy, value: viewModel.weight)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 2
    static let titleBottomPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 20

}

struct ScaleWeightHistoryScreen_Previews: PreviewProvider {
    static var previews: some View {
        ScaleWeightHistoryScreen(viewModel: .init(
            weightPublisher: Just([.mock, .mock, .mock, .mock])
                .eraseToAnyPublisher(),
            weightUnits: .kg,
            router: .init(navigator: .init())))
        .padding(.horizontal, 16)
    }
}
