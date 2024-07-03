//
//  IngredientRouter.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 31.05.2024.
//

import Foundation
import AppStudioUI
import AppStudioNavigation

class IngredientRouter: BaseRouter {
    func presentDeleteBanner(editType: MealEditType,
                             onCancel: @escaping () -> Void,
                             onDelete: @escaping () -> Void,
                             onEdit: @escaping () -> Void) {
        let banner = MealDeleteBanner(editType: editType,
                                      onCancel: onCancel,
                                      onDelete: onDelete,
                                      onEdit: onEdit)
        present(banner: banner)
    }

    func presentChangeWeightBanner(input: CustomKeyboardInput, output: @escaping ViewOutput<CustomKeyboardOutput>) {
        let banner = CustomKeyboardBanner(input: input, output: output)
        present(banner: banner, animation: .linear(duration: 0.2))
    }
}
