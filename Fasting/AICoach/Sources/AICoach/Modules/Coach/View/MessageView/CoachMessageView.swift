//
//  CoachMessageView.swift
//  Fasting
//
//  Created by Руслан Сафаргалеев on 15.02.2024.
//

import SwiftUI

struct CoachMessageView: View {

    let message: CoachMessage

    var body: some View {
        switch message.sender {
        case .coach:
            CoachSenderMessageView(message: message)
        case .user:
            UserSenderMessageView(message: message)
        }
    }
}

#Preview {
    ZStack {
        VStack {
            CoachMessageView(message: .mockCoach())
            CoachMessageView(message: .mockUser())
        }
    }
}
