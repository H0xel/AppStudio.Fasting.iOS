//  
//  RateAppScreen.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 17.04.2024.
//

import SwiftUI
import AppStudioNavigation

struct RateAppScreen: View {
    @StateObject var viewModel: RateAppViewModel

    var body: some View {
        VStack(alignment: .center, spacing: .spacing) {
            // MARK: - image
            viewModel.image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: .titleImageHeight)
                .padding(.horizontal, .titleVerticalPadding)

            // MARK: - title
            Text(viewModel.title)
                .font(.poppinsBold(.headerS))
                .padding(.bottom, .titleAdditionalPadding)
                .padding(.horizontal, .titleVerticalPadding)

            // MARK: - stars
            HStack(spacing: .starImageSpacing) {
                ForEach((1...5), id: \.self) { star in
                    starImage(count: star)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: .starImageWidth, height: .starImageHeight)
                        .onTapGesture {
                            viewModel.rate(stars: star)
                        }
                }
            }

            VStack(spacing: .bottomSpacing) {
                ZStack {
                    HStack(spacing: .zero) {
                        VStack(spacing: .zero) {
                            ContentWidthTextField(text: $viewModel.comment, placeholder: viewModel.placeholder)
                            Spacer()
                        }
                        Spacer()
                    }
                    .frame(minHeight: .textfieldMinHeight)
                    .padding(.textfieldPadding)
                    .padding(.leading, .textfieldExtraLeadingPadding)
                    .background(Color.studioGrayFillProgress)
                    .continiousCornerRadius(.textfieldCornerRadius)

                }

                AccentButton(title: .string(viewModel.buttonTitle), cornerRadius: .buttonCornerRadius) {
                    viewModel.send()
                }
                .disabled(viewModel.stars == 0)
            }
            .padding(.horizontal, .bottomVerticalPadding)
        }
        .padding(.vertical, .spacing)
    }

    private func starImage(count: Int) -> Image {
        count <= viewModel.stars ? Image.rateStarFilled : Image.rateStar
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let buttonCornerRadius: CGFloat = 20
    static let textfieldPadding: CGFloat = 12
    static let textfieldExtraLeadingPadding: CGFloat = 4
    static let textfieldMinHeight: CGFloat = 96
    static let textfieldCornerRadius: CGFloat = 16
    static let bottomSpacing: CGFloat = 10
    static let bottomVerticalPadding: CGFloat = 20
    static let starImageWidth: CGFloat = 36
    static let starImageHeight: CGFloat = 33
    static let starImageSpacing: CGFloat = 8
    static let titleVerticalPadding: CGFloat = 24
    static let titleAdditionalPadding: CGFloat = 8
    static let titleImageHeight: CGFloat = 68
    static let spacing: CGFloat = 32
}

// MARK: - Localization
private extension RateAppScreen {
    enum Localization {
        static let title: LocalizedStringKey = "RateAppScreen"
    }
}

struct RateAppScreen_Previews: PreviewProvider {
    static var previews: some View {
        RateAppScreen(
            viewModel: RateAppViewModel(
                input: .calorieCounter,
                output: { _ in }
            )
        )
    }
}
