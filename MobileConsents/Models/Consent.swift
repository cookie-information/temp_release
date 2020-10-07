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
    public var processingPurposes: [Purpose]
    public let customData: [String: Any]
    
    init(consentSolutionId: String, consentSolutionVersionId: String, customData: [String: Any]) {
        self.consentSolutionId = consentSolutionId
        self.consentSolutionVersionId = consentSolutionVersionId
        self.timestamp = Date()
        self.processingPurposes = []
        self.customData = customData
    }
    
    mutating func addProcessingPurpose(_ purpose: Purpose) {
        processingPurposes.append(purpose)
    }
    
    public func JSONRepresentation() -> [String: Any] {
        var json: [String: Any] = [
            "universalConsentSolutionId": consentSolutionId,
            "universalConsentSolutionVersionId": consentSolutionVersionId,
            "customData": customData
        ]
        if let purposesData = try? JSONEncoder().encode(processingPurposes), let purposesJSON = try? JSONSerialization.jsonObject(with: purposesData) as? [[String: Any]] {
            json["processingPurposes"] = purposesJSON
        }
        json["timestamp"] = timestamp.iso8601withFractionalSeconds
        
        return json
    }
}
