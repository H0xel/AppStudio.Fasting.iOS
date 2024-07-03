//
//  AttributedText.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.05.2024.
//

import SwiftUI

public struct AttributedText: View {

    private let text: NSAttributedString
    @State private var textWidth: CGFloat = 0

    public init(text: NSAttributedString) {
        self.text = text
    }

    public var body: some View {
        AttributedTextView(text: text)
            .frame(height: text.height(forWidth: textWidth))
            .withViewWidthPreferenceKey
            .onViewWidthPreferenceKeyChange { newWidth in
                textWidth = newWidth
            }
    }
}

private struct AttributedTextView: UIViewRepresentable {

    let text: NSAttributedString

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        let label = UILabel()
        label.attributedText = text
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.topAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}

private extension NSAttributedString {
    func height(forWidth width: CGFloat) -> CGFloat {
        let rect = boundingRect(with: CGSize.init(width: width, height: .greatestFiniteMagnitude),
                                options: [.usesLineFragmentOrigin, .usesFontLeading],
                                context: nil)
        return ceil(rect.size.height)
    }
}
