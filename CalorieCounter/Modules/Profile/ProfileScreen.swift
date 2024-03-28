//  
//  ProfileScreen.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 17.01.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioUI

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
                    ProfileButtonView(title: Localization.changeGoal,
                                      roundedCorners: [.bottomLeft, .bottomRight],
                                      action: viewModel.changeGoal)
                }

                VStack(spacing: .zero) {
                    ProfileButtonView(title: Localization.sex,
                                      description: viewModel.sex.title,
                                      image: .init(viewModel.sex == .male ? .sexMale : .sexFemale),
                                      roundedCorners: [.topLeft, .topRight],
                                      action: viewModel.changeSex)
                    Divider()
                    ProfileButtonView(title: Localization.birthday,
                                      description: viewModel.birthday,
                                      image: .init(.birthday),
                                      roundedCorners: [],
                                      action: viewModel.changeBirthday)
                    Divider()
                    ProfileButtonView(title: Localization.height,
                                      description: viewModel.height,
                                      image: .init(.height),
                                      roundedCorners: [.bottomLeft, .bottomRight],
                                      action: viewModel.changeHeight)
                }

                ProfileButtonView(title: Localization.support,
                                  image: .heart,
                                  roundedCorners: .allCorners,
                                  action: viewModel.contactSupport)

                VStack(spacing: .zero) {
                    ProfileButtonView(title: Localization.termsOfUse,
                                      image: nil,
                                      roundedCorners: [.topLeft, .topRight],
                                      action: viewModel.presentTermsOfUse)
                    Divider()
                    ProfileButtonView(title: Localization.privacyPolicy,
                                      image: nil,
                                      roundedCorners: [.bottomLeft, .bottomRight],
                                      action: viewModel.preesentPrivacyPolicy)
                }
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
}

// MARK: - Localization
private extension ProfileScreen {
    enum Localization {
        static let navBarTitle: LocalizedStringKey = "ProfileScreen.navTitle"
        static let support: LocalizedStringKey = "ProfileScreen.support"
        static let termsOfUse: LocalizedStringKey = "ProfileScreen.termsOfUse"
        static let privacyPolicy: LocalizedStringKey = "ProfileScreen.privacyPolicy"
        static let sex: LocalizedStringKey = "ProfileScreen.sex"
        static let birthday: LocalizedStringKey = "ProfileScreen.birthday"
        static let height: LocalizedStringKey = "ProfileScreen.height"
        static let changeGoal: LocalizedStringKey = "ProfileScreen.changeGoal"
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
