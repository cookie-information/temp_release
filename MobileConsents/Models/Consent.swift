//
//  Consent.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 25/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

import Foundation

public struct Consent {
    public let consentSolutionId: String
    public let consentSolutionVersionId: String
    public let timestamp: Date
    public let userID: String
    public let processingPurposes: [Purpose]
    public let customData: [String: Any]
}
