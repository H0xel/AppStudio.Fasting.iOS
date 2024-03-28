//
//  WaterCounterWidgetRouter.swift
//  
//
//  Created by Denis Khlopin on 19.03.2024.
//

import Foundation
import SwiftUI
import AppStudioNavigation

public class WaterCounterWidgetRouter: BaseRouter {
    public override init(navigator: Navigator) {
        super.init(navigator: navigator)
    }

    func presentSettings(output: @escaping WaterCounterSettingsOutputBlock) {
        let route = WaterCounterSettingsRoute(navigator: navigator, output: output)
        navigator.present(sheet: route, detents: [.height(415)], showIndicator: true)        
    }

    func presentAddWaterEditor(units: WaterUnits,
                               predefinedValues: [DoubleValuePredefinedValue],
                               output: @escaping DoubleValueEditorOutputBlock) {
        let route = DoubleValueEditorRoute(
            navigator: navigator,
            input: .addWaterEditor(units: units, predefinedValues: predefinedValues),
            output: output
        )
        navigator.present(sheet: route, detents: [.medium], showIndicator: true)
    }
}

private extension DoubleValueEditorInput {
    static func addWaterEditor(units: WaterUnits, predefinedValues: [DoubleValuePredefinedValue]) -> DoubleValueEditorInput {
        .init(
            title: "WaterCounterWidget.addWaterEditor.title".localized(bundle: .module),
            description: nil,
            predefinedValues: predefinedValues,
            value: 0,
            unitsTitle: units.unitsTitle,
            buttonTitle: "WaterCounterWidget.addWaterEditor.buttonTitle".localized(bundle: .module),
            hasBackButton: false,
            textfieldType: units == .ounces ? .integer : .double(maxTail: 2)
        )
    }
}
