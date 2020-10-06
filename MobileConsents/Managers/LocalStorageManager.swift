//
//  LocalStorageManager.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 01/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

protocol LocalStorageManagerProtocol {
    var userId: String { get }
    func removeUserId()
}

struct LocalStorageManager: LocalStorageManagerProtocol {
    private let userIdKey = "com.MobileConsents.userIdKey"
        
    var userId: String {
        guard let userId = UserDefaults.standard.string(forKey: userIdKey) else {
            return generateAndStoreUserId()
        }
        return userId
    }

    private func generateAndStoreUserId() -> String {
        let userId = UUID().uuidString
        UserDefaults.standard.set(userId, forKey: userIdKey)
        return userId
    }
    
    func removeUserId() {
        UserDefaults.standard.removeObject(forKey: userId)
    }
}
