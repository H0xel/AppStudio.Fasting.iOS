//  
//  ArticlesScreen.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import SwiftUI
import AppStudioNavigation

struct ArticlesScreen: View {
    @StateObject var viewModel: ArticlesViewModel

    var body: some View {
        Text(Localization.title)
    }
}

// MARK: - Layout properties
private extension ArticlesScreen {
    enum Layout {
    }
}

// MARK: - Localization
private extension ArticlesScreen {
    enum Localization {
        static let title: LocalizedStringKey = "ArticlesScreen"
    }
}

struct ArticlesScreen_Previews: PreviewProvider {
    static var previews: some View {
        ArticlesScreen(
            viewModel: ArticlesViewModel(
                input: ArticlesInput(),
                output: { _ in }
            )
        )
    }
}
