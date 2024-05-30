//
//  ArticleStack.swift
//
//
//  Created by Denis Khlopin on 19.04.2024.
//

import Foundation

// стек статей, отображается на главном окне ввиде нескольких блоков статей,
// каждый блок содержит несколько статей и вопросы для Nova
struct ArticleStack: Codable, Hashable {
    let id: String
    let title: String
    let size: ArticleStackSize
    let novaTricks: NovaTricks?
    let modifiedDate: Date
}

extension ArticleStack {
    static var mockSmall: ArticleStack {
        .init(
            id: UUID().uuidString,
            title: "Fasting Tricks",
            size: .small,
            novaTricks: .mock, 
            modifiedDate: .now
        )
    }

    static var mockLarge: ArticleStack {
        .init(
            id: UUID().uuidString,
            title: "Fasting Tricks",
            size: .large,
            novaTricks: .mock,
            modifiedDate: .now
        )
    }
}
