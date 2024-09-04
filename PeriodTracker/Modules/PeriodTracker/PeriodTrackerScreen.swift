//
//  PeriodTrackerScreen.swift
//  PeriodTracker
//
//  Created by Руслан Сафаргалеев on 04.09.2024.
//

import SwiftUI

struct PeriodTrackerScreen: View {

    @StateObject var viewModel: PeriodTrackerViewModel

    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    PeriodTrackerScreen(viewModel: .init(router: .init(navigator: .init()),
                                         input: .init(),
                                         output: { _ in }))
}
