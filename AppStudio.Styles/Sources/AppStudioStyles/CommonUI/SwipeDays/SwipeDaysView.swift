//
//  SwipeDaysView.swift
//  
//
//  Created by Руслан Сафаргалеев on 11.03.2024.
//

import SwiftUI

public struct SwipeDaysView<Content: View>: View {

    @StateObject private var viewModel: SwipeDaysViewModel
    private let content: (Date) -> Content

    public init(viewModel: SwipeDaysViewModel,
                content: @escaping (Date) -> Content) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.content = content
    }

    public var body: some View {
        TabView(selection: $viewModel.currentDay) {
            ForEach(viewModel.displayDays, id: \.self) { day in
                content(day)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    SwipeDaysView(viewModel: .init(isFutureAllowed: false)) { date in
        Text(date.description)
    }
}
