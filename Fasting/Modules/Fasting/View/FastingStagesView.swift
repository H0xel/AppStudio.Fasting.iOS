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

    let currentStage: FastingStage?
    @State private var openedStage: FastingStage?

    var body: some View {
        ScrollViewWithReader(axis: .horizontal, showIndicators: false) { proxy in
            HStack(spacing: 4) {
                Spacer(minLength: Layout.horizontalPadding)
                ForEach(FastingStage.allCases, id: \.self) { stage in
                    Button(action: {
                        updateStage(stage: stage, proxy: proxy)
                    }, label: {
                        HStack {
                            image(for: stage)
                            title(for: stage)
                        }
                        .id(stage)
                        .padding(Layout.padding)
                        .border(configuration: borderConfiguration(for: stage))
                        .background(stage == currentStage ? stage.backgroundColor : nil)
                        .continiousCornerRadius(Layout.cornerRadius)
                    })
                }
                Spacer(minLength: Layout.horizontalPadding)
            }
            .onAppear {
                if let currentStage {
                    updateStage(stage: currentStage, proxy: proxy)
                }
            }
            .onChange(of: currentStage?.rawValue) { newValue in
                if let newValue, let stage = FastingStage(rawValue: newValue) {
                    updateStage(stage: stage, proxy: proxy)
                } else {
                    openedStage = nil
                }
            }
        }
    }

    private func image(for stage: FastingStage) -> Image {
        if stage == currentStage {
            stage.whiteImage
        } else if let currentStage, stage < currentStage {
            stage.coloredImage
        } else {
            stage.disabledImage
        }
    }

    private func borderConfiguration(for stage: FastingStage) -> BorderConfiguration {
        stage == currentStage ? .empty : .init(cornerRadius: Layout.cornerRadius, color: .fastingGreyStrokeFill)
    }

    private func updateStage(stage: FastingStage, proxy: ScrollViewProxy) {
        openedStage = openedStage == stage ? nil : stage
        withAnimation(.fastingStageChage) {
            proxy.scrollTo(openedStage ?? currentStage, anchor: .center)
        }
    }

    @ViewBuilder
    private func title(for stage: FastingStage) -> some View {
        if stage == currentStage || stage == openedStage {
            Text(stage.title)
                .foregroundStyle(stage == currentStage ? .white : .accentColor)
                .transition(
                    .asymmetric(
                        insertion: .move(edge: .leading),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    )
                )
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
