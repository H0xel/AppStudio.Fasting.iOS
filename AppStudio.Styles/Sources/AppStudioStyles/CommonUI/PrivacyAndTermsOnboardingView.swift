//
//  SwiftUIView.swift
//  
//
//  Created by Amakhin Ivan on 03.07.2024.
//

import SwiftUI

public struct PrivacyAndTermsOnboardingView: View {
    let action: (Action) -> Void

    public init(action: @escaping (Action) -> Void) {
        self.action = action
    }

    public var body: some View {
        VStack(spacing: .spacing) {
            HStack(alignment: .bottom, spacing: .textSpacing) {
                Text("Onboarding.continuingYouAgree".localized(bundle: .module))
                Button {
                    action(.privacyTapped)
                } label: {
                    Text("ProfileScreen.privacyPolicy".localized(bundle: .module))
                        .underline()
                }
            }

            HStack(alignment: .bottom, spacing: .textSpacing) {
                Text("Onboarding.and".localized(bundle: .module))
                Button {
                    action(.termsTapped)
                } label: {
                    Text("ProfileScreen.termsAndConditions".localized(bundle: .module))
                        .underline()
                }
            }
        }
        .foregroundStyle(Color.studioGrayText)
        .font(.poppins(.description))
        .multilineTextAlignment(.center)
    }
}

public extension PrivacyAndTermsOnboardingView {
    enum Action {
        case privacyTapped
        case termsTapped
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
    static let textSpacing: CGFloat = 2
}

#Preview {
    PrivacyAndTermsOnboardingView() { _ in }
}
