//
//  SwiftUIView.swift
//  
//
//  Created by Руслан Сафаргалеев on 20.03.2024.
//

import SwiftUI
import AppStudioStyles

struct HealthProgressWidgetView<Content: View>: View {

    let input: HealthWidgetInput
    let isEmptyState: Bool
    let isMonetization: Bool
    let output: (HealthChartOutput) -> Void
    let content: () -> Content

    var body: some View {
        VStack(spacing: .spacing) {
            Group {
                HStack {
                    Text(input.title)
                        .font(.poppinsBold(.buttonText))
                        .foregroundStyle(Color.studioBlackLight)
                    Spacer()
                    Button(action: {
                        output(.infoTap)
                    }, label: {
                        input.icon
                    })
                }
                if isEmptyState, !isMonetization  {
                    ChartEmptyView(input: input.emptyStateInput) {
                        output(.emptyStateButtonTap)
                    }
                    .padding(.bottom, .emptyViewBottomPadding)
                } else {
                    Text(input.subtitle)
                        .font(.poppins(.description))
                        .foregroundStyle(Color.studioBlackLight)
                        .aligned(.left)
                }
            }
            .padding(.horizontal, .horizontalPadding)
            if isMonetization {
                MonetizationOverlayView(input: input) {
                    output(.presentPaywall)
                }
            } else {
                content()
            }

            if input.isExploreButtonPresented {
                Button(action: {
                    output(.learnMoreTap)
                }, label: {
                    HStack {
                        Text(String.exploreMore)
                            .font(.poppinsMedium(.body))
                        Image.chevronRight
                    }
                    .foregroundStyle(Color.studioBlackLight)
                })
                .aligned(.left)
                .padding(.horizontal, .horizontalPadding)
            }
        }
        .padding(.vertical, .verticalPadding)
        .background(.white)
        .continiousCornerRadius(.cornerRadius)
    }
}

extension HealthProgressWidgetView {
    enum State {
        case empty
        case monetization
    }
}

private extension String {
    static let exploreMore = "HealthProgressWidget.exploreMore".localized(bundle: .module)
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 20
    static let spacing: CGFloat = 16
    static let verticalPadding: CGFloat = 20
    static let exploreTopPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 20
    static let emptyViewBottomPadding: CGFloat = 8
}

#Preview {
    ZStack {
        Color.red
        HealthProgressWidgetView(input: .weight, isEmptyState: false, isMonetization: true, output: { _ in }) {
            Text("Hello world!")
        }
    }
}
