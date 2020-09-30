//
//  Purpose.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 25/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

public struct Purpose: Codable {
    public let consentItemId: String
    public let consentGiven: Bool
    public let language: String
}
