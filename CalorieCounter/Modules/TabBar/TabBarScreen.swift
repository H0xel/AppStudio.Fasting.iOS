//  
//  TabBarScreen.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 10.01.2024.
//

import SwiftUI
import AppStudioNavigation

enum AppTab: String {
    case counter = "food_log"
    case settings = "profile"
}

struct TabBarScreen: View {

    @StateObject var viewModel: TabBarViewModel

    var body: some View {
        VStack(spacing: .zero) {
            currentScreen
            if viewModel.isTabBarPresented {
                tabBar
            }
        }
    }

    @ViewBuilder
    var currentScreen: some View {
        switch viewModel.activeTab {
        case .counter:
            viewModel.foodScreen
        case .settings:
            viewModel.settingsScreen
        }
    }

    private var tabBar: some View {
        HStack {
            Spacer()
            Button(action: {
                viewModel.changeTab(to: .counter)
            }, label: {
                Image(viewModel.activeTab == .counter ? .tabBarCounterActive : .tabBarCounterInActive)
            })

            Spacer()
            TabBarAddButton(onTap: viewModel.addMeal)
                .padding(.vertical, .verticalPadding)
            Spacer()
            Button(action: {
                viewModel.changeTab(to: .settings)
            }, label: {
                Image.personFill
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: .settingsImageWidth, height: .settingsImageHeight)
                    .foregroundStyle(viewModel.activeTab == .settings ? .accent : .studioGreyStrokeFill)
            })
            Spacer()
        }
        .background(.white)
    }
}

private extension CGFloat {
    static let settingsImageWidth: CGFloat = 22
    static let settingsImageHeight: CGFloat = 20
    static let verticalPadding: CGFloat = 8
}

struct TabBarScreen_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.red
            TabBarScreen(
                viewModel: TabBarViewModel(
                    input: TabBarInput(),
                    output: { _ in }
                )
            )
        }
    }
}
