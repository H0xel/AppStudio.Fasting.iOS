//  
//  FastingViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import Foundation
import NotificationCenter
import SwiftUI

class FastingViewModel: BaseViewModel<FastingOutput> {
    var router: FastingRouter!

    init(input: FastingInput, output: @escaping FastingOutputBlock) {
        super.init(output: output)
        // initialization code here
    }

    func startFasting() {
        router.presentStartFastingDialog()
    }
}
