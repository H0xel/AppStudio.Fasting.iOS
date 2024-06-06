//
//  IntercomServiceImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 25.08.2023.
//

// swiftlint:disable orphaned_doc_comment
// swiftlint:disable comment_spacing

/// INTERCOM: DISABLED!!!
/// To connect an intercom,
///  1) Install SPM Package for Intercom
///  2) Uncomment class IntercomServiceImpl and comment out mocking class

import Combine
import Intercom
import Dependencies

class IntercomServiceImpl: ServiceBaseImpl, IntercomService {
    @Dependency(\.intercomUpdater) private var intercomUpdater
    @Dependency(\.intercomDataStorage) private var intercomDataStorage
    @Dependency(\.newSubscriptionService) private var subscriptionService
    @Dependency(\.obfuscator) private var obfuscator
    @Published private var hasSubscription = false
    private let obfuscatedAppId = GlobalConstants.intercomObfuscatedAppId
    private let obfuscatedApiKey = GlobalConstants.intercomObfuscatedApiKey

    func initialize() {
        subscriptionService.hasSubscription.assign(to: &$hasSubscription)

        setupApiKey()
    }

    func presentIntercom() -> AnyPublisher<Void, Never> {
        configureIntercom()
            .first()
            .receive(on: DispatchQueue.main)
            .map { _ in
                Intercom.present()
            }
            .eraseToAnyPublisher()
    }

    func hideIntercom() {
        Intercom.hide()
    }

    private func setupApiKey() {
        let appId = obfuscator.reveal(key: obfuscatedAppId)
        let apiKey = obfuscator.reveal(key: obfuscatedApiKey)
        DispatchQueue.main.async {
            Intercom.setApiKey(apiKey, forAppId: appId)
        }
    }

    private func configureIntercom() -> AnyPublisher<Void, Never> {
        registerIntercomUser()
            .map { [unowned self] in
                self.intercomUpdater.updateUser(businessName: "",
                                                paidSubscription: self.hasSubscription)
            }
            .eraseToAnyPublisher()
    }

    private func registerIntercomUser() -> AnyPublisher<Void, Never> {
        intercomDataStorage.intercomData
            .receive(on: DispatchQueue.main)
            .compactMap { $0 }
            .map { [unowned self] intercomData in
                self.setIntercomData(intercomData: intercomData)
            }
            .eraseToAnyPublisher()
    }

    private func setIntercomData(intercomData: IntercomData) {
        intercomUpdater.registerUser(withUserId: intercomData.userId)
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
            "<APPSTUDIO_APPNAME>": true
        ]
        Intercom.updateUser(with: userAttributes)
    }
}

// swiftlint:enable orphaned_doc_comment
// swiftlint:enable comment_spacing
// swiftlint:enable mark
// swiftlint:enable orphaned_doc_comment
// swiftlint:enable comment_spacing
