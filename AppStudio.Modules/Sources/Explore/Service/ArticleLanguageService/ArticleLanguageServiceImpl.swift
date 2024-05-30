//  
//  ArticleLanguageServiceImpl.swift
//  
//
//  Created by Denis Khlopin on 30.04.2024.
//
import Foundation

class ArticleLanguageServiceImpl: ArticleLanguageService {
    var folder: String {
        folderByCurrentLanguage()
    }
}

extension ArticleLanguageServiceImpl {
    // все доступные языковые папки для статей на сервере, должны совпадать с языками локали,
    // например для en_US - это en, для ru_RU - ru и т.п.
    private var availableFolders: [String] {
        ["en", "es"]
    }

    // языки, связанные напрямую с папками при необходимости,
    // например если хотим связать русскую локаль с испанскими статьями, то добавляем запись "ru_RU": "es"
    private var matchingFoldersByIdentifiers: [String: String] {
        [
            "en_US": "en"
        ]
    }

    private func folderByCurrentLanguage() -> String {
        let defaultLanguageFolder = "en"
        let identifier = Locale.current.identifier
        if let matchingFolder = matchingFoldersByIdentifiers[identifier] {
            return matchingFolder
        }
        let language = String(identifier.split(separator: "_").first ?? "")
        if let availableFolder = availableFolders.first(where: { $0 == language.lowercased() }) {
            return availableFolder
        }
        return defaultLanguageFolder
    }
}
