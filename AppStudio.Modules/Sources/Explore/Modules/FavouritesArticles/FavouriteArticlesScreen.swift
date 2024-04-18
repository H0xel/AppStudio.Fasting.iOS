//  
//  FavouriteArticlesScreen.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation

struct FavouriteArticlesScreen: View {
    @StateObject var viewModel: FavouriteArticlesViewModel

    var body: some View {
        Text(Localization.title)
    }
}

// MARK: - Layout properties
private extension FavouriteArticlesScreen {
    enum Layout {
    }
}

// MARK: - Localization
private extension FavouriteArticlesScreen {
    enum Localization {
        static let title: LocalizedStringKey = "FavouriteArticlesScreen"
    }
}

struct FavouriteArticlesScreen_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteArticlesScreen(
            viewModel: FavouriteArticlesViewModel(
                input: FavouriteArticlesInput(),
                output: { _ in }
            )
        )
    }
}
