//
//  CoreDependency.swift
//
//
//  Created by Amakhin Ivan on 13.03.2024.
//

import Dependencies
import RxSwift

public extension DependencyValues {
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
}

private enum ConcurrentDispatchQueueKey: DependencyKey {
    static var liveValue: ConcurrentDispatchQueue {
        ConcurrentDispatchQueue(label: "AppStudioConcurrentQueue", qos: .userInitiated, attributes: .concurrent)
    }
}
