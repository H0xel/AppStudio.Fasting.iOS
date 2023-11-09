//  
//  FastingRouter.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 26.10.2023.
//

import SwiftUI
import AppStudioNavigation

class FastingRouter: BaseRouter {
    func presentStartFastingDialog(initialDate: Date, allowSelectFuture: Bool, onSave: @escaping (Date) -> Void) {
        let route = StartFastingRoute(navigator: navigator,
                                      input: .init(initialDate: initialDate,
                                                   allowSelectFuture: allowSelectFuture)) { event in
            switch event {
            case .save(let date):
                onSave(date)
            }
        }
        present(sheet: route, detents: [.height(484)], showIndicator: false)
    }
}
