//
//  DebugMenuNutritionProfile.swift
//  CalorieCounter
//
//  Created by Руслан Сафаргалеев on 19.01.2024.
//

import SwiftUI
import Dependencies

struct DebugMenuNutritionProfile: View {

    @Dependency(\.userDataService) private var userDataService
    @Environment(\.dismiss) private var dismiss

    @State private var calories = ""
    @State private var protein = ""
    @State private var carbs = ""
    @State private var fats = ""
    @State private var date: Date = .now

    var body: some View {
        Section {
            HStack {
                Text("Calories amount")
                TextField("", text: $calories, prompt: Text("0"))
            }
            HStack {
                Text("Protein amount")
                TextField("", text: $protein, prompt: Text("0"))
            }
            HStack {
                Text("Carbs amount")
                TextField("", text: $carbs, prompt: Text("0"))
            }
            HStack {
                Text("Fats amount")
                TextField("", text: $fats, prompt: Text("0"))
            }
            DatePicker("Profile start date", selection: $date, displayedComponents: .date)
            Button(action: {
                createProfile()
            }, label: {
                Text("Create")
                    .foregroundStyle(.blue)
            })
        }
        .keyboardType(.numberPad)
    }

    private func createProfile() {
        Task {
            let profile = NutritionProfile(calories: .init(calories) ?? 0,
                                           proteins: .init(protein) ?? 0,
                                           fats: .init(fats) ?? 0,
                                           carbohydrates: .init(carbs) ?? 0)
            _ = try await userDataService.save(date: date, profile: profile)
            await MainActor.run {
                dismiss()
            }
        }
    }
}

#Preview {
    List {
        DebugMenuNutritionProfile()
    }
}
