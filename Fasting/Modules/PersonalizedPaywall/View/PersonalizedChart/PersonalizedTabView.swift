//
//  PersonalizedTabView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 07.12.2023.
//

import SwiftUI

struct PersonalizedTabView: View {
    let sex: Sex
    let weightUnit: WeightUnit
    @State private var selected: Sex.Content

    init(sex: Sex, weightUnit: WeightUnit) {
        self.sex = sex
        self.weightUnit = weightUnit
        selected = sex.content(weightUnit: weightUnit)[0]
    }

    var body: some View {
        VStack(spacing: .zero) {
            Text(Localizable.title)
                .font(.poppins(.headerS))
                .foregroundStyle(.accent)
                .padding(.bottom, Layout.titleBottomPadding)

            TabView(selection: $selected) {
                ForEach(sex.content(weightUnit: weightUnit), id: \.self) { content in
                    VStack(spacing: .zero) {
                        ZStack {
                            content.image
                                .resizable()
                                .frame(height: Layout.imageHeight)
                                .aspectRatio(contentMode: .fit)

                            Text("- \(content.weight) \(weightUnit.rawValue)")
                                .font(.poppins(.headerS))
                                .foregroundStyle(.white)
                                .padding(.horizontal, Layout.textWeightHorizontalPadding)
                                .padding(.vertical, Layout.textWeightVerticalPadding)
                                .background(Color.studioSky)
                                .continiousCornerRadius(Layout.textWeightCornerRadius)
                                .aligned(.bottom)
                        }
                        .frame(height: Layout.zStackImageHeight)
                        .padding(.bottom, Layout.textWeightBottomPadding)

                        Text(content.name)
                            .font(.poppins(.headerS))
                            .padding(.bottom, Layout.nameBottomSpacing)

                        Text(content.description)
                            .font(.poppins(.description))
                            .multilineTextAlignment(.center)

                        Spacer()
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.bottom, Layout.tabBottomPadding)

            HStack(spacing: Layout.circleSpacing) {
                ForEach(sex.content(weightUnit: weightUnit), id: \.self) { content in
                    Circle()
                        .foregroundStyle(content == selected ? .black : .studioGreyStrokeFill)
                        .frame(width: content == selected ? Layout.selectedCircle : Layout.deselectedCircle)
                }
            }
        }
        .padding(.horizontal, Layout.horizontalPadding)
        .frame(height: Layout.height)
    }
}

private extension PersonalizedTabView {
    enum Layout {
        static let titleBottomPadding: CGFloat = 10
        static let height: CGFloat = 470
        static let horizontalPadding: CGFloat = 32
        static let tabBottomPadding: CGFloat = 24
        static let nameBottomSpacing: CGFloat = 8
        static let circleSpacing: CGFloat = 8
        static let selectedCircle: CGFloat = 6
        static let deselectedCircle: CGFloat = 4

        static let imageHeight: CGFloat = 248
        static let zStackImageHeight: CGFloat = 270
        static let textWeightBottomPadding: CGFloat = 10
        static let textWeightVerticalPadding: CGFloat = 8
        static let textWeightHorizontalPadding: CGFloat = 16
        static let textWeightCornerRadius: CGFloat = 8
    }

    enum Localizable {
        static let title: LocalizedStringKey = "PersonalizedPaywall.realTransformation"
    }
}

#Preview {
    PersonalizedTabView(sex: .female, weightUnit: .lb)
}

private extension Sex {
    struct Content: Hashable {
        let image: Image
        let name: String
        let description: String
        let weight: Int

        func hash(into hasher: inout Hasher) {
            hasher.combine(name + description)
        }
    }

    func content(weightUnit: WeightUnit) -> [Content] {
        switch self {
        case .male:
            return [
                .init(image: .init(.trevorM),
                      name: NSLocalizedString("PersonalizedPaywall.male.name1", comment: ""),
                      description: NSLocalizedString("PersonalizedPaywall.female.description1", comment: ""),
                      weight: weightUnit == .kg ? 12 : 25),
                .init(image: .init(.ericK),
                      name: NSLocalizedString("PersonalizedPaywall.male.name2", comment: ""),
                      description: NSLocalizedString("PersonalizedPaywall.male.description2", comment: ""),
                      weight: weightUnit == .kg ? 6 : 13),
                .init(image: .init(.georgeP),
                      name: NSLocalizedString("PersonalizedPaywall.male.name3", comment: ""),
                      description: NSLocalizedString("PersonalizedPaywall.male.description3", comment: ""),
                      weight: weightUnit == .kg ? 4 : 8)
            ]
        case .female, .other:
            return [
                .init(image: .init(.dianaC),
                      name: NSLocalizedString("PersonalizedPaywall.female.name1", comment: ""),
                      description: NSLocalizedString("PersonalizedPaywall.female.description1", comment: ""),
                      weight: weightUnit == .kg ? 11 : 24),
                .init(image: .init(.lisaM),
                      name: NSLocalizedString("PersonalizedPaywall.female.name2", comment: ""),
                      description: NSLocalizedString("PersonalizedPaywall.female.description2", comment: ""),
                      weight: weightUnit == .kg ? 3 : 6),
                .init(image: .init(.paulaS),
                      name: NSLocalizedString("PersonalizedPaywall.female.name3", comment: ""),
                      description: NSLocalizedString("PersonalizedPaywall.female.description3", comment: ""),
                      weight: weightUnit == .kg ? 6 : 13)
            ]
        }
    }
}
