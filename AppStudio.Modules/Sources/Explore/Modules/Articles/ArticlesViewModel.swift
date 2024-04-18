//  
//  ArticlesViewModel.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import AppStudioNavigation
import AppStudioUI

class ArticlesViewModel: BaseViewModel<ArticlesOutput> {
    var router: ArticlesRouter!

    init(input: ArticlesInput, output: @escaping ArticlesOutputBlock) {
        super.init(output: output)
        // initialization code here
    }
}
