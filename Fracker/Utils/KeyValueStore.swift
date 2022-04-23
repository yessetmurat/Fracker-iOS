//
//  KeyValueStore.swift
//  Fracker
//
//  Created by Yesset Murat on 4/23/22.
//

import Foundation

class KeyValueStore {

    enum Key: String {

        case token
    }

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    func getValue<T>(for key: Key) -> T? { userDefaults.value(forKey: key.rawValue) as? T }

    func set<T>(value: T, for key: Key) {
        userDefaults.set(value, forKey: key.rawValue)
    }

    func removeValue(for key: Key) {
        userDefaults.removeObject(forKey: key.rawValue)
    }

    func sync() {
        userDefaults.synchronize()
    }
}
