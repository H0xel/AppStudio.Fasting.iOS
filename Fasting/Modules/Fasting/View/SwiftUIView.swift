//
//  SwiftUIView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 30.10.2023.
//

import SwiftUI

struct SwiftUIView: View {

    let status: FastingStatus

    var body: some View {
        switch status {
        case .active(let fastingActiveState):
            EmptyView()
        case .inActive(let inActiveFastingStage):
            switch inActiveFastingStage {
            case .left(let timeInterval):
                EmptyView()
            case .expired:
                EmptyView()
            }
        }
    }
}

#Preview {
    SwiftUIView(status: .active(.init(interval: 10, stage: .autophagy, isFinished: false)))
}
