//  
//  ProfileScreen.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.01.2024.
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
                VStack(spacing: .zero) {
                    ProfileTargetWeightView(targetWeight: viewModel.targetWeight,
                                            calorieGoal: viewModel.caloriesGoal,
                                            goal: viewModel.goal,
                                            weeklyWeightChange: viewModel.weeklyWeightChange) {
                        viewModel.trackPresentPlanDetails()
                        viewModel.presentInfo()
                    }
                    Divider()
                    ProfileButtonView(input: .changeGoal,
                                      action: viewModel.changeGoal)
                }
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
            }
            Spacer(minLength: .bottomSpacing)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, .horizontalPadding)
        .background(Color.studioGreyFillProgress)
        .navigationBarTitleDisplayMode(.inline)
        .navBarButton(placement: .principal,
                      content: Text(Localization.navBarTitle).font(.poppins(.buttonText)),
                      action: {})
    }

    private var closeButton: some View {
        Image.close
            .foregroundStyle(Color.studioBlackLight)
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let spacing: CGFloat = 16
    static let bottomSpacing: CGFloat = 32
    static let cornerRadius: CGFloat = 20
}

// MARK: - Localization
private extension ProfileScreen {
    enum Localization {
        static let navBarTitle: LocalizedStringKey = "ProfileScreen.navTitle"
    }
}

extension ProfileButtonInput {
    static var changeGoal: ProfileButtonInput {
        .init(title: "ProfileScreen.changeGoal".localized(),
              description: nil,
              image: nil)
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
