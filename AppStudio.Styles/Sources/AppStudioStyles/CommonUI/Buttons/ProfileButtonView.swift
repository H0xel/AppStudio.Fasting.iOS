//
//  File.swift
//  
//
//  Created by Руслан Сафаргалеев on 04.04.2024.
//

import SwiftUI
import AppStudioUI
import AppStudioModels

public struct ProfileButtonInput {
    let title: String
    let description: String?
    let image: Image?

    public init(title: String, description: String?, image: Image?) {
        self.title = title
        self.description = description
        self.image = image
    }
}

public struct ProfileButtonView: View {

    private let input: ProfileButtonInput
    private let action: () -> Void

    public init(input: ProfileButtonInput,
                action: @escaping () -> Void) {
        self.input = input
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: .zero) {
                if let image = input.image {
                    image
                        .padding(.trailing, Layout.imageTrailingPadding)
                }
                Text(input.title)
                    .foregroundStyle(Color.studioBlackLight)
                Spacer()
                if let description = input.description {
                    Text(description)
                        .foregroundStyle(Color.studioGreyText)
                        .padding(.trailing, Layout.descriptionTrailingPadding)
                }
                Image.chevronRight
                    .foregroundStyle(Color.studioGreyStrokeFill)
            }
            .font(.poppins(.body))
            .padding(.trailing, Layout.trailingPadding)
            .padding(.leading, Layout.leadingPadding)
            .padding(.vertical, Layout.verticalPadding)
            .background(.white)
        }
    }
}

public extension ProfileButtonInput {
    static func sex(sex: Sex) -> ProfileButtonInput {
        .init(title: "ProfileScreen.sex".localized(bundle: .module),
              description: sex.title,
              image: sex == .male ? .init(.sexMale) : .init(.sexFemale))
    }

    static func birthday(birthday: Date) -> ProfileButtonInput {
        .init(title: "ProfileScreen.birthday".localized(bundle: .module),
              description: birthday.currentLocaleFormatted(with: "MMdyyyy"),
              image: .init(.birthday))
    }

    static func height(height: HeightMeasure) -> ProfileButtonInput {
        .init(title: "ProfileScreen.height".localized(bundle: .module),
              description: height.valueWithUnits,
              image: .init(.height))
    }

    static var support: ProfileButtonInput {
        .init(title: "ProfileScreen.support".localized(bundle: .module),
              description: nil,
              image: .init(.heart))
    }

    static var termsOfUse: ProfileButtonInput {
        .init(title: "ProfileScreen.termsOfUse".localized(bundle: .module),
              description: nil,
              image: nil)
    }

    static var privacyPolicy: ProfileButtonInput {
        .init(title: "ProfileScreen.privacyPolicy".localized(bundle: .module),
              description: nil,
              image: nil)
    }
}

private extension ProfileButtonView {
    enum Layout {
        static let leadingPadding: CGFloat = 20
        static let trailingPadding: CGFloat = 16
        static let verticalPadding: CGFloat = 16
        static let imageTrailingPadding: CGFloat = 16
        static let descriptionTrailingPadding: CGFloat = 14
    }
}
