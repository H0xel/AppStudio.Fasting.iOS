//  
//  ExploreService.swift
//  
//
//  Created by Denis Khlopin on 23.04.2024.
//
import UIKit

protocol ExploreService {
    func loadArticles() async throws
    func loadImage(for article: Article) async throws -> UIImage
}
