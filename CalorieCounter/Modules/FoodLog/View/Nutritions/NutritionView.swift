//
//  NutritionView.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.12.2023.
//

import SwiftUI

struct NutritionView: View {

    let amount: Double
    let configuration: Configuration
    let bordered: Bool

    var body: some View {
        if bordered {
            view
                .modifier(BorderedNutritionModifier())
        } else {
            view
        }
    }

    private var view: some View {
        HStack(spacing: configuration.isHidden ? .hiddenSpacing : .spacing) {
            imageView
                .foregroundStyle(configuration.textColor)
                .fontWeight(configuration.textWeight)
            if configuration.isHidden {
                Image.crownFill
                    .foregroundStyle(Color.studioGreyStrokeFill)
                    .font(configuration.crownFont)
            } else {
                Text(amountText)
                    .foregroundStyle(configuration.amountColor)
            }
        }
        .font(configuration.font)
    }

    var amountText: String {
        if amount.isNaN {
            return "0"
        }
        if amount < 1 {
            return amount.withOneFractionIfNeeded
        }
        return "\(Int(amount.rounded()))"
    }

    @ViewBuilder
    private var imageView: some View {
        if let image = configuration.image {
            image
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: .imageWidth, height: .imageWidth)
        } else {
            Text(configuration.title)
        }
    }
}

extension NutritionView {
    struct Configuration {
        let image: Image?
        let title: String
        let textColor: Color
        let amountColor: Color
        let font: Font
        let textWeight: Font.Weight
        var isHidden = false
        var crownFont: Font = .system(size: 10)
    }
}

extension NutritionView.Configuration {

    static func coloredLarge(type: NutritionType) -> NutritionView.Configuration {
        .init(image: type.image,
              title: type.title,
              textColor: type.color,
              amountColor: .accent,
              font: .poppins(.body),
              textWeight: .medium)
    }

    static func hidden(type: NutritionType) -> NutritionView.Configuration {
        .init(image: type.image,
              title: type.title,
              textColor: type.color,
              amountColor: .accent,
              font: .poppins(.body),
              textWeight: .medium,
              isHidden: true,
              crownFont: .footnote)
    }

    static func hiddenSmall(type: NutritionType) -> NutritionView.Configuration {
        .init(image: type.image,
              title: type.title,
              textColor: type.color,
              amountColor: .accent,
              font: .poppins(.body),
              textWeight: .medium,
              isHidden: true)
    }

    static func coloredSmall(type: NutritionType) -> NutritionView.Configuration {
        .init(image: type.image,
              title: type.title,
              textColor: type.color,
              amountColor: .accent,
              font: .poppins(.description),
              textWeight: .medium)
    }

    static func placeholderSmall(type: NutritionType) -> NutritionView.Configuration {
        .init(image: type.image,
              title: type.title,
              textColor: .studioGreyPlaceholder,
              amountColor: .studioGreyPlaceholder,
              font: .poppins(.description),
              textWeight: .regular)
    }

    static func greyStrokeLarge(type: NutritionType) -> NutritionView.Configuration {
        .init(image: type.image,
              title: type.title,
              textColor: .studioGreyStrokeFill,
              amountColor: .studioGreyStrokeFill,
              font: .poppins(.buttonText),
              textWeight: .medium)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
    static let hiddenSpacing: CGFloat = 6
    static let imageWidth: CGFloat = 12
}

#Preview {
    VStack {
        NutritionView(amount: 10,
                      configuration: .coloredLarge(type: .carbs),
                      bordered: true)
    }
}
