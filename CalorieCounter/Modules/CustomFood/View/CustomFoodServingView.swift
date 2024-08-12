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
                Button(action: { viewModel.selectedField = .servingSize },
                       label: {
                    MealWeightView(type: .weight(viewModel.customFoodViewData.servingSize),
                                   serving: viewModel.customFoodViewData.selectedServing,
                                   isTapped: viewModel.selectedField == .servingSize,
                                   withoutDecimalIfNeeded: true,
                                   weightColor: !viewModel.changedFields.contains(.servingSize)
                                   ? Color.studioGrayText
                                   : Color.studioBlackLight)
                })
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
                
                Button(action: { viewModel.selectedField = .servingAmount }, label: {
                    MealWeightView(type: .weight(viewModel.customFoodViewData.servingAmount),
                                   serving: .init(weight: nil, measure: "", quantity: 1),
                                   isTapped: viewModel.selectedField == .servingAmount,
                                   weightColor: !viewModel.changedFields.contains(.servingAmount)
                                   ? Color.studioGrayText
                                   : Color.studioBlackLight,
                                   width: .width)
                    .id(CustomFoodField.servingAmount)
                })

                Text("×")
                    .font(.poppins(.description))
                    .padding(.horizontal, .xHorizontalPadding)

                Button(action: { viewModel.selectedField = .servingName }, label: {
                    MealWeightView(type: .text(viewModel.customFoodViewData.servingName),
                                   serving: .init(weight: nil, measure: "", quantity: 1),
                                   isTapped: viewModel.selectedField == .servingName,
                                   weightColor: !viewModel.changedFields.contains(.servingName)
                                   ? Color.studioGrayText
                                   : Color.studioBlackLight)
                    .id(CustomFoodField.servingName)
                })
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
    CustomFoodServingView(viewModel: .init(input: .init(context: .create), output: { _ in }))
}
