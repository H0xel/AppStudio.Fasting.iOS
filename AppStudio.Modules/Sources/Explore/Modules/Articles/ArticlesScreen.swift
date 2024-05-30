//  
//  ArticlesScreen.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

struct ArticlesScreen: View {
    @StateObject var viewModel: ArticlesViewModel

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: .zero) {
                ForEach(viewModel.stacks, id: \.self) { stack in
                    ArticlesStackView(
                        viewModel: .init(
                            stack: stack,
                            output: viewModel.handle
                        )
                    )
                }
            }
            Spacer(minLength: .bottomSpacing)
        }
        .navigationBarTitleDisplayMode(.inline)
        .scrollIndicators(.hidden)
        .background(Color.studioGrayFillProgress)
        .onAppear {
            viewModel.loadStacks()
        }
        .navBarButton(placement: .principal,
                      content: navigationTitle,
                      action: {})
        .navBarButton(placement: .topBarTrailing,
                      content: favoritesButton,
                      action: viewModel.presentFavorites)
    }

    private var navigationTitle: some View {
        Text(String.explore)
            .font(.poppins(.buttonText))
            .foregroundStyle(Color.studioBlackLight)
    }

    private var favoritesButton: some View {
        Image(.bookmarks)
            .foregroundStyle(Color.studioBlackLight)
    }
}

private extension CGFloat {
    static let bottomSpacing: CGFloat = 32
}

private extension String {
    static let explore = "ArticlesScreen.explore".localized(bundle: .module)
}

struct ArticlesScreen_Previews: PreviewProvider {
    static var previews: some View {
        ModernNavigationView {
            ArticlesScreen(
                viewModel: ArticlesViewModel(
                    input: ArticlesInput(),
                    output: { _ in }
                )
            )
        }
    }
}
