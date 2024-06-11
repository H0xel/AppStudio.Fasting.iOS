//
//  IngredientRouter.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 31.05.2024.
//

import Foundation
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

    func presentChangeWeightBanner(title: String,
                                   initialWeight: Double,
                                   onWeightChange: @escaping (Double) -> Void,
                                   onCancel: @escaping () -> Void) {
        let banner = ChangeWeightBanner(title: title,
                                        initialWeight: initialWeight,
                                        onWeightChange: onWeightChange,
                                        onCancel: onCancel)
        present(banner: banner)
    }
}
