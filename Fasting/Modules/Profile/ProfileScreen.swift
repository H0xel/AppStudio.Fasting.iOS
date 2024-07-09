//  
//  ProfileScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.11.2023.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI
import AppStudioStyles

struct ProfileScreen: View {
    @StateObject var viewModel: ProfileViewModel

    var body: some View {
        ScrollView {
            Spacer(minLength: .spacing)
            VStack(spacing: .spacing) {
                SetupFastingBanner(plan: viewModel.plan) {
                    viewModel.changePlan()
                }

                ProfileButtonView(
                    input: .notifications,
                    action: viewModel.openNotifications
                )
                .continiousCornerRadius(.cornerRadius)

                VStack(spacing: .zero) {
                    ProfileButtonView(input: .sex(sex: viewModel.sex),
                                      action: viewModel.changeSex)
                    Divider()
                    ProfileButtonView(input: .birthday(birthday: viewModel.birthday),
                                      action: viewModel.changeBirthday)
                    Divider()
                    ProfileButtonView(input: .height(height: viewModel.height),
                                      action: viewModel.changeHeight)
                }
                .continiousCornerRadius(.cornerRadius)

                ProfileButtonView(input: .support,
                                  action: viewModel.contactSupport)
                .continiousCornerRadius(.cornerRadius)

                VStack(spacing: .zero) {
                    ProfileButtonView(input: .termsOfUse,
                                      action: viewModel.presentTermsOfUse)
                    Divider()
                    ProfileButtonView(input: .privacyPolicy,
                                      action: viewModel.preesentPrivacyPolicy)
                }
                .continiousCornerRadius(.cornerRadius)

                VStack(spacing: .zero) {
                    if let userEmail = viewModel.userEmail {
                        ProfileLoginedView(title: userEmail)
                    } else {
                        ProfileButtonView(input: .signInByEmail,
                                          action: viewModel.pushW2WLoginScreen)
                    }
                }
                .background()
                .continiousCornerRadius(.cornerRadius)
            }
            .padding(.horizontal, .horizontalPadding)
            Spacer(minLength: .spacing)
        }
        .scrollIndicators(.hidden)
        .background(Color.studioGreyFillProgress)
        .navBarButton(placement: .principal,
                      isVisible: true,
                      content: Text(Localization.navigationTitle)
                                    .font(.poppins(.buttonText))
                                    .foregroundStyle(Color.studioBlackLight),
                      action: {})
        .navigationBarTitleDisplayMode(.inline)
        .navBarButton(content: closeButton,
                      action: viewModel.close)
    }

    private var closeButton: some View {
        Image.close
            .foregroundStyle(Color.studioBlackLight)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 16
    static let horizontalPadding: CGFloat = 20
    static let cornerRadius: CGFloat = 20
}

// MARK: - Localization
private extension ProfileScreen {
    enum Localization {
        static let navigationTitle = NSLocalizedString("ProfileScreen.navigationTitle", comment: "Profile")
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ModernNavigationView {
            ProfileScreen(
                viewModel: ProfileViewModel(
                    input: ProfileInput(),
                    output: { _ in }
                )
            )
        }
    }
}
