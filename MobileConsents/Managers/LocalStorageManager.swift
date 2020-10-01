//
//  LocalStorageManager.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 01/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

enum LocalStorageManager {
    private static let userIdKey = "com.droids.MobileConsents.userIdKey"
        
    static var userId: String {
        guard let userId = UserDefaults.standard.string(forKey: userIdKey) else {
            return generateAndStoreUserId()
        }
        return userId
    }

    static func generateAndStoreUserId() -> String {
        let userId = UUID().uuidString
        UserDefaults.standard.set(userId, forKey: userIdKey)
        return userId
    }
    
    static func removeUserId() {
        UserDefaults.standard.removeObject(forKey: userId)
    }
}
