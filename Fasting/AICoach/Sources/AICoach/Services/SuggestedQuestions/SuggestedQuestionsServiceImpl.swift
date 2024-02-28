//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.02.2024.
//

import Foundation
import Dependencies
import MunicornFoundation

private let shouldShowSuggestionsKey = "shouldShowSuggestionsKey"

class SuggestedQuestionsServiceImpl: SuggestedQuestionsService {

    @Dependency(\.storageService) private var storageService

    var keywords = Set<String>()
    private var fastingRelatedQuestions = Set<String>()
    private var generalQuestions = Set<String>()
    private var isLoaded = false

    init() {
        loadQuestionsIdNeeded()
    }

    var allQuestions: Set<String> {
        fastingRelatedQuestions.union(generalQuestions)
    }

    var shouldShowSuggestions: Bool {
        storageService.shouldShowSuggestions
    }

    func relatedQuestions(count: Int) -> [String] {
        Array(fastingRelatedQuestions.shuffled().prefix(count))
    }

    func toogleSuggestions(isPresented: Bool) {
        storageService.shouldShowSuggestions = isPresented
    }

    private func loadQuestionsIdNeeded() {
        if isLoaded { return }

        var count = 1
        while true {
            let question = NSLocalizedString("FastingRelatedQuestions.quesion\(count)",
                                             bundle: .coachBundle,
                                             comment: "")
            guard question != "FastingRelatedQuestions.quesion\(count)" else {
                break
            }
            fastingRelatedQuestions.insert(question)
            count += 1
        }

        count = 1
        while true {
            let question = NSLocalizedString("GeneralQuestions.question\(count)",
                                             bundle: .coachBundle,
                                             comment: "")
            guard question != "GeneralQuestions.question\(count)" else {
                break
            }
            generalQuestions.insert(question)
            count += 1
        }

        count = 1
        while true {
            let keyword = NSLocalizedString("SuggestedQuestions.keyword\(count)",
                                            bundle: .coachBundle,
                                            comment: "")
            guard keyword != "SuggestedQuestions.keyword\(count)" else {
                break
            }
            keywords.insert(keyword)
            count += 1
        }
        isLoaded = true
    }
}

private extension StorageService {
    var shouldShowSuggestions: Bool {
        get { get(key: shouldShowSuggestionsKey, defaultValue: true) }
        set { set(key: shouldShowSuggestionsKey, value: newValue) }
    }
}
