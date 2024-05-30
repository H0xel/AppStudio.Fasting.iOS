//
//  NovaTricks.swift
//  
//
//  Created by Denis Khlopin on 19.04.2024.
//

import Foundation
import AppStudioStyles

struct NovaTricks: Codable, Hashable {
    let title: String?
    let questions: [String]
}

extension NovaTricks {

    static var mock: NovaTricks {
        .init(
            title: "More Tricks from Nova",
            questions: [
                "Chicken breast recipes",
                "Dishes with pumpkin",
                "How can I improve my BMI healthily?",
                "What are healthy, budget-friendly meals?",
                "A guide for calorie consumption?"
            ])
    }
}
