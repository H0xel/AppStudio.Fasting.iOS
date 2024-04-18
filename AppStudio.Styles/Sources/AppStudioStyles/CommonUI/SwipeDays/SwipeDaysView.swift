//
//  SwipeDaysView.swift
//  
//
//  Created by Руслан Сафаргалеев on 11.03.2024.
//

import SwiftUI

public struct SwipeDaysView<Content: View>: View {

    @StateObject private var viewModel: SwipeDaysViewModel
    private let content: (_ tabDate: Date, _ currentDate: Date) -> Content

    public init(viewModel: SwipeDaysViewModel,
                content: @escaping (_ tabDate: Date, _ currentDate: Date) -> Content) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.content = content
    }

    public var body: some View {
        TabView(selection: $viewModel.currentDay) {
            ForEach(viewModel.displayDays, id: \.self) { day in
                content(day, viewModel.currentDay)
            }
        }
        .animation(nil, value: viewModel.displayDays)
        .animation(nil, value: viewModel.currentDay)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

#Preview {
    SwipeDaysView(viewModel: .init(isFutureAllowed: false)) { date, _  in
        Text(date.description)
    }
}
