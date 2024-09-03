//
//  CustomFoodServingView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.07.2024.
//

import SwiftUI

struct CustomFoodServingView: View {
    @ObservedObject var viewModel: CustomFoodViewModel

    var body: some View {
        VStack(spacing: .zero) {
            HStack(spacing: .zero) {
                Text("CustomFood.textfield.servingSize")
                    .font(.poppins(.description))
                Spacer()
                MealWeightView(isTextSelected: .init(get: {
                    viewModel.isInputTextSelected && viewModel.selectedField == .servingSize
                }, set: { isSelected in
                    viewModel.isInputTextSelected = isSelected
                }),
                               type: .weight(viewModel.customFoodViewData.servingSize),
                               serving: viewModel.customFoodViewData.selectedServing,
                               isTapped: viewModel.selectedField == .servingSize,
                               withoutDecimalIfNeeded: true,
                               weightColor: !viewModel.changedFields.contains(.servingSize)
                               ? Color.studioGrayText
                               : Color.studioBlackLight) {
                    viewModel.selectedField = .servingSize
                }
            }
            .padding(.vertical, .verticalPadding)
            .id(CustomFoodField.servingSize)


            HStack(spacing: .zero) {
                VStack(alignment: .leading, spacing: .spacing) {
                    Text("CustomFood.textfield.servingName")
                    Text("CustomFood.textfield.servingExample")
                        .foregroundStyle(Color.studioGreyText)
                }
                .font(.poppins(.description))

                Spacer()

                MealWeightView(isTextSelected: .init(get: {
                    viewModel.isInputTextSelected && viewModel.selectedField == .servingAmount
                }, set: { isSelected in
                    viewModel.isInputTextSelected = isSelected
                }),
                               type: .weight(viewModel.customFoodViewData.servingAmount),
                               serving: .init(weight: nil, measure: "", quantity: 1),
                               isTapped: viewModel.selectedField == .servingAmount,
                               weightColor: !viewModel.changedFields.contains(.servingAmount)
                               ? Color.studioGrayText
                               : Color.studioBlackLight,
                               width: .width) {
                    viewModel.selectedField = .servingAmount
                }
                .id(CustomFoodField.servingAmount)

                Text("×")
                    .font(.poppins(.description))
                    .padding(.horizontal, .xHorizontalPadding)

                MealWeightView(isTextSelected: .init(get: {
                    viewModel.isInputTextSelected && viewModel.selectedField == .servingName
                }, set: { isSelected in
                    viewModel.isInputTextSelected = isSelected
                }),
                               type: .text(viewModel.customFoodViewData.servingName),
                               serving: .init(weight: nil, measure: "", quantity: 1),
                               isTapped: viewModel.selectedField == .servingName,
                               weightColor: !viewModel.changedFields.contains(.servingName)
                               ? Color.studioGrayText
                               : Color.studioBlackLight) {
                    viewModel.selectedField = .servingName
                }
                .id(CustomFoodField.servingName)
            }
            .padding(.top, .topPadding)
            .padding(.bottom, .bottomPadding)
        }
        .padding(.leading, .leadingPadding)
        .padding(.trailing, .trailingPadding)
        .background()
        .continiousCornerRadius(.cornerRadius)
    }
}

private extension CGFloat {
    static let verticalPadding: CGFloat = 8
    static let spacing: CGFloat = 2
    static let topPadding: CGFloat = 8
    static let bottomPadding: CGFloat = 12
    static let leadingPadding: CGFloat = 20
    static let trailingPadding: CGFloat = 12
    static let cornerRadius: CGFloat = 20
    static let xHorizontalPadding: CGFloat = 4
    static let width: CGFloat = 48
}

#Preview {
    CustomFoodServingView(viewModel: .init(router: .init(navigator: .init()),
                                           input: .init(context: .create),
                                           output: { _ in }))
}
