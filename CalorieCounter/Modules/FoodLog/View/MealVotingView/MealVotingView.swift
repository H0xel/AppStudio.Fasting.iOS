//
//  MealVotingView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 17.04.2024.
//

import SwiftUI

struct MealVotingView: View {

    @StateObject var viewModel: MealVotingViewModel

    var body: some View {
        HStack(spacing: .spacing) {
            Text(viewModel.voting.buttonTitle)
                .foregroundStyle(Color.studioGreyText)
                .font(.poppins(.description))

            Spacer()

            viewModel.voting.imageThumbDown
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .imageSize, height: .imageSize)
                .onTapGesture {
                    withAnimation(.bouncy) {
                        viewModel.vote(voting: .dislike)
                    }
                }

            viewModel.voting.imageThumbUp
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .imageSize, height: .imageSize)
                .onTapGesture {
                    withAnimation(.bouncy) {
                        viewModel.vote(voting: .like)
                    }
                }
        }

        .padding(.top, .topPadding)
        .padding(.bottom, .offset)
        .padding(.horizontal, .horizontalPadding)
        .background(
            ZStack {
                Color.studioGreyStrokeFill
                    .corners([.bottomLeft, .bottomRight], with: .cornerRadius)
                Color.studioGrayFillProgress
                    .corners([.bottomLeft, .bottomRight], with: .cornerRadius)
                    .padding(.bottom, .borderPadding)
                    .padding(.horizontal, .borderPadding)
            }
        )
        .offset(y: -.offset)

        .zIndex(-1)
        .transition(.asymmetric(insertion: .identity,
                                removal: .push(from: .bottom)))

    }
}

private extension CGFloat {
    static let spacing: CGFloat = 20
    static let offset: CGFloat = 16
    static let horizontalPadding: CGFloat = 16
    static let topPadding: CGFloat = 32
    static let cornerRadius: CGFloat = 20
    static let borderPadding: CGFloat = 1
    static let imageSize: CGFloat = 24
}
