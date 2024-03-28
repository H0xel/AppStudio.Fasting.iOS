//  
//  HintViewModel.swift
//  
//
//  Created by Denis Khlopin on 07.03.2024.
//

import AppStudioNavigation
import AppStudioUI

class HintViewModel: BaseViewModel<HintOutput> {
    var router: HintRouter!
    var topic: HintTopic

    init(input: HintInput, output: @escaping HintOutputBlock) {
        self.topic = input.topic
        super.init(output: output)
    }

    func onTap(novaQuestion: String) {
        output(.novaQuestion(novaQuestion))
    }
}
