//
//  CustomFoodScrollView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.07.2024.
//

import SwiftUI

struct CustomFoodScrollView: View {
    @ObservedObject var viewModel: CustomFoodViewModel

    var body: some View {
        ScrollViewReader { reader in
            CustomKeyboardScrollView(isKeyboardPresented: viewModel.isKeyboardPresented, onScroll: {}) {
                VStack(spacing: .zero) {
                    CustomFoodTextfield(selectedField: $viewModel.selectedField,
                                        text: $viewModel.customFoodViewData.foodNameText,
                                        configuration: .foodName)
                        .padding(.top, .textFieldTopPadding)
                        .id(CustomFoodField.foodName)
                    CustomFoodTextfield(selectedField: $viewModel.selectedField,
                                        text: $viewModel.customFoodViewData.brandNameText,
                                        configuration: .brandName)
                        .padding(.vertical, .textFieldVerticalPadding)
                        .id(CustomFoodField.brandName)

                    VStack(alignment: .leading, spacing: .spacing) {
                        Text("CustomFood.textfield.nutritionFacts")
                            .font(.poppins(.headerS))
                            .padding(.vertical, .headerVerticalPadding)
                            .padding(.horizontal, .horizontalPadding)

                        CustomFoodServingView(viewModel: viewModel)

                        VStack(spacing: .zero) {
                            CustomFoodAmountView(
                                configuration: .amount,
                                selectedField: $viewModel.selectedField,
                                weight: $viewModel.customFoodViewData.amountPer,
                                selectedServing: viewModel.customFoodViewData.selectedServing,
                                fieldType: .amountPer,
                                isInitialWeight: !viewModel.changedFields.contains(.amountPer))
                            .id(CustomFoodField.amountPer)

                            CustomFoodAmountView(
                                configuration: .calories,
                                selectedField: $viewModel.selectedField,
                                weight: $viewModel.customFoodViewData.calories,
                                selectedServing: .init(weight: nil, measure: "kcal", quantity: 1),
                                fieldType: .calories,
                                isInitialWeight: !viewModel.changedFields.contains(.calories))
                            .id(CustomFoodField.calories)

                            CustomFoodAmountView(
                                configuration: .fat,
                                selectedField: $viewModel.selectedField,
                                weight: $viewModel.customFoodViewData.fat,
                                fieldType: .fat,
                                isInitialWeight: !viewModel.changedFields.contains(.fat))
                            .id(CustomFoodField.fat)

                            CustomFoodAmountView(
                                configuration: .carbs,
                                selectedField: $viewModel.selectedField,
                                weight: $viewModel.customFoodViewData.carbs,
                                fieldType: .carbs,
                                isInitialWeight: !viewModel.changedFields.contains(.carbs))
                            .id(CustomFoodField.carbs)

                            CustomFoodAmountView(
                                configuration: .protein,
                                selectedField: $viewModel.selectedField,
                                weight: $viewModel.customFoodViewData.protein,
                                fieldType: .protein,
                                isInitialWeight: !viewModel.changedFields.contains(.protein))
                            .id(CustomFoodField.protein)
                        }
                        .padding(.vertical, .amountVerticalPadding)
                        .background()
                        .continiousCornerRadius(.cornerRadius)

                        CustomFoodBarCodeView(
                            viewState: viewModel.customFoodViewData.barcode == nil
                            ? .addBarcode
                            : .barcodeAdded(barcode: viewModel.customFoodViewData.barcode ?? ""),
                            action: viewModel.handle
                        )

                        CustomFoodButton(
                            isDisabled: viewModel.customFoodViewData.foodNameText.isEmpty,
                            onSaveTapped: viewModel.save
                        )
                    }
                    .padding(.horizontal, .horizontalPadding)
                    .aligned(.left)
                }
                .onChange(of: viewModel.selectedField) { id in
                    guard viewModel.selectedField != .servingName else { return }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.linear) {
                            reader.scrollTo(id, anchor: .init(x: 0, y: 0.2))
                        }
                    }
                }
            }
            .background(Color.studioGreyFillProgress)
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.never)
        }
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let textFieldTopPadding: CGFloat = 16
    static let textFieldVerticalPadding: CGFloat = 8
    static let spacing: CGFloat = 8

    static let headerVerticalPadding: CGFloat = 8
    static let cornerRadius: CGFloat = 20
    static let amountVerticalPadding: CGFloat = 4
}

#Preview {
    CustomFoodScrollView(viewModel: .init(input: .init(context: .create), output: { _ in }))
}
