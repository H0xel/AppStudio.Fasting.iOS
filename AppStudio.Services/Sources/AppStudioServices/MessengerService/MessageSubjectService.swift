//
//  MessageSubjectService.swift
//  AppStudio
//
//  Created by Konstantin Golenkov on 20.05.2023.
//

import Foundation
import RxSwift
import RxCocoa

public protocol MessageSubjectService {

    func eventObservable<E: AppStudioMessage>(id: String?) -> Observable<E>
    func eventObservable<E: AppStudioMessage>() -> Observable<E>
    func replayEventObservable<E: AppStudioMessage>(id: String?) -> Observable<E>
    func replayEventObservable<E: AppStudioMessage>() -> Observable<E>

    func subscribe<E>(id: String?,
                      onNext: ((E) -> Void)?,
                      onError: ((Swift.Error) -> Void)?,
                      onCompleted: (() -> Void)?,
                      onDisposed: (() -> Void)?) -> Disposable where E: AppStudioMessage
}

// MARK: overload subscribe functions for MessageSubjectService

public extension MessageSubjectService {

    func subscribe<E>(id: String? = nil, onNext: ((E) -> Void)?) -> Disposable where E: AppStudioMessage {
        return self.subscribe(id: id, onNext: onNext, onError: nil, onCompleted: nil, onDisposed: nil)
    }

    func subscribe<E>(
        id: String?,
        onNext: ((E) -> Void)?,
        onError: ((Swift.Error) -> Void)?) -> Disposable where E: AppStudioMessage {
        return self.subscribe(id: id, onNext: onNext, onError: onError, onCompleted: nil, onDisposed: nil)
    }

    func onMessageDriver<E: AppStudioMessage>(_ messageType: E.Type, id: String? = nil) -> Driver<E> {
        onMessage(messageType, id: id)
            .map { (event: E) -> E? in event }
            .asDriver(onErrorJustReturn: nil)
            .compactMap { $0 }
    }

    func onMessage<E: AppStudioMessage>(_ messageType: E.Type, id: String? = nil) -> Observable<E> {
        eventObservable(id: id)
    }

    func onReplayMessage<E: AppStudioMessage>(_ messageType: E.Type, id: String? = nil) -> Observable<E> {
        replayEventObservable(id: id)
    }
}
