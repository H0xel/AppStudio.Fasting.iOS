//
//  IngredientPlaceholderView.swift
//  CalorieCounter
//
//  Created by Denis Khlopin on 30.01.2024.
//

import SwiftUI

struct IngredientPlaceholderView: View {
    let placeholder: MealPlaceholder
    var onClose: () -> Void
    @State private var gradientLocation: CGFloat = 0
    @State private var isMovingForward = true
    private let timer = Timer.publish(every: 0.02, on: .main, in: .default).autoconnect()

    var body: some View {
        if placeholder.notFound {
            HStack(spacing: .zero) {
                Text(placeholder.type == .barcode ? Localization.notFoundTitle : Localization.notFoundAITitle)
                    .font(.poppins(.body))
                    .foregroundStyle(.accent)

                Spacer()

                Button(action: onClose, label: {
                    Image.close
                        .foregroundStyle(Color.studioGrayText)
                })
            }
            .padding(.vertical, .verticalPadding)
            .padding(.horizontal, .horizontalPadding)
            .background(Color.studioRed.opacity(0.1))
        } else {
            HStack(spacing: .zero) {
                gradient
                Spacer()
                gradient
                    .frame(width: .width, height: .height)
                    .background(Color.studioGreyFillCard)
                    .continiousCornerRadius(.cornerRadius)
                    .border(configuration: .init(
                        cornerRadius: .cornerRadius,
                        color: .accent,
                        lineWidth: 0)
                    )
            }
            .onReceive(timer) { _ in
                gradientLocation += isMovingForward ? 0.01 : -0.01
                if gradientLocation > 1.2 {
                    isMovingForward = false
                }
                if gradientLocation < -0.2 {
                    isMovingForward = true
                }
            }
        }
    }


    private var gradient: some View {
        LinearGradient(stops: [
            .init(color: .studioGreyFillCard, location: -0.21),
            .init(color: .studioGreyStrokeFill.opacity(0.6), location: gradientLocation),
            .init(color: .studioGreyFillCard, location: 1.21)
        ], startPoint: .leading, endPoint: .trailing)
        .frame(height: .gradientHeight)
        .continiousCornerRadius(.gradientCornerRadius)
    }
}

private extension IngredientPlaceholderView {
    enum Localization {
        static let notFoundTitle = NSLocalizedString("IngredientPlaceholderView.notFound",
                                                     comment: "Nothing found with this barcode")
        static let notFoundAITitle = NSLocalizedString("IngredientPlaceholderView.notFoundAI",
                                                     comment: "Nothing found with this barcode")
    }
}

private extension CGFloat {
    static let width: CGFloat = 72
    static let height: CGFloat = 36
    static let spacing: CGFloat = 4
    static let gradientHeight: CGFloat = 36
    static let gradientCornerRadius: CGFloat = 8
    static let titleSpacing: CGFloat = 6
    static let cornerRadius: CGFloat = 8
    static let horizontalPadding: CGFloat = 16
    static let verticalPadding: CGFloat = 11
}

#Preview {
    VStack {
        IngredientPlaceholderView(placeholder: .init(mealText: "aed", type: .ai), onClose: {})
        IngredientPlaceholderView(placeholder: .init(mealText: "aed", type: .ai, notFound: true), onClose: {})
    }
}
