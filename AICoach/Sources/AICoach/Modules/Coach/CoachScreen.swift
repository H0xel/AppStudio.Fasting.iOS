//  
//  CoachScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import SwiftUI
import AppStudioNavigation
import Combine

struct CoachScreen: View {
    @StateObject var viewModel: CoachViewModel
    @State private var isSuggestionsPresented = true
    @FocusState private var focused: Bool

    var body: some View {
        VStack(spacing: .zero) {
            CoachNavigationView()

            if !viewModel.isCoachEnable {
                CoachEmptyView()
                CoachTermsOfUseView(appName: viewModel.constants.appName,
                                    output: viewModel.handle)
            } else {
                CoachScrollView(messages: viewModel.groupedMessages,
                                isWaitingForReply: viewModel.isWaitingForReply,
                                isSuggestionsPresented: isSuggestionsPresented,
                                onScrollToBottom: viewModel.trackScrollToBottom)
                .hideKeyboardOnTap()
                .overlay {
                    if isKeywordsPresented {
                        CoachKeywordsView(keywords: viewModel.keywords,
                                          questions: viewModel.questionsByKeyword) { question in
                            viewModel.nextQuestion = question
                            viewModel.trackTapSuggestion(context: .input)
                        }
                        .aligned(.bottom)
                        .transition(.asymmetric(insertion: .push(from: .bottom),
                                                removal: .push(from: .top)))
                    }
                }
                .transition(.push(from: .top))
                CoachTextField(text: $viewModel.nextQuestion,
                               isSuggestionsPresented: isSuggestionsPresented,
                               suggestions: viewModel.suggestions,
                               isKeywordsPresented: isKeywordsPresented,
                               isWaitingForReply: viewModel.isWaitingForReply,
                               output: viewModel.handle)
                .layoutPriority(1)
                .focused($focused)
            }
        }
        .animation(.bouncy, value: viewModel.isCoachEnable)
        .animation(.bouncy, value: viewModel.suggestions)
        .animation(.linear, value: viewModel.keywords)
        .onChange(of: viewModel.nextQuestion) { question in
            withAnimation(.bouncy) {
                isSuggestionsPresented = question.isEmpty && viewModel.isSuggestionsPresented
            }
        }
        .onChange(of: viewModel.isSuggestionsPresented) { isPresented in
            withAnimation(.bouncy) {
                isSuggestionsPresented = isPresented
            }
        }
        .onAppear {
            isSuggestionsPresented = viewModel.isSuggestionsPresented
        }
        .onChange(of: focused) { isFocused in
            viewModel.onFocusChange(isFocused)
        }
    }

    private var isKeywordsPresented: Bool {
        !viewModel.keywords.isEmpty &&
        !viewModel.isWaitingForReply &&
        !viewModel.questionsByKeyword.isEmpty
    }
}

struct CoachScreen_Previews: PreviewProvider {
    static var previews: some View {
        CoachScreen(
            viewModel: .init(
                input: .init(
                    constants: .init(privacyPolicy: "",
                                     termsOfUse: "",
                                     appName: "Fasting"),
                    suggestionTypes: [.general, .fasting],
                    nextMessagePublisher: CurrentValueSubject<String, Never>("").eraseToAnyPublisher(),
                    isMonetizationExpAvailable: Just(false).eraseToAnyPublisher()
                ),
                output: { _ in }
            )
        )
    }
}
