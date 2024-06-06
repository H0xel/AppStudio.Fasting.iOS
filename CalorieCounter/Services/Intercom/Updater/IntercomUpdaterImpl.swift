//
//  IntercomUpdaterImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 25.08.2023.
//
// swiftlint:disable orphaned_doc_comment
// swiftlint:disable comment_spacing
// swiftlint:disable mark

/// INTERCOM: DISABLED!!!
/// To connect an intercom,
///  1) Install SPM Package for Intercom
///  2) Uncomment class IntercomServiceImpl and comment out mocking class

import Intercom

class IntercomUpdaterImpl: IntercomUpdater {

    func setUserHash(_ hash: String) {
        Intercom.setUserHash(hash)
    }

    func registerUser(withUserId: String) {
        let userAttributes = ICMUserAttributes()
        userAttributes.userId = withUserId
        Intercom.loginUser(with: userAttributes)
    }

    func updateUser(businessName: String?, paidSubscription: Bool) {
        Intercom.updateUser(paidSubscription: paidSubscription, businessName: businessName)
    }
}

// MARK: - Intercom extension
private extension Intercom {
    static func updateUser(paidSubscription: Bool, businessName: String?) {
        let userAttributes = ICMUserAttributes()
        userAttributes.name = businessName
        userAttributes.customAttributes = [
            "Paid subscription": paidSubscription,
            "Is test": UIDevice.current.isSandbox,
            "Calorie Counter": true
        ]
        Intercom.updateUser(with: userAttributes)
    }
}

// swiftlint:enable orphaned_doc_comment
// swiftlint:enable comment_spacing
// swiftlint:enable mark
