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
    @State private var isPresented = true
    @State private var isFocused = true
    @State private var isDragging = false

    var body: some View {
        VStack(spacing: .zero) {
            Spacer()
            CardView {
                if !isPresented, !isDragging {
                    Text(Localization.title)
                        .font(.poppins(.description))
                        .foregroundStyle(Color.studioGrayText)
                        .padding(.top, .titleTopPadding)
                        .padding(.bottom, .titleBottomPadding)
                        .transition(.identity)
                        .animation(nil, value: isPresented)
                }

                VStack(spacing: .stackVerticalSpacing) {
                    DoubleCustomTextField(
                        title: Localization.caloriesTitle,
                        placeholder: "0",
                        value: $viewModel.calories,
                        settings: .init(titleColor: NutritionType.calories.color,
                                        units: Localization.caloriesUnits),
                        isKeyboardFocused: isFocused
                    )

                    QuickAddNutritionsView(fats: $viewModel.fats,
                                           carbs: $viewModel.carbs,
                                           proteins: $viewModel.proteins)

                    HStack(alignment: .bottom, spacing: .horizontalSpacing) {
                        StringCustomTextField(
                            title: Localization.foodNameTitle,
                            placeholder: Localization.foodNamePlaceholder,
                            value: $viewModel.foodName,
                            settings: .init(titleColor: Color.studioGrayText, units: "")
                        )

                        QuickAddSaveButton(isAvailable: viewModel.isSaveAvailable,
                                           onTap: viewModel.save)
                    }
                }
                .padding(.horizontal, .horizontalPadding)
                .padding(.bottom, .bottomPadding)
                .opacity(isDragging || isPresented ? 1 : 0)
            }
            .modifier(DragableModifier(
                isCollapsed: !isPresented,
                bottomPadding: 56,
                onChangeCollapsed: { isCollapsed in
                    isPresented = !isCollapsed
                },
                onDraging: { isDragging in
                    self.isDragging = isDragging
                }
            ))

            if isPresented, !isDragging, viewModel.editedMeal == nil {
                LogChipsView(logType: .quickAdd,
                             onPick: viewModel.changeLogType,
                             onClose: viewModel.close)
            }
        }
        .modifier(DimmedBackgroundModifier(isDimmed: isPresented, onTap: collapse))
        .onChange(of: isPresented) { isPresented in
            isFocused = isPresented
            if !isPresented {
                hideKeyboard()
            }
        }
    }

    private func collapse() {
        isPresented = false
    }
}

private extension CGFloat {
    static let stackVerticalSpacing: CGFloat = 12
    static let horizontalPadding: CGFloat = 10
    static let bottomPadding: CGFloat = 10
    static let horizontalSpacing: CGFloat = 4
    static let titleTopPadding: CGFloat = 6
    static let titleBottomPadding: CGFloat = 26
}

// MARK: - Localization
private extension QuickAddView {
    enum Localization {
        static let title = NSLocalizedString("QuickAdd.title", comment: "Quick Add")
        static let caloriesTitle = NSLocalizedString("QuickAdd.calories", comment: "calories")
        static let foodNameTitle = NSLocalizedString("QuickAdd.foodName", comment: "foodName")
        static let caloriesUnits = NSLocalizedString("QuickAdd.calories.units", comment: "g")
        static let foodNamePlaceholder = NSLocalizedString("QuickAdd.foodName.placeholder", comment: "g")
    }
}

struct QuickAddScreen_Previews: PreviewProvider {
    static var previews: some View {
        QuickAddView(
            viewModel: .init(input: .init(meal: .mock, mealType: .breakfast, dayDate: .now),
                             output: { _ in })
        )
    }
}
