//
//  DebugMenuScreen.swift
//  Fasting
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
