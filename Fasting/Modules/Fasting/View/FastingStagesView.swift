//
//  FastingStagesView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 27.10.2023.
//

import SwiftUI
import AppStudioUI
import AppStudioNavigation

struct FastingStagesView: View {

    @State var currentStage: FastingStage?

    var body: some View {
        ScrollViewWithReader(axis: .horizontal, showIndicators: false) { proxy in
            HStack(spacing: 4) {
                Spacer(minLength: Layout.horizontalPadding)
                ForEach(FastingStage.allCases, id: \.self) { stage in
                    Button(action: {
                        updateStage(stage: stage, proxy: proxy)
                    }, label: {
                        HStack {
                            stage.whiteImage
                            if stage == currentStage {
                                Text(stage.rawValue)
                                    .foregroundStyle(.white)
                                    .transition(
                                        .asymmetric(
                                            insertion: .move(edge: .leading),
                                            removal: .move(edge: .leading).combined(with: .opacity)
                                        )
                                    )
                            }
                        }
                        .padding(Layout.padding)
                        .id(stage)

                        //                            .border(configuration: .init(cornerRadius: Layout.cornerRadius, color: .greyStrokeFill))
                            .background(stage.backgroundColor)
                            .continiousCornerRadius(Layout.cornerRadius)
                    })
                }
                Spacer(minLength: Layout.horizontalPadding)
            }
        }
    }

    private func updateStage(stage: FastingStage, proxy: ScrollViewProxy) {
        withAnimation(.easeInOut(duration: 0.3)) {
            currentStage = currentStage == stage ? nil : stage
            proxy.scrollTo(stage, anchor: .center)
        }
    }
}

private extension FastingStagesView {
    enum Layout {
        static let horizontalPadding: CGFloat = 25
        static let cornerRadius: CGFloat = 26
        static let padding: CGFloat = 14
    }
}

#Preview {
    let viewModel = FastingViewModel(input: .init(), output: { _ in })
    viewModel.router = .init(navigator: .init())
    return ModernNavigationView {
        FastingScreen(viewModel: viewModel)
    }
}
