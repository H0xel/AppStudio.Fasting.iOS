//
//  ServiceBaseImpl.swift
//  AppStudio
//
//  Created by Amakhin Ivan on 02.11.2022.
//

import RxSwift
import Dependencies
import AppStudioServices

public class ServiceBaseImpl {
    @Dependency(\.serialQueue) var serialQueue
    @Dependency(\.concurrentQueue) var concurrentQueue
    @Dependency(\.messengerService) var messenger
    var publisher: MessagePublisherService { messenger }

    func invokeInQueue(block: @escaping () -> Void) {
        serialQueue.async {
            block()
        }
    }

    func invokeBlock<T>(block: @escaping (_ observer: AnyObserver<T>) -> Void) -> Observable<T> {
        return Observable.create { observer in
            self.invokeInQueue {
                block(observer)
            }
            return Disposables.create()
        }
    }

    func invoke<T>(getter: @escaping () throws -> T) -> Observable<T> {
        invokeBlock { [unowned self] observer in
            do {
                let result = try getter()
                self.concurrentQueue.async {
                    observer.on(.next(result))
                    observer.on(.completed)
                }
            } catch let error {
                self.concurrentQueue.async {
                    observer.onError(error)
                    observer.on(.completed)
                }
            }
        }
    }
}
