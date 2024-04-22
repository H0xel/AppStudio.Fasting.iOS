//
//  ArticleStack.swift
//
//
//  Created by Denis Khlopin on 19.04.2024.
//

import Foundation

// стек статей, отображается на главном окне ввиде нескольких блоков статей,
// каждый блок содержит несколько статей и вопросы для Nova
struct ArticleStack: Codable {
    let title: String
    let size: ArticleStackSize
    let articles: [Article]
    let novaTricks: NovaTricks?
}
