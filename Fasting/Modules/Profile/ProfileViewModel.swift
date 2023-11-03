//  
//  ProfileViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.11.2023.
//

import AppStudioNavigation
import AppStudioUI
import Foundation

class ProfileViewModel: BaseViewModel<ProfileOutput> {
    var router: ProfileRouter!

    init(input: ProfileInput, output: @escaping ProfileOutputBlock) {
        super.init(output: output)
        // initialization code here
    }

    func changePlan() {}

    func presentTermsOfUse() {
        guard let url = URL(string: GlobalConstants.termsOfUse) else {
            return
        }
        router.open(url: url)
    }

    func preesentPrivacyPolicy() {
        guard let url = URL(string: GlobalConstants.privacyPolicy) else {
            return
        }
        router.open(url: url)
    }

    func contactSupport() {
        router.presentSupport()
    }
}
