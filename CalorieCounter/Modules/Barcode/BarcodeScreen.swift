//  
//  BarcodeScreen.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 28.12.2023.
//

import SwiftUI
import AppStudioNavigation

struct BarcodeScreen: View {
    @StateObject var viewModel: BarcodeViewModel

    var body: some View {
        ZStack {
            BarcodeView { code in
                viewModel.updateBarCode(code)
            }
            .edgesIgnoringSafeArea(.all)

            Button(
                action: viewModel.close,
                label: {
                    Image.close
                        .foregroundStyle(Color.studioBlackLight)
                        .padding(Layout.buttonPadding)
                }
            )
            .aligned(.topRight)
        }
    }
}

// MARK: - Layout properties
private extension BarcodeScreen {
    enum Layout {
        static let buttonPadding: CGFloat = 16
    }
}

// MARK: - Localization
private extension BarcodeScreen {
    enum Localization {
        static let title: LocalizedStringKey = "BarcodeScreen"
    }
}

struct BarcodeScreen_Previews: PreviewProvider {
    static var previews: some View {
        BarcodeScreen(
            viewModel: BarcodeViewModel(
                input: BarcodeInput(),
                output: { _ in }
            )
        )
    }
}
