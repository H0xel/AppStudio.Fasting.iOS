//  
//  ExploreServiceImpl.swift
//  
//
//  Created by Denis Khlopin on 23.04.2024.
//
import Dependencies
import Foundation
import UIKit
import MunicornFoundation

class ExploreServiceImpl: ExploreService {
    @Dependency(\.exploreApi) private var exploreApi
    @Dependency(\.articleStackService) private var articleStackService
    @Dependency(\.articleService) private var articleService
    @Dependency(\.articleImageService) private var articleImageService
    @Dependency(\.imageDataService) private var imageDataService
    @Dependency(\.articleLanguageService) private var articleLanguageService
    private var contentFiles: [ArticleContent] = []

    func loadArticles() async throws {
//        try await articleStackService.deleteAll()
//        try await articleService.deleteAll()
        let files = try await exploreApi.list()

        // 1. Фильтруем файлы, относящиеся только к стекам и статьям, группируем их по стекам
        let stackFiles = parseStacksAndArticlesFilesFrom(files: files)

        // 3. Проверка на дату обновления и необходимость загрузки статей повторно
        let filtredResult = try await syncPreviusSavedArticlesWith(stackFiles: stackFiles)

        // 3.1 Удаление ненужных стеков и статей
        try await deleteStacks(ids: filtredResult.needToDeleteStackIds)
        try await deleteArticles(ids: filtredResult.needToDeleteArticleIds)

        // 4. Загрузка стеков и сохранение их в БД
        try await saveArticleStacks(from: filtredResult.needToUpdate)

        // 4. Загрузка статей и сохранение их в БД
        try await saveArticles(from: filtredResult.needToUpdate)
    }

    private func deleteStacks(ids: [String]) async throws {
        try await articleStackService.delete(ids: ids)
    }

    private func deleteArticles(ids: [String]) async throws {
        try await articleService.delete(ids: ids)
    }

    func loadImage(for article: Article) async throws -> UIImage {
        let imageFileData = try await exploreApi.download(exploreFileName: article.imageURL)
        guard let uiImage = UIImage(data: imageFileData) else {
            throw ExploreServiceError.wrongFileData
        }
        return uiImage
    }
}

// MARK: - private functions
extension ExploreServiceImpl {
    private func syncPreviusSavedArticlesWith(stackFiles: [ArticleStackFiles]) async throws -> ArticleStacksFiltredResult {
        var needToUpdate = [ArticleStackFiles]()
        var needToDeleteStackIds = [String]()
        var needToDeleteArticleIds = [String]()

        var alreadyStacks = try await articleStackService.stacks()
        // проверяем стеки на удаленные, если в сохраненных есть ИДшники, которых нет в новых,
        // то записываем такие ИД в список на удаление стеков
        for stack in alreadyStacks {
            if nil == stackFiles.first(where: { $0.id == stack.id })  {
                needToDeleteStackIds.append(stack.id)
            }
        }
        // заведомо удаляем их из массива
        alreadyStacks.removeAll { needToDeleteStackIds.contains($0.id) }

        // проверяем стеки на обновление данных
        for stackFile in stackFiles {
            var stackFile = stackFile
            guard let lastUpdateStackDate = stackFile.updatedAt else {
                continue
            }
            // если в сохраненных стеках нет загружаемого, добавляем и переходим к следующему стеку
            guard let stack = alreadyStacks.first(where: { $0.id == stackFile.id}) else {
                needToUpdate.append(stackFile)
                continue
            }
            // если стек уже был ранее загружен, проверим дату изменения данных стека, если она новее сохраненной,
            // то перегружаем целый стек со статьями
            if stack.modifiedDate < lastUpdateStackDate {
                needToUpdate.append(stackFile)
                continue
            }
            // получим все статьи для стека
            let alreadyArticles = try await articleService.articles(stackId: stack.id)
            let articleFiles = Array(stackFile.articleFiles.values)
            // пробежимся по статьям и проверим на удаленные
            for article in alreadyArticles {
                if nil == articleFiles.first(where: { $0.id == article.id })  {
                    needToDeleteArticleIds.append(article.id)
                }
            }
            var updateArticleFiles: [String: ArticleFiles] = [:]
            stackFile.articleFiles = [:]

            for articleFile in articleFiles {
                guard let lastUpdateArticleDate = articleFile.updatedAt else {
                    continue
                }

                // если в сохраненных статьях нет загружаемого, добавляем и переходим к следующей статье
                guard let article = alreadyArticles.first(where: { $0.id == articleFile.id}) else {
                    updateArticleFiles[articleFile.id] = articleFile
                    continue
                }
                // если контент не был загружен
                if article.content.isEmpty || article.imageURL.isEmpty {
                    updateArticleFiles[articleFile.id] = articleFile
                    continue
                }
                // проверяем дату модификации
                if article.modifiedDate < lastUpdateArticleDate {
                    updateArticleFiles[articleFile.id] = articleFile
                }
            }

            // обновляем стек и все статьи, которые были изменены
            if !updateArticleFiles.isEmpty {
                stackFile.articleFiles = updateArticleFiles
                needToUpdate.append(stackFile)
            }
        }
        return ArticleStacksFiltredResult(needToUpdate: needToUpdate,
                                          needToDeleteStackIds: needToDeleteStackIds,
                                          needToDeleteArticleIds: needToDeleteArticleIds)
    }

    private func saveArticleStacks(from stackFiles: [ArticleStackFiles]) async throws {
        for stackFile in stackFiles {
            do {
                let stack = try await loadArticleStackInfo(from: stackFile)
                _ = try await articleStackService.save(stack)
            } catch {
                continue
            }
            await Task.yield()
        }
    }

    private func saveArticles(from stackFiles: [ArticleStackFiles]) async throws {
        for stackFile in stackFiles {
            let stackId = stackFile.id
            for articleFile in stackFile.articleFiles.values {
                do {
                    let article = try await loadArticleInfo(from: articleFile, stackId: stackId)
                    _ = try await articleService.reload(article)
                } catch {
                    continue
                }
                await Task.yield()
            }
        }
        Task {
            try await loadArticleContentAndImage()
        }
    }

    private func loadArticleStackInfo(from stackFiles: ArticleStackFiles) async throws -> ArticleStack {
        guard let infoFileName = stackFiles.infoFile else {
            throw ExploreServiceError.fileNotFound
        }
        async let infoData = try await exploreApi.download(exploreFileName: infoFileName)
        let articleStackApi = try await ArticleStackApi(jsonData: infoData)

        return ArticleStack(id: stackFiles.id,
                            title: articleStackApi.title,
                            size: articleStackApi.size,
                            novaTricks: articleStackApi.novaTricks,
                            modifiedDate: .now)
    }

    private func prepareContentAndImageFilesForLoading(articleId: String, contentFile: String, imageFile: String) {
        contentFiles.append(ArticleContent(articleId: articleId, contentFile: contentFile, imageFile: imageFile))
    }

    private func loadArticleContentAndImage() async throws {
        while !contentFiles.isEmpty {
            let articleContent = contentFiles.removeFirst()
            async let markdownData = exploreApi.download(exploreFileName: articleContent.contentFile)
            async let pngData = exploreApi.download(exploreFileName: articleContent.imageFile)
            let data = try await (image: pngData, markdown: markdownData)

            guard let thumbImage = thumbnail(pngData: data.image) else {
                continue
            }
            guard let markdown = String(data: data.markdown, encoding: .utf8) else {
                continue
            }
            guard var article = try await articleService.article(id: articleContent.articleId) else {
                continue
            }
            article.imageURL = articleContent.imageFile
            article.content = markdown

            let imageId = article.imageId
            _ = try await articleImageService.save(image: thumbImage, for: imageId)

            _ = try await articleService.save(article)
        }
    }

    private func loadArticleInfo(from articleFiles: ArticleFiles, stackId: String) async throws -> Article {
        guard let jsonFile = articleFiles.jsonFile,
              let pngFile = articleFiles.pngFile,
              let markdownFile = articleFiles.markdownFile else {
            throw ExploreServiceError.fileNotFound
        }
        prepareContentAndImageFilesForLoading(articleId: articleFiles.id, contentFile: markdownFile, imageFile: pngFile)
        let jsonData = try await  exploreApi.download(exploreFileName: jsonFile)

        let articleApi = try ArticleApi(jsonData: jsonData)

        return Article(id: articleFiles.id,
                       stackId: stackId,
                       free: articleApi.free,
                       title: articleApi.title,
                       type: articleApi.type,
                       cookTime: articleApi.cookTime,
                       readTime: articleApi.readTime,
                       nutritionProfile: articleApi.nutritionProfile,
                       modifiedDate: .now,
                       imageURL: "",
                       content: "",
                       isFavorite: false)
    }


    /// Get filtered list of all files from Storage Server with stack and article info!
    /// - Parameter files: List of all files from server
    /// - Returns: Filtered list of stack files(info.json) and article files(.png, json, .markdown)
    private func parseStacksAndArticlesFilesFrom(files: [ExploreFile]) -> [ArticleStackFiles] {
        var stackFiles: [String: ArticleStackFiles] = [:]

        for file in files {
            let fileName = file.name
            guard let fileDate: Date = file.date.date(format: "yyyy-MM-dd'T'hh:mm:ssXXX") else {
                continue
            }
            var folders = fileName.split(separator: "/")
            if folders.isEmpty {
                continue
            }

            let languageFolder = folders.removeFirst()
            if languageFolder != articleLanguageService.folder {
                continue
            }

            if folders.count < 2 {
                continue
            }
            let stack = String(folders[0])

            var stackFile = stackFiles[stack] ?? ArticleStackFiles(id: stack, stackName: stack, articleFiles: [:])

            let secondValue = String(folders[1])
            if folders.count == 2, secondValue == "info.json" {
                stackFile.infoFile = fileName
                stackFile.updatedAt = fileDate
            }
            
            if folders.count == 3 {
                let article = secondValue
                let thirdValue = String(folders[2])
                let fileParts = thirdValue.split(separator: ".").map { String($0) }
                var articleFile = stackFile.articleFiles[article] ?? ArticleFiles(id: "\(stackFile.id)/\(article)" ,articleName: article)
                if let ext = fileParts.last {
                    switch ext {
                    case "png":
                        articleFile.pngFile = fileName
                    case "json":
                        articleFile.jsonFile = fileName
                    case "markdown":
                        articleFile.markdownFile = fileName
                    default:
                        continue
                    }
                }

                let lastUpdatedDate: Date = articleFile.updatedAt ?? fileDate
                articleFile.updatedAt = max(lastUpdatedDate, fileDate)
                stackFile.articleFiles[article] = articleFile
            }
            stackFiles[stack] = stackFile
        }
        stackFiles = stackFiles.filter { $0.value.isValid }
        let orderedFiles = stackFiles.values.sorted { $0.stackName < $1.stackName }

        return orderedFiles
    }

    private func thumbnail(pngData: Data) -> UIImage? {
        let options = [
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceThumbnailMaxPixelSize: 300] as CFDictionary

        guard let imageSource = CGImageSourceCreateWithData(pngData as NSData, nil),
              let image = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options)
        else {
            return nil
        }

        return UIImage(cgImage: image)
    }
}
