//
//  DiscountPaywallExperiment.swift
//  Fasting
//
//  Created by Amakhin Ivan on 07.02.2024.
//

import AppStudioABTesting
import Dependencies

typealias DiscountPaywallExperimentValueCoder = JsonExperimentVariantCoder<DiscountPaywallInfo>

class DiscountPaywallExperiment: AppStudioExperimentWithConfig<DiscountPaywallInfo> {

    init(experimentName: String) {
        let variantCoder = DiscountPaywallExperimentValueCoder()
        super.init(defaultValue: .empty,
                   nameProvider: BaseExperimentNameProvider(experimentName: experimentName),
                   stabilizingResolver: JSONStabilizingResolver<DiscountPaywallInfo>(variantCoder: variantCoder),
                   valueVerifier: RemoteConfigJsonValueVerifier<DiscountPaywallInfo>(variantCoder: variantCoder))
    }

    override var shouldCheckForOrganic: Bool {
        false
    }
}
