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
    var consents: [String: Bool] { get }
    func removeUserId()
    func addConsent(consentItemId: String, consentGiven: Bool)
    func addConsentsArray(_ consentsArray: [[String: Bool]])
    func clearAll()
}

struct LocalStorageManager: LocalStorageManagerProtocol {
    private let userIdKey = "com.MobileConsents.userIdKey"
    private let consentsKey = "com.MobileConsents.consentsKey"
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }
    
    var userId: String {
        guard let userId = userDefaults.string(forKey: userIdKey) else {
            return generateAndStoreUserId()
        }
        return userId
    }

    private func generateAndStoreUserId() -> String {
        let userId = UUID().uuidString
        userDefaults.set(userId, forKey: userIdKey)
        return userId
    }
    
    func removeUserId() {
        userDefaults.removeObject(forKey: userId)
    }
    
    var consents: [String: Bool] {
        guard let consents = userDefaults.object(forKey: consentsKey) as? [String: Bool] else { return [:] }
        
        return consents
    }
    
    func addConsent(consentItemId: String, consentGiven: Bool) {
        var consents = self.consents
        consents[consentItemId] = consentGiven
        userDefaults.set(consents, forKey: consentsKey)
    }
    
    func addConsentsArray(_ consentsArray: [[String: Bool]]) {
        let localConsents = self.consents
        let tupleArray: [(String, Bool)] = consentsArray.flatMap { $0 }
        let newConsents = Dictionary(tupleArray, uniquingKeysWith: { _, last in last })
        let merged = newConsents.reduce(into: localConsents) { r, e in r[e.0] = e.1 }
        userDefaults.set(merged, forKey: consentsKey)
    }
    
    func clearAll() {
        userDefaults.removeObject(forKey: userIdKey)
        userDefaults.removeObject(forKey: consentsKey)
    }
}
