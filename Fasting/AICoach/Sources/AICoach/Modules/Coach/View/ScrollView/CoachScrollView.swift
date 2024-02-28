//
//  CoachScreenScrollView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import SwiftUI
import AppStudioUI
import Dependencies

private let scrollTriggerKey = "scrollTriggerKey"
private let coordinateSpaceName = "ChatScrollView"

struct CoachScrollView: View {

    @Dependency(\.styles) private var styles

    let messages: [CoachMessagesGroup]
    let isWaitingForReply: Bool
    let isSuggestionsPresented: Bool
    let onScrollToBottom: () -> Void

    @State private var isScrolledDown = true
    @State private var messageIdToScroll: String?
    @State private var hasNewMessage = false

    var body: some View {
        ScrollViewReader { reader in
            ScrollView {
                triggerView
                Spacer(minLength: .bottomSpacing)
                LazyVStack(spacing: .spacing) {
                    if isWaitingForReply {
                        WaitingReplyView()
                            .aligned(.left)
                            .padding(.horizontal, .horizontalPadding)
                            .rotationEffect(Angle(degrees: 180))
                    }
                    ForEach(messages.reversed(), id: \.date) { group in
                        ForEach(group.messages.reversed()) { message in
                            CoachMessageView(message: message)
                                .id(message.id)
                        }
                        .rotationEffect(Angle(degrees: 180))
                        Text(group.date.localeDateOrTodayOrYesterday())
                            .font(styles.fonts.description)
                            .foregroundStyle(styles.colors.coachGrayText)
                            .padding(.dateVerticalPadding)
                            .rotationEffect(Angle(degrees: 180))
                    }
                }
                Spacer(minLength: .topSpacing)
            }
            .coordinateSpace(name: coordinateSpaceName)
            .scrollDismissesKeyboard(.immediately)
            .rotationEffect(Angle(degrees: 180))
            .scrollIndicators(.hidden)
            .background(styles.colors.coachGrayFillProgress)
            .overlay {
                if !isScrolledDown, !isSuggestionsPresented {
                    scrollButton(reader: reader)
                }
            }
            .onChange(of: messages) { messages in
                onMessagesChange(messages, reader: reader)
            }
            .onChange(of: isWaitingForReply) { isWaitingForReply in
                if !isWaitingForReply {
                    hasNewMessage = true
                }
            }
        }
    }

    private func scrollButton(reader: ScrollViewProxy) -> some View {
        ScrollDownButton(hasNewMessage: hasNewMessage) {
            if let messageIdToScroll {
                reader.scrollTo(scrollTriggerKey)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    reader.scrollTo(messageIdToScroll,
                                    anchor: .bottom,
                                    animation: .linear)
                    self.messageIdToScroll = nil
                    hasNewMessage = false
                }
            } else {
                reader.scrollTo(scrollTriggerKey,
                                animation: .linear)
            }
            onScrollToBottom()
        }
        .aligned(.bottomRight)
        .padding(.bottom, .buttonBottomPadding)
        .padding(.trailing, .buttonTrailingPadding)
    }

    private var triggerView: some View {
        MinYPositionTracker(coordinateSpace: .named(coordinateSpaceName)) { position in
            isScrolledDown = position > -50
            if position > -50 {
                hasNewMessage = false
                if !isWaitingForReply {
                    messageIdToScroll = nil
                }
            }
        }
        .id(scrollTriggerKey)
    }

    private func onMessagesChange(_ messages: [CoachMessagesGroup], reader: ScrollViewProxy) {
        guard let message = messages.last?.messages.last else {
            return
        }
        if message.sender == .user {
            messageIdToScroll = message.id
            reader.scrollTo(scrollTriggerKey, anchor: .bottom, animation: .linear)
        } else if isScrolledDown, let messageIdToScroll {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                reader.scrollTo(messageIdToScroll,
                                anchor: .bottom,
                                animation: .linear)
                self.messageIdToScroll = nil
            }
        }
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 16
    static let bottomSpacing: CGFloat = 32
    static let topSpacing: CGFloat = 16
    static let dateVerticalPadding: CGFloat = 8
    static let buttonTrailingPadding: CGFloat = 10
    static let buttonBottomPadding: CGFloat = 8
    static let horizontalPadding: CGFloat = 16
}

#Preview {
    CoachScrollView(messages: [], isWaitingForReply: false, isSuggestionsPresented: false) {}
}
