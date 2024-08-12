//  
//  BottomActionSheetViewModel.swift
//  
//
//  Created by Amakhin Ivan on 10.07.2024.
//

import AppStudioNavigation
import AppStudioUI

class BottomActionSheetViewModel: BaseViewModel<BottomActionSheetOutput> {
    var router: BottomActionSheetRouter!
    let configuration: BottomActionSheetConfiguration

    init(input: BottomActionSheetInput, output: @escaping BottomActionSheetOutputBlock) {
        self.configuration = input.configuration
        super.init(output: output)
    }

    func leftButtonTapped() {
        output(.leftButtonTapped)
    }

    func rightButtonTapped() {
        output(.rightButtonTapped)
    }
}
