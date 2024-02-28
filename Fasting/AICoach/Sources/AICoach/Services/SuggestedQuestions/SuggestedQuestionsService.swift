//
//  File.swift
//  
//
//  Created by Denis Khlopin on 19.02.2024.
//

import Foundation

protocol SuggestedQuestionsService {
    var keywords: Set<String> { get }
    var allQuestions: Set<String> { get }
    var shouldShowSuggestions: Bool { get }
    func relatedQuestions(count: Int) -> [String]
    func toogleSuggestions(isPresented: Bool)
}
