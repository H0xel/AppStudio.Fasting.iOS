//  
//  ArticleViewModel.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI
import Dependencies

class ArticleViewModel: BaseViewModel<ArticleOutput> {
    var router: ArticleRouter!
    var article: Article
    @Published var isFavourite: Bool
    @Published var isSaved = false
    @Published var image: Image?
    @Dependency(\.articleImageService) private var articleImageService
    @Dependency(\.exploreService) private var exploreService
    @Dependency(\.articleService) private var articleService
    private var hideBannerTask: Task<(), any Error>?

    init(input: ArticleInput, output: @escaping ArticleOutputBlock) {
        isFavourite = input.article.isFavorite
        article = input.article
        image = input.previewImage
        super.init(output: output)
        loadImage()
    }
    
    func handle(_ event: ArticleHeaderView.Action) {
        switch event {
        case .close: 
            output(.close)
        case .bookmarkTapped:
            Task { [weak self] in
                try await self?.toggleFavorite()
            }
        }
    }

    func toggleFavorite() async throws {
        let article = try await articleService.toggleFavorite(article: article)
        await MainActor.run {
            self.article = article
            isFavourite = article.isFavorite
            isSaved = isFavourite
            hideBanner()
        }
    }

    func loadImage() {
        Task {  [weak self] in
            guard let self else { return }
            // TODO: добавить подгрузку изображения
            let image = try await articleImageService.image(for: article.imageId)

            await MainActor.run {
                self.image = Image(uiImage: image)
            }

            let uiImage = try await exploreService.loadImage(for: article)
            await MainActor.run {
                self.image = Image(uiImage: uiImage)
            }
        }
    }


    private func hideBanner() {
        hideBannerTask?.cancel()
        let task = Task { @MainActor in
            try await Task.sleep(seconds: 3)
            isSaved = false
        }
        hideBannerTask = task
    }
}
