//  
//  ArticleInput.swift
//  
//
//  Created by Amakhin Ivan on 18.04.2024.
//
import SwiftUI

struct ArticleInput {
    // add Input parameters here
    let article: Article
    let previewImage: Image?

    init(article: Article, previewImage: Image?) {
        self.article = article
        self.previewImage = previewImage
    }
}
