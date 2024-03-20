//
//  MessengerServiceImpl.swift
//  AppStudio
//
//  Created by Amakhin Ivan on 01.11.2022.
//

import Foundation
import RxSwift
import Dependencies

class MessengerServiceImpl: MessengerService {

    private var replaySubscribersCount = 0
    private var subscribersCount = 0
    @Dependency(\.concurrentScheduler) private var scheduler
    @Atomic private var unpublishedMessages = Set<AppStudioMessage>()
    private var isInitialized = false
    private var disposeBag = DisposeBag()
    private let syncObject = NSObject()

    init() {
        [eventSubject, replayEventSubject].forEach {
            $0.filter { [unowned self] _ in !self.isInitialized }
              .subscribe(onNext: { [unowned self] message in
                  self.unpublishedMessages.insert(message)
              })
              .disposed(by: disposeBag)
        }
    }

    func acquireCounter() -> Int {
        subscribersCount += 1
        return subscribersCount
    }

    func acquireReplayCounter() -> Int {
        replaySubscribersCount += 1
        return replaySubscribersCount
    }

    let eventSubject = PublishSubject<AppStudioMessage>()
    let replayEventSubject = ReplaySubject<AppStudioMessage>.create(bufferSize: 5)

    func initialize() {
        guard !isInitialized else {
            assertionFailure("Should call initialize() only once!")
            return
        }
        isInitialized = true
        synchronized(syncObject) {
            for message in unpublishedMessages {
                replayEventSubject.onNext(message)
                eventSubject.onNext(message)
            }
            unpublishedMessages.removeAll()
        }
    }

    func subscribe<O: ObserverType>(observer: O) -> Disposable where O.Element == AppStudioMessage {
        return eventSubject.subscribe(observer)
    }

    func subscribe<E>(id: String?,
                      onNext: ((E) -> Void)?,
                      onError: ((Swift.Error) -> Void)?,
                      onCompleted: (() -> Void)?,
                      onDisposed: (() -> Void)?) -> Disposable where E: AppStudioMessage {

        return
            eventObservable(id: id)
                .subscribe(onNext: onNext, onError: onError, onCompleted: onCompleted, onDisposed: onDisposed)
    }

    func eventObservable<E: AppStudioMessage>() -> Observable<E> {
        return eventObservable(id: nil)
    }

    func replayEventObservable<E: AppStudioMessage>() -> Observable<E> {
        return replayEventObservable(id: nil)
    }

    func eventObservable<E: AppStudioMessage>(id: String?) -> Observable<E> {
        return configure(subject: eventSubject, forId: id, acquireCounter: acquireCounter)
    }

    func replayEventObservable<E: AppStudioMessage>(id: String?) -> Observable<E> {
        return configure(subject: replayEventSubject, forId: id, acquireCounter: acquireReplayCounter)
    }

    private func configure<E: AppStudioMessage>(subject: Observable<AppStudioMessage>,
                                                forId id: String?,
                                                acquireCounter: () -> (Int)) -> Observable<E> {
        return subject
            .observe(on: scheduler)
            .filter({ message in
                if type(of: message) == E.self {
                    return true
                }
                return false
            })
            .compactMap { $0 as? E }
    }
}
