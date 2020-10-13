//
//  UserDefaultsProtocol.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 13/10/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

protocol UserDefaultsProtocol {
    func set<T>(_ value: T?, forKey key: String)
    func get<T>(forKey key: String) -> T?
    func removeObject(forKey key: String)
}
