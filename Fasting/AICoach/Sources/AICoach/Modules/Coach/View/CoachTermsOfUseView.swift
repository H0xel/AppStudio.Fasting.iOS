//
//  CoachTermsOfUseView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import SwiftUI
import AppStudioUI
import Dependencies

enum CoachTermsOfUseViewOutput {
    case agree
    case privacyPolicy
    case termsOfUse
}

struct CoachTermsOfUseView: View {

    @Dependency(\.styles) private var styles

    let appName: String
    let output: (CoachTermsOfUseViewOutput) -> Void

    var body: some View {
        VStack(spacing: .zero) {
            Group {
                Text(termsText)
                    .multilineTextAlignment(.center)
                    .padding(.top, .verticalPadding)
                HStack(spacing: .horizontalSpacing) {
                    Button(action: {
                        output(.termsOfUse)
                    }, label: {
                        Text(String.termsOfUse)
                            .underline()
                    })
                    Text("&")
                    Button(action: {
                        output(.privacyPolicy)
                    }, label: {
                        Text(String.privacyPolicy)
                            .underline()
                    })
                }
                .padding(.bottom, .verticalPadding)
            }
            .font(styles.fonts.description)
            .foregroundStyle(styles.colors.coachGrayText)
            AccentButton(title: .string(.agree)) {
                output(.agree)
            }
            .padding(.bottom, .verticalPadding)
        }
        .padding(.horizontal, .horizontalPadding)
        .background(.white)
        .corners([.topLeft, .topRight], with: .cornerRadius)
        .modifier(TopBorderModifier(color: styles.colors.coachGreyStrokeFill))
        .background(styles.colors.coachGrayFillProgress)
    }

    private var termsText: String {
        let text = "CoachTermsOfUseView.termsOfUseText".localized(bundle: .coachBundle)
        return String(format: text, appName)
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 24
    static let verticalPadding: CGFloat = 16
    static let horizontalSpacing: CGFloat = 4
    static let cornerRadius: CGFloat = 20
}

private extension String {
    static let termsOfUse = "CoachTermsOfUseView.termsOfUse".localized(bundle: .coachBundle)
    static let privacyPolicy = "CoachTermsOfUseView.privacyPolicy".localized(bundle: .coachBundle)
    static let agree = "CoachTermsOfUseView.agree".localized(bundle: .coachBundle)
}

#Preview {
    ZStack {
        Color.red
        CoachTermsOfUseView(appName: "Fasting") { _ in }
    }
}
