//  
//  RootViewModel.swift
//  AppStudioTemplate
//
//  Created by Denis Khlopin on 19.10.2023.
//

import AppStudioNavigation
import AppStudioUI
import Dependencies

class RootViewModel: BaseViewModel<RootOutput> {

    @Dependency(\.appCustomization) private var appCustomization
    @Dependency(\.idfaRequestService) private var idfaRequestService

    var router: RootRouter!

    init(input: RootInput, output: @escaping RootOutputBlock) {
        super.init(output: output)
        initialize()
        // initialization code here
    }

    private func initialize() {
        Task { [weak self] in
            guard let self else { return }
            let shouldForceUpdate = try await self.appCustomization.shouldForceUpdate()
            if shouldForceUpdate {
                self.presentForceUpdateScreen()
            }
        }
    }
}

// MARK: Routing
extension RootViewModel {
    func showPaywall() {
        router.presentPaywall()
    }

    private func presentForceUpdateScreen() {
        let banner = ForceUpdateBanner { [weak self] in
            self?.router.presentAppStore()
        }
        router.present(banner: banner)
    }

    func requestIdfa() {
        idfaRequestService.requestIDFATracking()
    }
}
