//
//  ArticleMarkDown.swift
//  
//
//  Created by Amakhin Ivan on 22.04.2024.
//

import SwiftUI
import MarkdownUI
import AppStudioStyles

struct ArticleMarkDown: View {
    let content: String
    
    var body: some View {
        Markdown {
            content
        }
        .markdownBlockStyle(\.heading2) { configuration in
            configuration.label
                .markdownTextStyle {
                    FontFamily(.custom("Poppins-Regular"))
                    FontWeight(.bold)
                    FontSize(20)
                }
                .padding(.top, .headerTopPadding)
                .padding(.bottom, .headerBottomPadding)
        }
        .markdownTextStyle(\.text) {
            FontFamily(.custom("Poppins-Regular"))
        }
        .markdownTextStyle(\.code) {
            ForegroundColor(Color.studioGreyText)
        }
        .markdownBlockStyle(\.taskListMarker) { _ in
            HStack(spacing: .zero) {
                Text("💘")
                    .font(.system(size: 15))
                Spacer()
            }
            .frame(width: .bulletListWidth)
            .padding(.leading, .listLeadingPadding)
        }
        .markdownBlockStyle(\.bulletedListMarker) { _ in
            HStack(spacing: .zero) {
                Image(systemName: "diamond.fill")
                    .foregroundStyle(.black)
                    .font(.system(size: 9))
                Spacer()
            }
            .frame(width: .bulletListWidth)
            .padding(.leading, .listLeadingPadding)
        }
        .markdownBlockStyle(\.numberedListMarker) { configuration in
            HStack(spacing: .zero) {
                Text("\(configuration.itemNumber).")
                    .monospacedDigit()
                Spacer()    
            }
            .frame(width: .bulletListWidth)
            .padding(.leading, .listLeadingPadding)
        }
        .markdownBlockStyle(\.listItem) { configuration in
            configuration.label
                .padding(.bottom, .listBottomPadding)
        }
        .markdownBlockStyle(\.tableCell) { configuration in
            configuration.label
                .markdownTextStyle {
                    FontFamily(.custom("Poppins-Regular"))
                }
                .padding(.vertical, .tableCellVerticalPadding)
                .padding(.trailing, .tableCellHorizontalPadding)
        }
        .markdownTableBorderStyle(.init(.insideHorizontalBorders,
                                        color: Color.studioGreyStrokeFill, 
                                        strokeStyle: .init(lineWidth: 1,
                                                           dash: [5], 
                                                           dashPhase: 5)))
        .padding(.horizontal, .horizontalPading)
    }
}

private extension CGFloat {
    static let tableCellVerticalPadding: CGFloat = 8
    static let tableCellHorizontalPadding: CGFloat = 10
    static let listLeadingPadding: CGFloat = 12
    static let listTrailingPadding: CGFloat = 30
    static let listBottomPadding: CGFloat = 16
    static let headerTopPadding: CGFloat = 32
    static let headerBottomPadding: CGFloat = 16
    static let horizontalPading: CGFloat = 20
    static let bulletListWidth: CGFloat = 40
}

#Preview {
    ScrollView {
        ArticleMarkDown(content: "## Why you love it\n- [ ]  Just a slight, subtle spinach flavour\n- [ ]  They keep well and are ideal for travel. Ideal for snacking\n- [ ]  Just a slight, subtle spinach flavour\n ## Ingredients\n| 10 servings   |    |\n| --- | --- |\n| **4** | all purpose flour|\n| **3/4 cups**    | organic spinach leaves, rinsed and patted dry|\n---\n ## Recipe Notes\n- **Preheat the pan**  \n`if your first pancake breaks, it’s probably because the pan isn’t hot enough. Give it a little more time to heat fully before trying the second`.\n- **Preheat the pan**  \n`if your first pancake breaks, it’s probably because the pan isn’t hot enough. Give it a little more time to heat fully before trying the second`.\n ## Testable\n 1. Blend the eggs and spinach in a blender until combined and the spinach is completely pureed. Add the flour and remaining ingredients and blend again until smooth.\n 2. Grease a small frying pan or crepe pan lightly with butter or cooking spray. Pour about 1/4-1/3 cup of the batter into the pan and distribute it evenly in the pan by moving it around until it covers the entire surface of the pan")
    }
}
