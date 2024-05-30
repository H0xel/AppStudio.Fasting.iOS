//
//  CoachKeywordsView.swift
//
//
//  Created by Руслан Сафаргалеев on 21.02.2024.
//

import SwiftUI
import Dependencies
import AppStudioStyles

struct CoachKeywordsView: View {

    @Dependency(\.styles) private var styles

    let keywords: [String]
    let questions: [String]
    let onTap: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: .spacing) {
            ForEach(questions, id: \.self) { question in
                Button {
                    onTap(question)
                } label: {
                    textView(for: question)
                        .padding(.horizontal, .questionHorizontalPadding)
                        .padding(.vertical, .questionVerticalPadding)
                        .border(configuration: .init(cornerRadius: .questionCornerRadius,
                                                     color: styles.colors.coachGreyStrokeFill,
                                                     lineWidth: .borderWidth))
                }
            }
        }
        .animation(nil, value: questions)
        .padding(.bottom, .bottomPadding)
        .padding(.top, .topPadding)
        .padding(.horizontal, .horizontalPadding)
        .aligned(.left)
        .background(.white)
        .corners([.topLeft, .topRight], with: .cornerRadius)
        .modifier(TopBorderModifier(color: styles.colors.coachGreyStrokeFill))
        .background(styles.colors.coachGrayFillProgress)
    }

    private func textView(for question: String) -> some View {
        Group {
            Text(leftSide(question: question))
                .foregroundColor(styles.colors.accent)
            + Text(" \(keyword(in: question)) ")
                .foregroundColor(styles.colors.coachSky)
            + Text(rightSide(question: question))
                .foregroundColor(styles.colors.accent)
        }
        .font(styles.fonts.body)
        .multilineTextAlignment(.leading)
    }

    private func leftSide(question: String) -> String {
        let keyword = keyword(in: question)
        guard !keyword.isEmpty else {
            return ""
        }
        let words = question.split(separator: " ")
        let lowercasedKeyword = keyword.lowercased()
        if let index = words.firstIndex(where: { $0.lowercased().contains(lowercasedKeyword) }) {
            return words[..<index].joined(separator: " ")
        }
        return ""
    }

    private func rightSide(question: String) -> String {
        let keyword = keyword(in: question)
        guard !keyword.isEmpty else {
            return ""
        }
        let words = question.split(separator: " ")
        let lowercasedKeyword = keyword.lowercased()
        if let index = words.firstIndex(where: { $0.lowercased().contains(lowercasedKeyword) }),
           index + 1 < words.count {
            return words[index + 1 ..< words.count].joined(separator: " ")
        }
        return ""
    }

    private func keyword(in question: String) -> String {
        let words = question.split(separator: " ")
        for keyword in keywords {
            let lowercasedKeyword = keyword.lowercased()
            if let index = words.firstIndex(where: { $0.lowercased().contains(lowercasedKeyword) }) {
                return String(words[index])
            }
        }
        return ""
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 10
    static let bottomPadding: CGFloat = 12
    static let topPadding: CGFloat = 24
    static let spacing: CGFloat = 8
    static let cornerRadius: CGFloat = 20
    static let questionHorizontalPadding: CGFloat = 16
    static let questionVerticalPadding: CGFloat = 12
    static let borderWidth: CGFloat = 0.5
    static let questionCornerRadius: CGFloat = 68
}

#Preview {
    ZStack {
        Color.red
        CoachKeywordsView(
            keywords: ["exercise"],
            questions: [
                "What to eat before exercise, What to eat before exercise?",
                "Give me some leg exercises",
                "What exercise can I try outside the gym?"
            ]
        ) { _ in }
    }
}
