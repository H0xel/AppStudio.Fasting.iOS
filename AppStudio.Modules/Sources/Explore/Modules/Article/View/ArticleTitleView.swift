//
//  ArticleTitleView.swift
//  
//
//  Created by Amakhin Ivan on 22.04.2024.
//

import SwiftUI
import AppStudioStyles

struct ArticleTitleView: View {
    @Binding var imageScale: CGFloat
    let image: Image?
    let title: String
    let cookAmount: Int?

    @State private var offset: CGFloat = 0

    var body: some View {
        if let image {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .scaleEffect(.init(imageScale))
                .offset(y: offset)
                .onChange(of: imageScale) { value in
                    offset = (value - 1) * -100
                }
        }

        VStack(alignment: .leading, spacing: .zero) {
            Text(title)
                .font(.poppins(.headerL))
                .padding(.top, .titleTopPadding)
                .padding(.bottom, .titleBottomPadding)
            
            if let cookAmount {
                Text("\(cookAmount) \("Nutrition.minCook".localized(bundle: .module))")
                    .font(.poppins(.description))
                    .aligned(.left)
                    .foregroundStyle(Color.studioGrayText)
            }
        }
        .padding(.horizontal, .horizontalPadding)
    }
}

private extension CGFloat {
    static var titleTopPadding: CGFloat = 32
    static var titleBottomPadding: CGFloat = 16
    static var horizontalPadding: CGFloat = 20
}

#Preview {
    ArticleTitleView(imageScale: .constant(1), 
                     image: Image(.markdownTop), 
                     title: "Vegan Broccoli Pizza Crust with Spring Vegetables", 
                     cookAmount: 35)
}
