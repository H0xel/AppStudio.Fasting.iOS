//
//  TabBarView.swift
//  PeriodTracker
//
//  Created by Руслан Сафаргалеев on 04.09.2024.
//

import SwiftUI

struct TabBarView: View {

    @StateObject private var viewModel = TabBarViewModel()

    var body: some View {
        TabView(selection: $viewModel.currentTab) {
            Text("Nova")
                .tag(AppTab.nova)
                .tabItem {
                    tabBarLabelView(tab: .nova)
                }
            viewModel.trackerScreen
                .tag(AppTab.tracker)
                .tabItem {
                    tabBarLabelView(tab: .tracker)
                }
            Text("Calendar")
                .tag(AppTab.calendar)
                .tabItem {
                    tabBarLabelView(tab: .calendar)
                }
        }
    }

    private func tabBarLabelView(tab: AppTab) -> some View {
        Label(
            title: {
                Text(tab.title)
                    .font(.poppins(10))
                    .foregroundStyle(viewModel.currentTab == tab ? Color.studioBlueLight : .studioGreyPlaceholder)
            },
            icon: {
                tab.icon
                    .renderingMode(.template)
                    .foregroundStyle(viewModel.currentTab == tab ? Color.studioBlueLight : .studioGreyStrokeFill)
            }
        )
    }
}

#Preview {
    TabBarView()
}
