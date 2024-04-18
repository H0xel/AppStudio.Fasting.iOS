//  
//  RateAppViewModel.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 17.04.2024.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI

class RateAppViewModel: BaseViewModel<RateAppOutput> {
    var router: RateAppRouter!

    private(set) var title: String
    private(set) var placeholder: String
    private(set) var buttonTitle: String
    private(set) var image: Image

    @Published var comment: String = ""
    @Published var stars: Int = 0

    init(input: RateAppInput, output: @escaping RateAppOutputBlock) {
        image = input.image
        title = input.title
        placeholder = input.placeholder
        buttonTitle = input.buttonTitle
        super.init(output: output)
        // initialization code here
    }

    func rate(stars: Int) {
        self.stars = stars
    }

    func send() {
        router.dismiss()
        output(.rate(stars: stars, comment: comment))
    }
}
