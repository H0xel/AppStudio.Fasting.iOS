//
//  Synchronized.swift
//  AppStudio
//
//  Created by Amakhin Ivan on 01.11.2022.
//

import Foundation

public func synchronized(_ lock: NSObject, closure: () -> Void) {
    objc_sync_enter(lock)
    closure()
    objc_sync_exit(lock)
}
