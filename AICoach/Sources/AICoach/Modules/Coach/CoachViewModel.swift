//  
//  CoachViewModel.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import Foundation
import AppStudioNavigation
import AppStudioUI
import Dependencies
import Combine

class CoachViewModel: BaseViewModel<CoachOutput> {

    @Dependency(\.coachService) private var coachService
    @Dependency(\.suggestedQuestionsService) private var suggestedQuestionsService
    @Dependency(\.userPropertyService) private var userPropertyService
    @Dependency(\.trackerService) private var trackerService
    @Dependency(\.coachMessageService) private var coachMessageService
    @Dependency(\.messageRunService) private var messageRunService

    var router: CoachRouter!
    @Published private var messages: [CoachMessage] = []
    @Published var isCoachEnable = false
    @Published var isWaitingForReply = false
    @Published var nextQuestion: String = ""
    @Published var suggestions: [String] = []
    @Published var keywords: [String] = []
    @Published var isSuggestionsPresented = true
    let constants: CoachConstants
    private var messagesObserver: CoachMessageObserver?
    private var nextMessagePublisher: AnyPublisher<String, Never>

    init(input: CoachInput, output: @escaping CoachOutputBlock) {
        constants = input.constants
        nextMessagePublisher = input.nextMessagePublisher
        super.init(output: output)
        isSuggestionsPresented = suggestedQuestionsService.shouldShowSuggestions
        isCoachEnable = coachService.isCoachEnable
        updateSuggestions()
        observeKeywords()
        observeMessages()
        observeIsWaitingForResponse()
        observeNextMessages()
    }

    var groupedMessages: [CoachMessagesGroup] {
        groupMessages(messages: messages)
    }

    var questionsByKeyword: [String] {
        let keywords = keywords
        guard !keywords.isEmpty else {
            return []
        }
        var result: [String] = []
        for question in suggestedQuestionsService.allQuestions
        where keywords.contains(where: { question.lowercased().contains($0) }) {
            result.append(question)
            if result.count == 3 {
                return result.sorted(by: <)
            }
        }
        return result.sorted(by: <)
    }

    func handle(termsOfUseViewOutput output: CoachTermsOfUseViewOutput) {
        switch output {
        case .agree:
            coachService.agreeToTerms()
            isCoachEnable = true
            trackTapAgreeToTerms()
        case .privacyPolicy:
            if let url = URL(string: constants.privacyPolicy) {
                router.openSafari(with: url)
            }
        case .termsOfUse:
            if let url = URL(string: constants.termsOfUse) {
                router.openSafari(with: url)
            }
        }
    }

    func handle(coachTextFieldOutput output: CoachTextFieldOutput) {
        switch output {
        case .regenerateSuggestions:
            updateSuggestions()
            trackTapMoreSuggestedQuestions()
        case .send(let text):
            sendMessage(with: text)
            trackMessageSent()
        case .toggleSuggestions(let isPresented):
            isSuggestionsPresented = isPresented
            suggestedQuestionsService.toogleSuggestions(isPresented: isPresented)
            trackToggleSuggestionPanel(isPresented: isPresented)
        case let .tapSuggestion(text, context):
            sendMessage(with: text)
            trackTapSuggestion(context: context)
        }
    }

    private func sendMessage(with text: String) {
        guard !isWaitingForReply, !text.trimmingCharacters(in: ["\n", " "]).isEmpty else {
            return
        }
        hideKeyboard()
        nextQuestion = ""
        isSuggestionsPresented = false
        appendMessage(with: text)
        isWaitingForReply = true
        Task {
            let message = try await coachMessageService.sendMessage(text: text,
                                                                    userData: coachService.userData)
            messageRunService.observeResponse(for: message)
        }
    }

    private func observeKeywords() {
        $nextQuestion
            .receive(on: DispatchQueue.main)
            .sink(with: self) { this, nextQuestion in
                this.updateKeywords(nextQuestion: nextQuestion)
            }
            .store(in: &cancellables)
    }

    private func updateKeywords(nextQuestion: String) {
        guard nextQuestion.count > 2,
              !suggestedQuestionsService.allQuestions.contains(nextQuestion) else {
            keywords = []
            return
        }
        let questionWords = nextQuestion
            .split(separator: " ")
            .filter { $0.count > 2 }
            .map { String($0.lowercased()) }

        guard !questionWords.isEmpty else {
            keywords = []
            return
        }
        keywords = suggestedQuestionsService.keywords.filter { keyword in
            questionWords.contains { keyword.lowercased().contains($0) }
        }
    }

    private func groupMessages(messages: [CoachMessage]) -> [CoachMessagesGroup] {
        let groupedDictionary = Dictionary(grouping: messages) {
            Calendar.current.startOfDay(for: $0.date)
        }
        let sortedKeys = groupedDictionary.keys.sorted()
        return sortedKeys.map {
            CoachMessagesGroup(date: $0, messages: groupedDictionary[$0] ?? [])
        }
    }

    private func updateSuggestions() {
        suggestions = Array(suggestedQuestionsService.allQuestions.prefix(3))
    }

    private func observeMessages() {
        messagesObserver = coachMessageService.coachMessageOsberver()

        messagesObserver?.results
            .receive(on: DispatchQueue.main)
            .assign(to: &$messages)
    }

    private func observeIsWaitingForResponse() {
        messageRunService.isRunningPublisher
            .receive(on: DispatchQueue.main)
            .assign(to: &$isWaitingForReply)
    }

    private func appendMessage(with text: String) {
        let newMessage = CoachMessage(id: UUID().uuidString,
                                      runId: UUID().uuidString,
                                      text: text,
                                      sender: .user,
                                      date: .now)
        messages.append(newMessage)
    }

    private func observeNextMessages() {
        nextMessagePublisher
            .filter { !$0.isEmpty }
            .sink(with: self, receiveValue: { this, nextMessage in
                this.trackTapAskNova(question: nextMessage)
                this.sendMessage(with: nextMessage)
            })
            .store(in: &cancellables)
    }
}

// MARK: - Analytics
extension CoachViewModel {
    private func trackTapAgreeToTerms() {
        trackerService.track(.tapAgreeToTerms)
    }

    private func trackTapMoreSuggestedQuestions() {
        trackerService.track(.tapMoreSuggestedQuestions)
    }

    func trackTapSuggestion(context: SuggestionContext) {
        trackerService.track(.tapSuggestedQuestion(question: nextQuestion, context: context.rawValue))
    }

    private func trackToggleSuggestionPanel(isPresented: Bool) {
        trackerService.track(isPresented ? .tapOpenSuggestPanel : .tapCloseSuggestPanel)
    }

    private func trackMessageSent() {
        trackerService.track(.messageSent)
        userPropertyService.incrementProperty(property: "messages_sent_count", value: 1)
    }

    func trackScrollToBottom() {
        trackerService.track(.tapScrollToBottom)
    }

    func trackTapAskNova(question: String) {
        trackerService.track(.tapAskNova(context: "bmi_info", question: question))
    }
}
