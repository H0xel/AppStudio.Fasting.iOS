//
//  FastingWidgetView.swift
//  
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI

struct FastingWidgetView: View {

    let state: FastingWidgetState

    var body: some View {
        switch state {
        case .active(let state):
            ActiveFastingWidgetView(state: state)
        case .inactive(let state):
            InActiveFastingWidgetView(state: state)
        }
    }
}

#Preview {
    FastingWidgetView(state: .mockInActive)
}
