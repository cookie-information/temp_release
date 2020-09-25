//
//  Consent.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 25/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

public struct Consent {
    var universalConsentSolutionId: String
    var universalConsentSolutionVersionId: String
    var timestamp: Date
    var userID: String
    var processingPurposes: [Purpose]
    var customData: [String: Any]
}

public struct Purpose {
    var universalConsentItemId: String
    var consentGiven: Bool
    var language: String
}
