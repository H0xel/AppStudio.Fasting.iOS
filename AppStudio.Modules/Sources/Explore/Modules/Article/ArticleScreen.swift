//  
//  ArticleScreen.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation

struct ArticleScreen: View {
    @StateObject var viewModel: ArticleViewModel

    var body: some View {
        Text(Localization.title)
    }
}

// MARK: - Layout properties
private extension ArticleScreen {
    enum Layout {
    }
}

// MARK: - Localization
private extension ArticleScreen {
    enum Localization {
        static let title: LocalizedStringKey = "ArticleScreen"
    }
}

struct ArticleScreen_Previews: PreviewProvider {
    static var previews: some View {
        ArticleScreen(
            viewModel: ArticleViewModel(
                input: ArticleInput(),
                output: { _ in }
            )
        )
    }
}
