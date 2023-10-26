//
//  PricingOngoingExperiment.swift
//  Scanner
//
//  Created by Александр Бочкарев on 09.09.2020.
//  Copyright © 2020 Scanner. All rights reserved.
//

import AppStudioABTesting
import Dependencies

typealias PricingExperimentValueCoder = JsonExperimentVariantCoder<SubscriptionInfo>

class PricingOngoingExperiment: AppStudioExperimentWithConfig<SubscriptionInfo> {

    init(experimentName: String) {
        let variantCoder = PricingExperimentValueCoder()
        super.init(defaultValue: .base,
                   nameProvider: BaseExperimentNameProvider(experimentName: experimentName),
                   stabilizingResolver: JSONStabilizingResolver<SubscriptionInfo>(variantCoder: variantCoder),
                   valueVerifier: RemoteConfigJsonValueVerifier<SubscriptionInfo>(variantCoder: variantCoder))
    }

    override var shouldCheckForOrganic: Bool {
        false
    }
}
