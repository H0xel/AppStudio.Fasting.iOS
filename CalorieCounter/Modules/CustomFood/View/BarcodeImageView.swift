//
//  BarcodeImageView.swift
//  CalorieCounter
//
//  Created by Amakhin Ivan on 10.07.2024.
//

import SwiftUI
import CoreImage.CIFilterBuiltins

struct BarcodeImageView: View {
    let data: String
    let height: CGFloat

    var body: some View {
        Image(uiImage: generateBarcode(from: data))
            .resizable()
            .scaledToFit()
            .frame(height: height)
            .overlay {
                Text(data)
                    .font(.poppins(.description))
                    .background()
                    .aligned(.bottom)
            }
    }

    private func generateBarcode(from string: String, scale: CGFloat = 10.0) -> UIImage {
        let context = CIContext()
        let filter = CIFilter.code128BarcodeGenerator()

        let data = string.data(using: .ascii)
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: scale, y: scale))

            if let cgImage = context.createCGImage(scaledImage, from: scaledImage.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage()
    }
}

#Preview {
    BarcodeImageView(data: "8793124124", height: 80)
}
