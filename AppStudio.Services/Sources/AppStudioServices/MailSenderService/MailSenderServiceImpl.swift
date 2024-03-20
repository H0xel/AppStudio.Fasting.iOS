//
//  MailSenderServiceImpl.swift
//  AppStudio
//
//  Created by Руслан Сафаргалеев on 14.06.2023.
//

import Dependencies
import Foundation

class MailSenderServiceImpl: MailSenderService {
    @Dependency(\.openURL) private var openURL

    func send(to email: String) async {
        if let url = URL(string: "mailto:\(email)") {
            await openURL(url)
        }
    }
}
