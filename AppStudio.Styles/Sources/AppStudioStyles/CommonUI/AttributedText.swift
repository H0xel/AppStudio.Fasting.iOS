//
//  AttributedText.swift
//  
//
//  Created by Руслан Сафаргалеев on 22.05.2024.
//

import SwiftUI

public struct AttributedText: UIViewRepresentable {

    private let text: NSAttributedString

    public init(text: NSAttributedString) {
        self.text = text
    }

    public func makeUIView(context: Context) -> UILabel {
        let label = UILabel()
        label.attributedText = text
        return label
    }

    public func updateUIView(_ uiView: UILabel, context: Context) {
    }
}
