//
//  FavouriteArticlesEmptyView.swift
//
//
//  Created by Руслан Сафаргалеев on 22.04.2024.
//

import SwiftUI
import AppStudioStyles

struct FavouriteArticlesEmptyView: View {
    var body: some View {
        VStack(spacing: .spacing) {
            Image.squareGrid
                .foregroundStyle(Color.studioGreyStrokeFill)
                .fontWeight(.medium)
            Text(String.title)
                .foregroundStyle(Color.studioGrayPlaceholder)
                .multilineTextAlignment(.center)
                .font(.poppinsMedium(.body))
        }
        .padding(.horizontal, .horizontalPadding)
        .aligned(.centerHorizontaly)
        .aligned(.centerVerticaly)
        .background(Color.studioGrayFillProgress)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 20
    static let horizontalPadding: CGFloat = 36
}

private extension String {
    static let title = "FavouriteArticlesScreen.emptyTitle".localized(bundle: .module)
}

#Preview {
    FavouriteArticlesEmptyView()
}
