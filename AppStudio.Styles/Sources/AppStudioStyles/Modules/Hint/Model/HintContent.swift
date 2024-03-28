//
//  HintContent.swift
//  
//
//  Created by Руслан Сафаргалеев on 20.03.2024.
//

import Foundation

public enum HintContent: Hashable {
    case question(QuestionContent)
    case contentWidthBadge(ContentWidthBadge)
    case novaQuestion(NovaQustionsContent)
    case paragraph(ParagraphContent)
    case coloredDotes(ColoredDotsContent)
}
