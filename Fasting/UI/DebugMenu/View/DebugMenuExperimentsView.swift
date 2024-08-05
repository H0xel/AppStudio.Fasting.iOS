//
//  DebugMenuExperimentsView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 20.02.2024.
//

import SwiftUI
import AppStudioABTesting
import Dependencies

struct DebugMenuExperimentsView: View {
    @Dependency(\.appCustomization) private var appCustomization
    private let baseAppCustomization = BaseAppCustomization()
    @State private var experiments: [DebugExperiment] = []

    var body: some View {
        Section("Experiments") {
            ForEach(experiments) { experiment in
                Text("Experiment: \(experiment.experimentName) \nValue: \(experiment.value)")
            }

            Button("Reset pricing experiment") {
                appCustomization.resetPricingExp()
            }
            .foregroundColor(.blue)

            Button("Reset discount experiment") {
                appCustomization.resetDiscountExp()
            }
            .foregroundColor(.blue)
        }
        .task {
            Task {
                let pricingExperimentValue = try await baseAppCustomization.remoteConfigValue(
                    forKey: "exp_pricing_active",
                    defaultValue: "non in experiment")

                experiments.append(.init(experimentName: "exp_pricing_active",
                                         value: pricingExperimentValue.isEmpty
                                         ? "pricing_default"
                                         : pricingExperimentValue))

                let discountExperimentValue = try await baseAppCustomization.remoteConfigValue(
                    forKey: "discount_active",
                    defaultValue: "non in experiment"
                )
                experiments.append(.init(experimentName: "discount_active", value: discountExperimentValue))

                let discExp = try await baseAppCustomization.remoteConfigValue(
                    forKey: String(discountExperimentValue.dropFirst()),
                    defaultValue: "non in experiment"
                )
                experiments.append(.init(experimentName: discountExperimentValue,
                                         value: discExp))
            }
        }
    }
}

#Preview {
    DebugMenuExperimentsView()
}


private struct DebugExperiment: Identifiable {
    let id = UUID().uuidString
    let experimentName: String
    let value: String
}
