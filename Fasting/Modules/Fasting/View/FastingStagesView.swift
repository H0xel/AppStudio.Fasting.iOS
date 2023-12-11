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

    let stages: [FastingStage]
    let currentStage: FastingStage?
    let hasSubscription: Bool
    let onTap: (FastingStage) -> Void


    var body: some View {
        GeometryReader { geometry in
            ScrollViewWithReader(axis: .horizontal, showIndicators: false) { proxy in
                HStack(spacing: 4) {
                    Spacer(minLength: Layout.horizontalPadding)
                    ForEach(stages, id: \.self) { stage in
                        Button(action: {
                            onTap(stage)
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
                .frame(minWidth: geometry.size.width)
                .onAppear {
                    if let currentStage {
                        withAnimation(.bouncy) {
                            proxy.scrollTo(currentStage, anchor: .center)
                        }
                    }
                }
                .onChange(of: currentStage?.rawValue) { newValue in
                    if let newValue, let stage = FastingStage(rawValue: newValue) {
                        withAnimation(.bouncy) {
                            proxy.scrollTo(stage, anchor: .center)
                        }
                    }
                }
            }
        }
        .frame(height: Layout.height)
    }

    @ViewBuilder
    private func image(for stage: FastingStage) -> some View {
        if hasSubscription {
            unlockedImage(for: stage)
        } else {
            lockedImage(for: stage)
        }
    }

    @ViewBuilder
    private func lockedImage(for stage: FastingStage) -> some View {
        if stage == .sugarRises {
            if currentStage == stage {
                stage.whiteImage
            } else {
                stage.coloredImage
            }
        } else {
            Image.lockFill
                .foregroundStyle(stage == currentStage ? .white : stage.backgroundColor)
                .font(.poppins(.headerS))
        }
    }

    @ViewBuilder
    private func unlockedImage(for stage: FastingStage) -> some View {
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

    @ViewBuilder
    private func title(for stage: FastingStage) -> some View {
        if stage == currentStage {
            Text(hasSubscription || stage == .sugarRises ? stage.title : Localization.title(for: stage))
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
        static var horizontalPadding: CGFloat = 25
        static let cornerRadius: CGFloat = 26
        static let padding: CGFloat = 14
        static let height: CGFloat = 52
    }

    enum Localization {
        static func title(for stage: FastingStage) -> String {
            NSLocalizedString("FastingPhase.\(stage.rawValue).locked", comment: "")
        }
    }
}

#Preview {
    VStack {
        FastingStagesView(stages: FastingStage.allCases,
                          currentStage: nil,
                          hasSubscription: false) { _ in }
        FastingStagesView(stages: FastingStage.allCases.filter { $0 != .autophagy },
                          currentStage: nil,
                          hasSubscription: false) { _ in }
    }
}
