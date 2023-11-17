//
//  ServicesDependencies.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 20.05.2023.
//

import RxSwift
import Dependencies
import AppStudioFoundation
import MunicornAPI
import UIKit

extension DependencyValues {
    var messengerService: MessengerService {
        self[MessengerServiceKey.self]
    }

    var firstLaunchService: FirstLaunchService {
        self[FirstLaunchServiceKey.self]
    }

    var serialQueue: ExecutionDispatchQueue {
        self[ExecutionDispatchQueueKey.self]
    }

    var concurrentQueue: ConcurrentDispatchQueue {
        self[ConcurrentDispatchQueueKey.self]
    }

    var concurrentScheduler: SchedulerType {
        self[ConcurrentSchedulerTypeKey.self]
    }

    var serialScheduler: SchedulerType {
        self[SerialSchedulerTypeKey.self]
    }

    var idfaRequestService: IDFARequestService {
        self[IdfaRequestServiceKey.self]
    }

    var migrations: [Migration] {
        []
    }
    var migrationLaunchService: MigrationLaunchService {
        self[MigrationLaunchServiceKey.self]
    }

    var appSettingsProvider: AppSettingsProvider {
        self[AppSettingsProviderKey.self]
    }

    var mailSenderService: MailSenderService {
        self[MailSenderServiceKey.self]
    }

    var backendEnvironmentService: BackendEnvironmentService {
        self[BackendEnvironmentServiceKey.self]
    }
}

private enum BackendEnvironmentServiceKey: DependencyKey {
	static var liveValue = BackendEnvironmentService()
}

private enum MailSenderServiceKey: DependencyKey {
    static var liveValue = MailSenderServiceImpl()
}

private enum AppSettingsProviderKey: DependencyKey {
    static var liveValue = AppSettingsProviderImpl()
}

private enum MessengerServiceKey: DependencyKey {
    static var liveValue: MessengerService = MessengerServiceImpl()
}

private enum FirstLaunchServiceKey: DependencyKey {
    static var liveValue: FirstLaunchService = FirstLaunchServiceImpl()
}

private enum ConcurrentSchedulerTypeKey: DependencyKey {
    static var liveValue: SchedulerType {
        ConcurrentDispatchQueueScheduler(queue: ConcurrentDispatchQueueKey.liveValue)
    }
}

private enum SerialSchedulerTypeKey: DependencyKey {
    static var liveValue: SchedulerType {
        SerialDispatchQueueScheduler(queue: ConcurrentDispatchQueueKey.liveValue,
                                     internalSerialQueueName: "RemoteConfigQueue")
    }
}


private enum ExecutionDispatchQueueKey: DependencyKey {
    static var liveValue: ExecutionDispatchQueue {
        ExecutionDispatchQueue(label: "AppStudioSerialQueue", qos: .userInitiated)
    }
    static var testValue: ExecutionDispatchQueue {
        ExecutionDispatchQueue(label: "AppStudioSerialQueue", qos: .userInitiated)
    }
}

private enum ConcurrentDispatchQueueKey: DependencyKey {
    static var liveValue: ConcurrentDispatchQueue {
        ConcurrentDispatchQueue(label: "AppStudioConcurrentQueue", qos: .userInitiated, attributes: .concurrent)
    }
    static var testValue: ConcurrentDispatchQueue {
        ConcurrentDispatchQueue(label: "AppStudioConcurrentQueue", qos: .userInitiated, attributes: .concurrent)
    }
}

private enum IdfaRequestServiceKey: DependencyKey {
    static var liveValue = IDFARequestServiceImpl()
}

private enum MigrationLaunchServiceKey: DependencyKey {
    static var liveValue: MigrationLaunchService = MigrationLaunchServiceImpl(
        migrationService: MigrationServiceKey.liveValue
    )
    static var testValue: MigrationLaunchService = MigrationLaunchServiceImpl(
        migrationService: MigrationServiceKey.testValue
    )
}

private enum MigrationServiceKey: DependencyKey {
    static var liveValue: MigrationService = MigrationServiceImpl(
        appMigrationsProvider: AppMigrationsProviderKey.liveValue
    )
    static var testValue: MigrationService = MigrationServiceImpl(
        appMigrationsProvider: AppMigrationsProviderKey.testValue
    )
}

private enum AppMigrationsProviderKey: DependencyKey {
    static var liveValue = AppMigrationsProvider(migrations: [])
    static var testValue = AppMigrationsProvider(migrations: [])
}
