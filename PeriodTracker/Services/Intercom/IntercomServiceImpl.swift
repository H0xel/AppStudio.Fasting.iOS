//
//  IntercomServiceImpl.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 25.08.2023.
//
import Combine

/// Mock class for Intercom
class IntercomServiceImpl: IntercomService {
    func initialize() {}
    func presentIntercom() -> AnyPublisher<Void, Never> {
        Empty().eraseToAnyPublisher()
    }
}

// swiftlint:disable orphaned_doc_comment
// swiftlint:disable comment_spacing

/// INTERCOM: DISABLED!!!
/// To connect an intercom,
///  1) Install SPM Package for Intercom
///  2) Uncomment class IntercomServiceImpl and comment out mocking class

//import RxSwift
//import Intercom
//import Dependencies
//
//class IntercomServiceImpl: ServiceBaseImpl, IntercomService {
//    @Dependency(\.intercomUpdater) private var intercomUpdater
//    @Dependency(\.intercomDataStorage) private var intercomDataStorage
//    @Dependency(\.subscriptionService) private var subscriptionService
//    @Dependency(\.businessAccountProvider) private var businessAccountProvider
//    @Dependency(\.obfuscator) private var obfuscator
//    private var isPaidSubscription = false
//    private let disposeBag = DisposeBag()
//    private let obfuscatedAppId = GlobalConstants.intercomObfuscatedAppId
//    private let obfuscatedApiKey = GlobalConstants.intercomObfuscatedApiKey
//
//    func initialize() {
//        subscriptionService.actualSubscription
//            .subscribe(with: self) { this, actualSubscription in
//                this.isPaidSubscription = actualSubscription.isUnlimited
//            }
//            .disposed(by: disposeBag)
//
//        setupApiKey()
//    }
//
//    func presentIntercom() -> AnyPublisher<Void, Never> {
//        configureIntercom()
//            .first()
//            .receive(on: DispatchQueue.main)
//            .map { _ in
//                Intercom.present()
//            }
//            .eraseToAnyPublisher()
//    }
//
//    private func setupApiKey() {
//        let appId = obfuscator.reveal(key: obfuscatedAppId)
//        let apiKey = obfuscator.reveal(key: obfuscatedApiKey)
//        DispatchQueue.main.async {
//            Intercom.setApiKey(apiKey, forAppId: appId)
//        }
//    }
//
//    private func configureIntercom() -> AnyPublisher<Void, Never> {
//        registerIntercomUser()
//            .compactMap { [unowned self] in
//                self.businessAccountProvider.currentAccount?.businessName
//            }
//            .map { [unowned self] in
//                self.intercomUpdater.updateUser(businessName: $0,
//                                                paidSubscription: self.isPaidSubscription)
//            }
//            .eraseToAnyPublisher()
//    }
//
//    private func registerIntercomUser() -> AnyPublisher<Void, Never> {
//        intercomDataStorage.intercomData
//            .receive(on: DispatchQueue.main)
//            .compactMap { $0 }
//            .map { [unowned self] intercomData in
//                self.setIntercomData(intercomData: intercomData)
//            }
//            .eraseToAnyPublisher()
//    }
//
//    private func setIntercomData(intercomData: IntercomData) {
//        intercomUpdater.setUserHash(intercomData.hash)
//        intercomUpdater.registerUser(withUserId: intercomData.userId)
//    }
//
//    func setUserHash(_ hash: String) {
//        Intercom.setUserHash(hash)
//    }
//
//    func registerUser(withUserId: String) {
//        let userAttributes = ICMUserAttributes()
//        userAttributes.userId = withUserId
//        Intercom.loginUser(with: userAttributes)
//    }
//
//    func updateUser(businessName: String?, paidSubscription: Bool) {
//        Intercom.updateUser(paidSubscription: paidSubscription, businessName: businessName)
//    }
//}
//
//// MARK: - Intercom extension
//private extension Intercom {
//    static func updateUser(paidSubscription: Bool, businessName: String?) {
//        let userAttributes = ICMUserAttributes()
//        userAttributes.name = businessName
//        userAttributes.customAttributes = [
//            "Paid subscription": paidSubscription,
//            "Is test": UIDevice.current.isSandbox,
//            "<APPSTUDIO_APPNAME>": true
//        ]
//        Intercom.updateUser(with: userAttributes)
//    }
//}

// swiftlint:enable orphaned_doc_comment
// swiftlint:enable comment_spacing
// swiftlint:enable mark

//}

// swiftlint:enable orphaned_doc_comment
// swiftlint:enable comment_spacing
