//
//  WithDeepLinkModifier.swift
//  
//
//  Created by Amakhin Ivan on 25.04.2024.
//

import Dependencies
import SwiftUI

struct WithDeepLinkModifier: ViewModifier {

    @Dependency(\.deepLinkService) private var deepLinkService 
    var deepLink: (DeepLink?) -> Void

    func body(content: Content) -> some View {
        content
            .onReceive(
                deepLinkService
                    .deepLinkPublisher
                    .delay(for: 0.5, scheduler: RunLoop.main)
                    .removeDuplicates()) { link in
                deepLink(link)
                deepLinkService.reset()
            }
    }
}

public extension View {
    func withDeepLink(deepLink: @escaping (DeepLink?) -> Void ) -> some View {
        modifier(WithDeepLinkModifier(deepLink: deepLink))
    }
}
