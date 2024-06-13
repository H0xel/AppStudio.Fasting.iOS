//
//  ProfileLoginedView.swift
//
//
//  Created by Amakhin Ivan on 06.06.2024.
//

import SwiftUI

public struct ProfileLoginedView: View {

    private let title: String

    public init(title: String) {
        self.title = title
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: .spacing) {
            Text(title)
                .font(.poppins(.body))
                .foregroundStyle(Color.studioBlackLight)
            Text("W2W.profile.linkedEmail")
                .font(.poppins(.description))
                .foregroundStyle(Color.studioGreyText)
        }
        .aligned(.left)
        .padding(.leading, .leadingPadding)
        .padding(.vertical, .verticalPadding)
    }
}

private extension CGFloat {
    static let spacing: CGFloat = 4
    static let leadingPadding: CGFloat = 20
    static let verticalPadding: CGFloat = 16
}
