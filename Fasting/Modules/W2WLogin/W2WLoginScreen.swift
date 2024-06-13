//  
//  W2WLoginScreen.swift
//  Fasting
//
//  Created by Amakhin Ivan on 06.06.2024.
//

import SwiftUI
import AppStudioNavigation

struct W2WLoginScreen: View {
    @StateObject var viewModel: W2WLoginViewModel

    var body: some View {
        VStack(spacing: .zero) {
            Image(.w2WLogin)
                .padding(.bottom, .imageBottomPadding)

            Text("W2W.sign.title")
                .font(.poppins(.headerM))
                .padding(.bottom, .titleBottomPadding)

            Text("W2W.sign.description")
                .font(.poppins(.body))
                .foregroundStyle(Color.studioGreyText)
                .padding(.bottom, .descriptionBottomPadding)
                .multilineTextAlignment(.center)

            TextField("", text: $viewModel.emailText)
                .font(.poppins(.body))
                .padding(.horizontal, .textFieldHorizontalPadding)
                .padding(.vertical, .textFieldVerticalPadding)
                .background(Color.studioGreyFillProgress)
                .continiousCornerRadius(.textFieldCornerRadius)
                .overlay {
                    if viewModel.emailText.isEmpty {
                        Text("W2W.onboarding.placeholderEmail")
                            .tint(Color.studioGreyPlaceholder)
                            .aligned(.left)
                            .padding(.leading, .placeholderLeadingPadding)
                            .allowsHitTesting(false)
                    }
                }

            if let error = viewModel.errorState {
                Text(error.title)
                    .font(.poppins(.description))
                    .foregroundStyle(Color.studioRed)
                    .padding(.top, .errorTopPadding)
                    .aligned(.left)
            }

            Spacer()

            Button(
                action: {
                    viewModel.signInTapped()
                },
                label: {
                    Text("W2W.onboarding.signIn")
                        .accentButtonStyle(isEnabled: viewModel.isButtonEnabled)
                }
            )
            .padding(.bottom, .bottomPadding)
        }
        .padding(.horizontal, .horizontalPadding)
        .navBarButton(content: Image.chevronLeft) {
            viewModel.backButtonTapped()
        }
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let imageBottomPadding: CGFloat = 44
    static let titleBottomPadding: CGFloat = 16
    static let descriptionBottomPadding: CGFloat = 40
    static let textFieldHorizontalPadding: CGFloat = 22
    static let textFieldVerticalPadding: CGFloat = 16
    static let textFieldCornerRadius: CGFloat = 20
    static let errorTopPadding: CGFloat = 8
    static let bottomPadding: CGFloat = 8
    static let horizontalPadding: CGFloat = 32
    static let placeholderLeadingPadding: CGFloat = 23
}

// MARK: - Localization
private extension W2WLoginScreen {
    enum Localization {
        static let title: LocalizedStringKey = "W2WLoginScreen"
    }
}

struct W2WLoginScreen_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            W2WLoginScreen(
                viewModel: W2WLoginViewModel(
                    input: .init(context: .onboarding),
                    output: { _ in }
                )
            )
        }
    }
}


extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder()
            self
        }
    }
}
