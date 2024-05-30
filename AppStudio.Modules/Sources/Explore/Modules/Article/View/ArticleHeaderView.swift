//
//  ArticleHeaderView.swift
//  
//
//  Created by Amakhin Ivan on 22.04.2024.
//

import SwiftUI
import AppStudioStyles

struct ArticleHeaderView: View {
    let title: String?
    @Binding var isSaved: Bool
    @Binding var isFavourite: Bool
    var action: (Action) -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: .zero) {
            Button(action: {
                action(.close)
            }, label: {
                ZStack {
                    Circle()
                        .frame(height: .buttonHeight)
                        .foregroundStyle(Color.white.opacity(0.5))
                    Image(.cross)
                }
            })
            Spacer(minLength: .minSpacing)
            ZStack(alignment: .center) {
                if let title {
                    Text(title)
                        .font(.poppins(.buttonText))
                        .foregroundStyle(Color.studioBlackLight)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .transition(.asymmetric(insertion: .push(from: .leading), removal: .identity))
                }
                Text("Nutrition.saved".localized(bundle: .module))
                    .font(.poppins(.body))
                    .foregroundStyle(.white)
                    .padding(.horizontal, .bannerHorizontalPadding)
                    .padding(.vertical, .bannerVerticalPadding)
                    .background(Color.studioBlackLight)
                    .continiousCornerRadius(.cornerRadius)
                    .opacity(isSaved ? 1 : 0)
                    .animation(.interpolatingSpring, value: isSaved)
            }
            Spacer(minLength: .minSpacing)
            Button(action: {
                action(.bookmarkTapped)
            }, label: {
                ZStack {
                    Circle()
                        .frame(height: .buttonHeight)
                        .foregroundStyle(isFavourite ? Color.studioBlackLight : Color.white.opacity(0.5))
                    Image(isFavourite ? .bookMarksSelected : .bookMarksUnselected)
                }
            })
        }
        .padding(.horizontal, .horizontalPadding)
        .background(background.animation(nil, value: title).ignoresSafeArea())
        .aligned(.top)
        .animation(.bouncy(duration: 0.2), value: title)
    }

    private var background: some View {
        title == nil ? Color.clear : .white
    }
}

private extension CGFloat {
    static let buttonHeight: CGFloat = 40
    static let bannerHorizontalPadding: CGFloat = 32
    static let bannerVerticalPadding: CGFloat = 16
    static var horizontalPadding: CGFloat = 12
    static var cornerRadius: CGFloat = 20
    static let minSpacing: CGFloat = 16
}

extension ArticleHeaderView {
    enum Action {
        case close
        case bookmarkTapped
    }
}

#Preview {
    VStack {
        ArticleHeaderView(title: nil, isSaved: .constant(true), isFavourite: .constant(true)) { _ in }
        ArticleHeaderView(title: nil, isSaved: .constant(false), isFavourite: .constant(false)) { _ in }
    }
    .background(Color.red)
}
