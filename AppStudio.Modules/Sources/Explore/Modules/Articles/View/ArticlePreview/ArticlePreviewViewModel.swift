//
//  ArticlePreviewViewModel.swift
//
//
//  Created by Руслан Сафаргалеев on 23.04.2024.
//

import SwiftUI
import AppStudioUI
import Dependencies
import MunicornFoundation

class ArticlePreviewViewModel: BaseViewModel<Void> {

    @Dependency(\.articleImageService) private var articleImageService

    let article: Article
    @Published var image: Image?

    init(article: Article) {
        self.article = article
        super.init()
        loadImage()
    }

    func loadImage() {
        Task {  [weak self] in
            guard let self else { return }
            let image = try await articleImageService.image(for: article.imageId)

            await MainActor.run {
                self.image = Image(uiImage: image)
            }
        }
    }

    func clearImage() {}
}
