//
//  MailSenderDependency.swift
//
//
//  Created by Amakhin Ivan on 13.03.2024.
//

import Dependencies

public extension DependencyValues {
    var mailSenderService: MailSenderService {
        self[MailSenderServiceKey.self]
    }
}

private enum MailSenderServiceKey: DependencyKey {
    static var liveValue = MailSenderServiceImpl()
}

