//
//  MockedUserDefaults.swift
//  MobileConsentsSDKTests
//
//  Created by Jan Lipmann on 13/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation
@testable import MobileConsentsSDK

final class MockedUserDefaults: UserDefaultsProtocol {
    private var data: [String: Any] = [:]
    
    func set<T>(_ value: T?, forKey key: String) {
        data[key] = value
    }
    
    func get<T>(forKey key: String) -> T? {
        return data[key] as? T
    }
    
    func removeObject(forKey key: String) {
        data.removeValue(forKey: key)
    }
}
