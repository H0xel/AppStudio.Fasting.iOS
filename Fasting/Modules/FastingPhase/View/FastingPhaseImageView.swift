//
//  FastingPhaseImageView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 01.12.2023.
//

import SwiftUI
import AppStudioUI

struct FastingPhaseImageView: View {

    let currentStage: FastingStage
    let isLocked: Bool
    let onTap: (FastingStage) -> Void

    var body: some View {
        HStack(spacing: Layout.spacing) {
            ForEach(FastingStage.allCases, id: \.self) { stage in
                Button(action: {
                    onTap(stage)
                }, label: {
                    image(for: stage)
                        .frame(width: Layout.imageHeight, height: Layout.imageHeight)
                        .background {
                            stage == currentStage ? Color.white : nil
                        }
                        .continiousCornerRadius(Layout.imageHeight / 2)
                        .border(configuration: .init(cornerRadius: Layout.imageHeight / 2,
                                                     color: .white))
                })
            }
        }
    }

    @ViewBuilder
    private func image(for stage: FastingStage) -> some View {
        if isLocked {
            lockedImage(for: stage)
        } else {
            stage == currentStage ? stage.coloredImage : stage.whiteImage
        }
    }

    @ViewBuilder
    private func lockedImage(for stage: FastingStage) -> some View {
        if stage == .sugarRises {
            if currentStage == stage {
                stage.coloredImage
            } else {
                stage.whiteImage
            }
        } else {
            Image.lockFill
                .foregroundStyle(stage == currentStage ? stage.backgroundColor : .white)
                .font(.poppins(.headerS))
        }
    }
}

private extension FastingPhaseImageView {
    enum Layout {
        static let spacing: CGFloat = 2
        static let imageHeight: CGFloat = 52
    }
}

#Preview {
    ZStackWith(color: FastingStage.sugarRises.backgroundColor) {
        VStack {
            FastingPhaseImageView(currentStage: .sugarRises, isLocked: false) { _ in }
            FastingPhaseImageView(currentStage: .sugarNormal, isLocked: true) { _ in }
        }
    }
}
