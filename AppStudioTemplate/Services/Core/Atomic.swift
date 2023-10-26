//
//  Atomic.swift
//  AppStudio
//
//  Created by Amakhin Ivan on 02.11.2022.
//

import Foundation

@propertyWrapper
public struct Atomic<Value> {

    private var value: Value
    private let lock = NSLock()

    public init(wrappedValue value: Value) {
        self.value = value
    }

    public var wrappedValue: Value {
      get { return get() }
      set { set(newValue: newValue) }
    }

    func get() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return value
    }

    mutating func set(newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
    }
}
