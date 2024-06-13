//
//  AppInitializerServiceDependency.swift
//  AppStudio
//
//  Created by Amakhin Ivan on 08.02.2023.
//

import Dependencies

extension DependencyValues {
    var appInitializerService: AppInitializerService {
        self[AppInitializerServiceKey.self]
    }
}

extension DependencyValues {
    var earlyTimeInitializers: Initializers {
        self[EarlyTimeInitializersKey.self]
    }

    var lateTimeInitializers: Initializers {
        self[LateTimeInitializersKey.self]
    }
}

private enum EarlyTimeInitializersKey: DependencyKey {
    public static var liveValue: Initializers = EarlyTimeInitializers()
    public static let testValue: Initializers = EarlyTimeInitializers()
    public static let previewValue: Initializers = AppInitializerServicePreview()
}

private enum LateTimeInitializersKey: DependencyKey {
    public static var liveValue: Initializers = LateTimeInitializers()
    public static let testValue: Initializers = LateTimeInitializers()
    public static let previewValue: Initializers = AppInitializerServicePreview()
}

private enum AppInitializerServiceKey: DependencyKey {
    static let liveValue: AppInitializerService = AppInitializerServiceImpl()
    static let previewValue: AppInitializerService = AppInitializerPreview()
}
