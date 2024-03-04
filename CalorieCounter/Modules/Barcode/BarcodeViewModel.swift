//  
//  BarcodeViewModel.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 28.12.2023.
//

import AppStudioNavigation
import AppStudioUI
import SwiftUI

class BarcodeViewModel: BaseViewModel<BarcodeOutput> {
    @Published var barcode = ""
    var router: BarcodeRouter!

    init(input: BarcodeInput, output: @escaping BarcodeOutputBlock) {
        super.init(output: output)
    }

    func updateBarCode(_ code: String) {
        // Remove first zero
        let code = code.first == "0" ? String(code.suffix(code.count - 1)) : code
        barcode = code
        output(.barcode(barcode))
    }

    func close() {
        output(.close)
    }
}
