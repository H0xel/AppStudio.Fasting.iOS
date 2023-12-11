//
//  Article.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 04.12.2023.
//

import Foundation

struct Article {
    let paragraphs: [Paragraph]
}

struct Paragraph: Hashable {
    let text: String
    let paragraphs: [Paragraph]
}

extension Article {

    static var sugarRises: Article {
        let paragraphs = (1...7).map {
            Paragraph(text: NSLocalizedString("FastingPhaseArticle.sugarRises.point\($0)", comment: ""),
                      paragraphs: [])
        }
        return fastingStageArticle(stage: .sugarRises, paragraphs: paragraphs)
    }

    static var sugarDrop: Article {
        let paragraphs = (1...3).map {
            Paragraph(text: NSLocalizedString("FastingPhaseArticle.sugarDrop.point\($0)", comment: ""),
                      paragraphs: [])
        }
        return fastingStageArticle(stage: .sugarDrop, paragraphs: paragraphs)
    }

    static var sugarNormal: Article {
        let paragraphs = (1...4).map {
            Paragraph(text: NSLocalizedString("FastingPhaseArticle.sugarNormal.point\($0)", comment: ""),
                      paragraphs: [])
        }
        return fastingStageArticle(stage: .sugarNormal, paragraphs: paragraphs)
    }

    static var burning: Article {
        let subParagraphs = (1...5).map {
            Paragraph(text: NSLocalizedString("FastingPhaseArticle.burning.point1.point\($0)", comment: ""),
                      paragraphs: [])
        }
        let paragraph1 = Paragraph(text: NSLocalizedString("FastingPhaseArticle.burning.point1", comment: ""),
                                   paragraphs: subParagraphs)
        let paragraph2 = Paragraph(text: NSLocalizedString("FastingPhaseArticle.burning.point2", comment: ""),
                                   paragraphs: [])
        return fastingStageArticle(stage: .burning, paragraphs: [paragraph1, paragraph2])
    }

    static var ketosis: Article {
        let paragraphs = (1...5).map {
            Paragraph(text: NSLocalizedString("FastingPhaseArticle.ketosis.point\($0)", comment: ""),
                      paragraphs: [])
        }
        return fastingStageArticle(stage: .ketosis, paragraphs: paragraphs)
    }

    static var autophagy: Article {
        let paragraphs = (1...5).map {
            Paragraph(text: NSLocalizedString("FastingPhaseArticle.autophagy.point\($0)", comment: ""),
                      paragraphs: [])
        }
        return fastingStageArticle(stage: .autophagy, paragraphs: paragraphs)
    }

    static func fastingStageArticle(stage: FastingStage, paragraphs: [Paragraph]) -> Article {
        let paragraph = Paragraph(
            text: NSLocalizedString("FastingPhaseArticle.\(stage.rawValue).paragraph", comment: ""),
            paragraphs: paragraphs
        )
        return .init(paragraphs: [paragraph])
    }
}
