//
//  Contexts.swift
//  Fasting
//
//  Created by Amakhin Ivan on 10.11.2023.
//

import AppStudioAnalytics

extension ChooseFastingPlanInput.Context: TrackerParam {
    var description: String {
        return self.rawValue
    }
}

extension FastingStagesContext: TrackerParam {
    var description: String {
        rawValue
    }
}

extension AnalyticEventType: TrackerParam {
    var description: String {
        return self.rawValue
    }
}

extension FastingChangeTimeContext: TrackerParam {
    var description: String {
        return self.rawValue
    }
}

extension StartFastingInput.Context: TrackerParam {
    var description: String {
        return self.rawValue
    }
}
extension PaywallContext: TrackerParam {
    var description: String {
        return self.rawValue
    }
}
extension RestoreResult: TrackerParam {
    var description: String {
        return self.rawValue
    }
}
extension CancelFastingContext: TrackerParam {
    var description: String {
        return self.rawValue
    }
}
