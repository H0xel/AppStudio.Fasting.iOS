//  
//  RootViewModel.swift
//  AppStudioTemplate
//
//  Created by Denis Khlopin on 19.10.2023.
//

import AppStudioNavigation
import AppStudioUI

class RootViewModel: BaseViewModel<RootOutput> {
    var router: RootRouter!

    init(input: RootInput, output: @escaping RootOutputBlock) {
        super.init(output: output)
        // initialization code here
    }

    func showPaywall() {
        router.presentPaywall()
    }
}
