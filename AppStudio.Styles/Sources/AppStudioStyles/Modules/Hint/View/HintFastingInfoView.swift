//
//  SwiftUIView.swift
//  
//
//  Created by Denis Khlopin on 08.03.2024.
//

import SwiftUI

struct HintFastingInfoView: View {
    let fastingInfo: ParagraphContent
    var body: some View {
        VStack(alignment: .leading, spacing: .spacing) {
                Text(fastingInfo.title)
                    .font(.poppinsMedium(.body))

            ForEach(fastingInfo.topics, id: \.self) { topic in
                Text(topic)
                    .font(.poppins(.body))
            }
        }
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let spacing: CGFloat = 12
}

#Preview {
    HintFastingInfoView(fastingInfo: ParagraphContent(title: "title", topics: ["topic"]))
}
