//
//  SwiftUIView.swift
//  
//
//  Created by Denis Khlopin on 08.03.2024.
//

import SwiftUI

struct HintFastingContentView: View {
    let fastingContent: ColoredDotsContent

    var body: some View {
        VStack(spacing: .spacing) {
            HStack {
                Text(fastingContent.title)
                    .font(.poppinsMedium(.body))
                Spacer()
            }
            VStack(spacing: .emptySpacing) {
                ForEach(fastingContent.phases, id: \.self) { phase in
                    HStack(spacing: .horizontalSpacing) {
                        Circle()
                            .frame(width: .circleSize, height: .circleSize)
                            .foregroundStyle(phase.color)
                            .padding(.horizontal, .circleHorizontalPadding)

                        Text(phase.title)
                            .font(.poppins(.body))
                        Spacer()
                    }
                    .frame(height: .phaseHeight)
                }
            }
        }
        .padding(.bottom, .bottomPadding)
    }
}

// MARK: - Layout properties
private extension CGFloat {
    static let spacing: CGFloat = 8
    static let emptySpacing: CGFloat = 0
    static let circleSize: CGFloat = 12
    static let circleHorizontalPadding: CGFloat = 8
    static let horizontalSpacing: CGFloat = 12
    static let phaseHeight: CGFloat = 34
    static let bottomPadding: CGFloat = 24
}

#Preview {
    HintFastingContentView(fastingContent: .init(title: "", phases: []))
}
