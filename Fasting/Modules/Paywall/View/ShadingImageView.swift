//
//  PaywallImageView.swift
//  Mileage.iOS
//
//  Created by Руслан Сафаргалеев on 04.08.2023.
//

import SwiftUI

struct ShadingImageView: View {

    let image: Image

    var body: some View {
        image
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

private extension ShadingImageView {
    enum Layout {
        static let shadingHeight: CGFloat = 70
    }
}

struct PaywallImageView_Previews: PreviewProvider {
    static var previews: some View {
        ShadingImageView(image: .paywall)
    }
}
