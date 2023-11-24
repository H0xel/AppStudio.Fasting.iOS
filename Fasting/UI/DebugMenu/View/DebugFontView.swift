//
//  DebugFontView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 20.11.2023.
//

import SwiftUI

struct DebugFontView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                Text("AccentL")
                    .font(.poppins(.accentL))
                    .border(configuration: .init(cornerRadius: 0, color: Color.red))
                Text("Accent S")
                    .font(.poppins(.accentS))
                    .border(configuration: .init(cornerRadius: 0, color: Color.red))
                Text("Header L")
                    .font(.poppins(.headerL))
                    .border(configuration: .init(cornerRadius: 0, color: Color.red))
                Text("Header M")
                    .font(.poppins(.headerM))
                    .border(configuration: .init(cornerRadius: 0, color: Color.red))
                Text("Header S")
                    .font(.poppins(.headerS))
                    .border(configuration: .init(cornerRadius: 0, color: Color.red))
                Text("Button text")
                    .font(.poppins(.headerS))
                    .border(configuration: .init(cornerRadius: 0, color: Color.red))
                Text("Body")
                    .font(.poppins(.body))
                    .border(configuration: .init(cornerRadius: 0, color: Color.red))
                Text("Description")
                    .font(.poppins(.description))
                    .border(configuration: .init(cornerRadius: 0, color: Color.red))
            }
        }
    }
}

#Preview {
    DebugFontView()
}
