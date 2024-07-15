//
//  SwiftUIView.swift
//  
//
//  Created by Amakhin Ivan on 03.07.2024.
//

import SwiftUI

public struct PrivacyAndTermsOnboardingView: View {
    let privacyUrl: String
    let termsUrl: String
    private var termsLocalizedString = AttributedString("Onboarding.continuingYouAgree".localized(bundle: .module))

    public init(privacyUrl: String, termsUrl: String) {
        self.privacyUrl = privacyUrl
        self.termsUrl = termsUrl
        var privacyPolicyTappableText = AttributedString("ProfileScreen.privacyPolicy".localized(bundle: .module))
        privacyPolicyTappableText.link = URL(string: privacyUrl)
        privacyPolicyTappableText.foregroundColor = Color.studioGrayText
        privacyPolicyTappableText.underlineStyle = .single
        termsLocalizedString.append(privacyPolicyTappableText)

        termsLocalizedString.append(AttributedString("Onboarding.and".localized(bundle: .module)))

        var termsAndConditionsTappableText = AttributedString("ProfileScreen.termsAndConditions"
            .localized(bundle: .module))
        termsAndConditionsTappableText.link = URL(string: termsUrl)
        termsAndConditionsTappableText.foregroundColor = Color.studioGrayText
        termsAndConditionsTappableText.underlineStyle = .single
        termsLocalizedString.append(termsAndConditionsTappableText)
    }

    public var body: some View {
        Text(termsLocalizedString)
            .foregroundStyle(Color.studioGrayText)
            .font(.poppins(.description))
            .multilineTextAlignment(.center)
    }
}

#Preview {
    PrivacyAndTermsOnboardingView(privacyUrl: "", termsUrl: "")
}
