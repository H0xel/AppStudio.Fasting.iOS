//  
//  FavouriteArticlesViewModel.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import AppStudioNavigation
import AppStudioUI

class FavouriteArticlesViewModel: BaseViewModel<FavouriteArticlesOutput> {
    var router: FavouriteArticlesRouter!

    init(input: FavouriteArticlesInput, output: @escaping FavouriteArticlesOutputBlock) {
        super.init(output: output)
        // initialization code here
    }
}
