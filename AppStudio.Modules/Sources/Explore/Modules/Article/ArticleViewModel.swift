//  
//  ArticleViewModel.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import AppStudioNavigation
import AppStudioUI

class ArticleViewModel: BaseViewModel<ArticleOutput> {
    var router: ArticleRouter!

    init(input: ArticleInput, output: @escaping ArticleOutputBlock) {
        super.init(output: output)
        // initialization code here
    }
}
