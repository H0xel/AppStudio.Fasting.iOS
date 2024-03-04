//
//  DebugMenuScreen.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 20.10.2023.
//

import SwiftUI

struct DebugMenuScreen: View {

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            List {
                Section("Info") {
                    DebugMenuInfoView()
                }
                Section("Actions") {
                    DebugMenuActionsView()
                }

                DebugMenuExperimentsView()

                NavigationLink("Barcode scanner") {
                    BarcodeScreen(viewModel: .init(input: .init(), output: { _ in
                        presentationMode.wrappedValue.dismiss()
                    }))
                }

                Section("Calories Goal Date") {
                    DebugMenuNutritionProfile()
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            })
            .navigationTitle("Debug menu")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DebugMenuScreen()
}
