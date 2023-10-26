//
//  IntercomUpdater.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 25.08.2023.
//

protocol IntercomUpdater {
    func registerUser(withUserId: String)
    func setUserHash(_ hash: String)
    func updateUser(businessName: String?, paidSubscription: Bool)
}
