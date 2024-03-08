//  
//  HealthOverviewScreen.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 06.03.2024.
//

import SwiftUI
import AppStudioNavigation
import AppStudioStyles

struct HealthOverviewScreen: View {
    @StateObject var viewModel: HealthOverviewViewModel

    var body: some View {
        ScrollView {
            Spacer(minLength: .verticalSpacing)
            FastingWidgetView(state: .mockInActive)
            Spacer(minLength: .verticalSpacing)
        }
        .scrollIndicators(.hidden)
        .padding(.horizontal, .horizontalPadding)
        .background(Color.studioGreyFillProgress)
    }
}

private extension CGFloat {
    static let horizontalPadding: CGFloat = 16
    static let verticalSpacing: CGFloat = 16
}

struct HealthOverviewScreen_Previews: PreviewProvider {
    static var previews: some View {
        HealthOverviewScreen(
            viewModel: HealthOverviewViewModel(
                input: HealthOverviewInput(),
                output: { _ in }
            )
        )
    }
}
