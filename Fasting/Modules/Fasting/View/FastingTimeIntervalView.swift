//
//  FastingTimeIntervalView.swift
//  Fasting
//
//  Created by Amakhin Ivan on 20.11.2023.
//

import SwiftUI

struct FastingTimeIntervalView: View {
    var timeInterval: TimeInterval

    var body: some View {
        HStack(spacing: 0) {
            MonoSpacedView(digit: timeInterval.toHours[0])
            MonoSpacedView(digit: timeInterval.toHours[1])

            Text(":")
                .font(.poppins(.accentS))

            MonoSpacedView(digit: timeInterval.toMinutes[0])
            MonoSpacedView(digit: timeInterval.toMinutes[1])

            Text(":")
                .font(.poppins(.accentS))

            MonoSpacedView(digit: timeInterval.toSeconds[0])
            MonoSpacedView(digit: timeInterval.toSeconds[1])
        }
        .withoutAnimation()
    }
}

#Preview {
    FastingTimeIntervalView(timeInterval: .day)
}
