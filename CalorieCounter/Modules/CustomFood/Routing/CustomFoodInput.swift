//  
//  CustomFoodInput.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.07.2024.
//

struct CustomFoodInput {
    let context: Context
    enum Context: Equatable {
        case create
        case edit(MealItem)
        case barcode(barcode: String)
        case duplicate(MealItem)


        var isInitial: Bool {
            switch self {
            case .create, .barcode:
                true
            case .edit, .duplicate:
                false
            }
        }
    }
}
