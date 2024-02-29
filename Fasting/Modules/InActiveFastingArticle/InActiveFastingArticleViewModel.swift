//  
//  InActiveFastingArticleViewModel.swift
//  Fasting
//
//  Created by Amakhin Ivan on 04.12.2023.
//

import AppStudioNavigation
import AppStudioUI

class InActiveFastingArticleViewModel: BaseViewModel<InActiveFastingArticleOutput> {
    let fastingInActiveStage: FastingInActiveArticle
    var router: InActiveFastingArticleRouter!

    init(input: InActiveFastingArticleInput, output: @escaping InActiveFastingArticleOutputBlock) {
        fastingInActiveStage = input.fastingInActiveStage
        super.init(output: output)
    }

    func closeTapped() {
        router.dismiss()
    }
}
