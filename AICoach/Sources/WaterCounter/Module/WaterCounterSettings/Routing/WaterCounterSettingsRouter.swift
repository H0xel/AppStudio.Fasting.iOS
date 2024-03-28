//  
//  WaterCounterSettingsRouter.swift
//  
//
//  Created by Denis Khlopin on 20.03.2024.
//

import SwiftUI
import AppStudioNavigation

class WaterCounterSettingsRouter: BaseRouter {

    func presentDaylyGoalEditor(value: Double, calcValue: String, units: WaterUnits, output: @escaping DoubleValueEditorOutputBlock) {
        let route = DoubleValueEditorRoute(
            navigator: navigator,
            input: .daylyGoalEditor(value: value,
                                    calcValue: calcValue,
                                    units: units),
            output: output
        )
        navigator.present(sheet: route, detents: [.height(390)], showIndicator: true)
    }

    func presentPrefferedVolumeEditor(value: Double, 
                                      units: WaterUnits,
                                      predefinedValues: [DoubleValuePredefinedValue],
                                      output: @escaping DoubleValueEditorOutputBlock) {
        let route = DoubleValueEditorRoute(
            navigator: navigator,
            input: .prefferedVolumeEditor(value: value, units: units, predefinedValues: predefinedValues),
            output: output
        )
        navigator.present(sheet: route, detents: [.medium], showIndicator: true)
    }

    func presentUnitsSelector(value: WaterUnits, output: @escaping ComboBoxEditorOutputBlock) {
        let route = ComboBoxEditorRoute(
            navigator: navigator,
            input: .selectUnitsEditor(unitsValue: value),
            output: output)
        navigator.present(sheet: route, detents: [.height(350)], showIndicator: true)
    }
}

private extension ComboBoxEditorInput {
    static func selectUnitsEditor(unitsValue: WaterUnits) -> ComboBoxEditorInput {
        .init(
            title: "Units",
            values: WaterUnits.allUnits.map { ComboBoxValue(title: $0.unitsGlobalFullTitle, value: $0.rawValue)},
            value: unitsValue.rawValue,
            buttonTitle: "Save"
        )
    }
}

private extension DoubleValueEditorInput {
    static func daylyGoalEditor(value: Double, calcValue: String, units: WaterUnits) -> DoubleValueEditorInput {
        .init(
            title: "WaterCounterSettings.goalEditor.title".localized(bundle: .module),
            description: String(format: "WaterCounterSettings.goalEditor.description".localized(bundle: .module),
                                calcValue,
                                units.unitsGlobalFullTitle.lowercased()),
            predefinedValues: nil,
            value: value,
            unitsTitle: units.unitsGlobalTitle,
            buttonTitle: "WaterCounterSettings.saveButton.title".localized(bundle: .module),
            hasBackButton: true, 
            textfieldType: units == .ounces ? .integer : .double(maxTail: 2)
        )
    }

    static func prefferedVolumeEditor(value: Double, units: WaterUnits, predefinedValues: [DoubleValuePredefinedValue]) -> DoubleValueEditorInput {
        .init(
            title: "WaterCounterSettings.prefferedVolume.title".localized(bundle: .module),
            description: nil,
            predefinedValues: predefinedValues,
            value: value,
            unitsTitle: units.unitsTitle,
            buttonTitle: "WaterCounterSettings.saveButton.title".localized(bundle: .module),
            hasBackButton: true,
            textfieldType: units == .ounces ? .integer : .integer
        )
    }
}
