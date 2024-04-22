//
//  File.swift
//  
//
//  Created by Denis Khlopin on 19.04.2024.
//

import Foundation

struct ArticleStackApi: Codable {
    let title: String
    let size: ArticleStackSize
    let novaTricks: NovaTricks?
}
