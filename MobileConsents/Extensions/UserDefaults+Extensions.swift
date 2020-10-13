//
//  UserDefaults+Extensions.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 13/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

extension UserDefaults: UserDefaultsProtocol {
    func set<T>(_ value: T?, forKey key: String) {
        setValue(value, forKey: key)
    }
    
    func get<T>(forKey key: String) -> T? {
        return object(forKey: key) as? T
    }
}
