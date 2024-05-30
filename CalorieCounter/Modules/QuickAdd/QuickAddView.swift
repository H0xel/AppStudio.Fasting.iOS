//  
//  QuickAddView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 10.05.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

struct QuickAddView: View {
    @StateObject var viewModel: QuickAddViewModel
    @GestureState private var dragOffset: CGFloat = 0
    @State private var viewHeight: CGFloat = 0
    @State private var bottomPadding: CGFloat = 0
    @Binding var isPresented: Bool

    var body: some View {
        ZStack {
            if isPresented {
                Color.studioBlackLight
                    .animation(.smooth, value: isPresented)
                    .opacity(0.2)
                    .onTapGesture {
                        isPresented = false
                        hideKeyboard()
                    }
            }
            VStack {
                Spacer()
                VStack(spacing: .zero) {
                    Color.studioGreyStrokeFill
                        .frame(width: .stickWidth, height: .stickHeight)
                        .continiousCornerRadius(.stickCornerRadius)
                        .padding(.vertical, .stickVerticalPadding)
                        .animation(nil, value: viewHeight)

                    if !isPresented {
                        Text(Localization.title)
                            .font(.poppins(.description))
                            .foregroundStyle(Color.studioGrayText)
                            .padding(.top, .titleTopPadding)
                            .padding(.bottom, .titleBottomPadding)
                    }

                    VStack(spacing: .stackVerticalSpacing) {
                        DoubleCustomTextField(
                            title: Localization.caloriesTitle,
                            placeholder: "0",
                            value: $viewModel.calories,
                            settings: .init(titleColor: NutritionType.calories.color,
                                            units: Localization.caloriesUnits),
                            isKeyboardFocused: true
                        )
                        HStack(spacing: .horizontalSpacing) {
                            DoubleCustomTextField(
                                title: Localization.fatTitle,
                                placeholder: "0",
                                value: $viewModel.fats,
                                settings: .init(titleColor: NutritionType.fats.color,
                                                units: Localization.nutritionsUnits)
                            )
                            DoubleCustomTextField(
                                title: Localization.carbsTitle,
                                placeholder: "0",
                                value: $viewModel.carbs,
                                settings: .init(titleColor: NutritionType.carbs.color,
                                                units: Localization.nutritionsUnits)
                            )
                            DoubleCustomTextField(
                                title: Localization.proteinTitle,
                                placeholder: "0",
                                value: $viewModel.proteins,
                                settings: .init(titleColor: NutritionType.proteins.color,
                                                units: Localization.nutritionsUnits)
                            )
                        }

                        HStack(alignment: .bottom, spacing: .horizontalSpacing) {
                            StringCustomTextField(
                                title: Localization.foodNameTitle,
                                placeholder: Localization.foodNamePlaceholder,
                                value: $viewModel.foodName,
                                settings: .init(titleColor: Color.studioGrayText, units: "")
                            )

                            Button {
                                viewModel.save()
                            } label: {
                                Image.arrowUp
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: .arrowImageSize, height: .arrowImageSize)
                                    .foregroundStyle(viewModel.isSaveAvailable
                                                     ? Color.white
                                                     : Color.studioGrayPlaceholder)
                                    .padding(.arrowImagePadding)
                                    .background(viewModel.isSaveAvailable
                                                ? Color.studioBlackLight
                                                : Color.studioGrayFillProgress)
                                    .continiousCornerRadius(.cornerRadius)
                            }
                            .disabled(!viewModel.isSaveAvailable)
                        }
                    }
                    .padding(.horizontal, .horizontalPadding)
                    .padding(.bottom, .bottomPadding)
                    .withViewHeightPreferenceKey
                    .opacity((-dragOffset + bottomPadding > -viewHeight) || isPresented ? 1 : 0)
                }
                .background(Color.white)
                .onViewHeightPreferenceKeyChange({ height in
                    viewHeight = height
                })
                .gesture (
                    DragGesture(coordinateSpace: .global)
                        .updating($dragOffset, body: { value, state, _ in
                            state = value.translation.height
                        })
                        .onEnded({ value in
                            bottomPadding -= value.translation.height
                            withAnimation(.smooth) {
                                if value.translation.height > 0 {
                                    bottomPadding = -viewHeight
                                    isPresented = false
                                    viewModel.clearFocus()
                                } else {
                                    bottomPadding = 0
                                    isPresented = true
                                }
                            }
                        })
                )
                .corners([.topLeft, .topRight], with: .topCornerRadius)
                .padding(.bottom, min(0, -dragOffset + bottomPadding))
                .onDisappear { viewModel.output(.dismiss) }
                .onChange(of: isPresented, perform: { value in
                    withAnimation(.smooth) {
                        bottomPadding = isPresented ? 0 : -viewHeight
                    }
                })
                .onAppear {
                    bottomPadding = isPresented ? 0 : -viewHeight
                }
            }
        }
    }
}

private extension CGFloat {
    static let stickWidth: CGFloat = 32
    static let stickHeight: CGFloat = 5
    static let stickCornerRadius: CGFloat = 16
    static let stickVerticalPadding: CGFloat = 6
    static let stackVerticalSpacing: CGFloat = 12
    static let horizontalPadding: CGFloat = 10
    static let bottomPadding: CGFloat = 10
    static let cornerRadius: CGFloat = 100
    static let arrowImageSize: CGFloat = 14
    static let arrowImagePadding: CGFloat = 17
    static let horizontalSpacing: CGFloat = 4
    static let titleTopPadding: CGFloat = 6
    static let titleBottomPadding: CGFloat = 26
    static let topCornerRadius: CGFloat = 20
}

// MARK: - Localization
private extension QuickAddView {
    enum Localization {
        static let title = NSLocalizedString("QuickAdd.title", comment: "Quick Add")
        static let fatTitle = NSLocalizedString("QuickAdd.fat", comment: "fat")
        static let carbsTitle = NSLocalizedString("QuickAdd.carbs", comment: "carbs")
        static let proteinTitle = NSLocalizedString("QuickAdd.protein", comment: "protein")
        static let caloriesTitle = NSLocalizedString("QuickAdd.calories", comment: "calories")
        static let foodNameTitle = NSLocalizedString("QuickAdd.foodName", comment: "foodName")
        static let nutritionsUnits = NSLocalizedString("QuickAdd.nutritions.units", comment: "g")
        static let caloriesUnits = NSLocalizedString("QuickAdd.calories.units", comment: "g")
        static let foodNamePlaceholder = NSLocalizedString("QuickAdd.foodName.placeholder", comment: "g")
    }
}

struct QuickAddScreen_Previews: PreviewProvider {
    static var previews: some View {
        QuickAddView(
            viewModel: QuickAddViewModel(
                meal: nil,
                output: { _ in }
            ), isPresented: .constant(true)
        )
    }
}
