//
//  BottomActionSheetConfiguration.swift
//
//
//  Created by Amakhin Ivan on 10.07.2024.
//

import SwiftUI

public struct BottomActionSheetConfiguration: Equatable {
    let title: String
    let subtitle: String?
    let leftButtonTitle: String
    let rightButtonTitle: String

    public init(title: String,
                subtitle: String?,
                leftButtonTitle: String,
                rightButtonTitle: String) {
        self.title = title
        self.subtitle = subtitle
        self.leftButtonTitle = leftButtonTitle
        self.rightButtonTitle = rightButtonTitle
    }
}

public extension BottomActionSheetConfiguration {
    static var discardChanges: BottomActionSheetConfiguration {
        .init(title: "BottomActionSheetConfiguration.discard.title".localized(bundle: .module),
              subtitle: "BottomActionSheetConfiguration.discard.subtitle".localized(bundle: .module),
              leftButtonTitle: "BottomActionSheetConfiguration.discard.leftButtonTitle".localized(bundle: .module),
              rightButtonTitle: "BottomActionSheetConfiguration.discard.rightButtonTitle".localized(bundle: .module))
    }

    static var deleteBarcode: BottomActionSheetConfiguration {
        .init(title: "BottomActionSheetConfiguration.barcode.title".localized(bundle: .module),
              subtitle: nil,
              leftButtonTitle: "BottomActionSheetConfiguration.barcode.leftButtonTitle".localized(bundle: .module),
              rightButtonTitle: "BottomActionSheetConfiguration.barcode.rightButtonTitle".localized(bundle: .module))
    }
}
