//
//  CustomFoodBarCodeView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 09.07.2024.
//

import SwiftUI

struct CustomFoodBarCodeView: View {
    let viewState: ViewState
    var action: (Action) -> Void

    var body: some View {

        VStack(spacing: .zero) {
            switch viewState {
            case .barcodeAdded(let barcode):
                VStack(spacing: .zero) {
                    BarcodeImageView(data: barcode, height: .barcodeHeight)
                        .padding(.bottom, .barcodeImageBottomPadding)
                    HStack(spacing: .zero) {
                        Button(action: {
                            action(.replace)
                        }, label: {
                            Image(.barcode)
                            Text("CustomFood.replace")
                        })
                        .padding(.vertical, .barcodeAddedButtonVerticalPadding)
                        .padding(.horizontal, .barcodeAddedButtonHorizontalPadding)

                        Button(action: {
                            action(.delete)
                        }, label: {
                            Image(.bannerTrash)
                            Text("CustomFood.delete")
                        })
                        .padding(.vertical, .barcodeAddedButtonVerticalPadding)
                        .padding(.horizontal, .barcodeAddedButtonHorizontalPadding)
                    }
                    .foregroundStyle(Color.studioBlackLight)
                    .font(.poppinsMedium(.description))
                }
                .aligned(.centerHorizontaly)
                .padding(.vertical, .barcodeAddedVerticalPadding)
            case .addBarcode:
                HStack(spacing: .addBarcodeSpacing) {
                    Image(.barcode)
                    Text("CustomFood.addBarcode")
                        .font(.poppinsMedium(.description))
                }
                .aligned(.centerHorizontaly)
                .padding(.vertical, .addBarcodeVerticalPAdding)
            }
        }
        .background()
        .borderDashed(configuration: .default)
        .continiousCornerRadius(.cornerRadius)
        .onTapGesture {
            if case .addBarcode = viewState {
                action(.openBarcodeScanner)
            }
        }
    }
}

private extension CGFloat {
    static let addBarcodeVerticalPAdding: CGFloat = 40
    static let addBarcodeSpacing: CGFloat = 8

    static let barcodeAddedButtonVerticalPadding: CGFloat = 4
    static let barcodeAddedButtonHorizontalPadding: CGFloat = 32
    static let barcodeAddedVerticalPadding: CGFloat = 24
    static let barcodeImageBottomPadding: CGFloat = 16
    static let cornerRadius: CGFloat = 20
    static let barcodeHeight: CGFloat = 80
}

extension CustomFoodBarCodeView {
    enum Action {
        case openBarcodeScanner
        case replace
        case delete
    }

    enum ViewState {
        case barcodeAdded(barcode: String)
        case addBarcode
    }
}

#Preview {
    CustomFoodBarCodeView(viewState: .barcodeAdded(barcode: "123123123"), action: { _ in })
        .padding(.horizontal, 16)
}
