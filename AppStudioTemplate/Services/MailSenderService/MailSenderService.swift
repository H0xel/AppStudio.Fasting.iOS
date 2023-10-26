//
//  MailSenderService.swift
//  AppStudio
//
//  Created by Руслан Сафаргалеев on 14.06.2023.
//

import Foundation

protocol MailSenderService {
    func send(to email: String) async
}
