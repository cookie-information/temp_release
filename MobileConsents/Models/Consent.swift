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
    public var processingPurposes: [ProcessingPurpose]
    public let customData: [String: String]?
    
    public init(consentSolutionId: String, consentSolutionVersionId: String, customData: [String: String]? = [:]) {
        self.consentSolutionId = consentSolutionId
        self.consentSolutionVersionId = consentSolutionVersionId
        self.timestamp = Date()
        self.processingPurposes = []
        self.customData = customData
    }
    
    public mutating func addProcessingPurpose(_ purpose: ProcessingPurpose) {
        processingPurposes.append(purpose)
    }
    
    public func JSONRepresentation() -> [String: Any] {
        var json: [String: Any] = [
            "universalConsentSolutionId": consentSolutionId,
            "universalConsentSolutionVersionId": consentSolutionVersionId,
            "customData": parsedCustomData()
        ]
        
        if let purposesData = try? JSONEncoder().encode(processingPurposes), let purposesJSON = try? JSONSerialization.jsonObject(with: purposesData) as? [[String: Any]] {
            json["processingPurposes"] = purposesJSON
        }
        json["timestamp"] = timestamp.iso8601withFractionalSeconds
        
        return json
    }
    
    func parsedCustomData() -> [[String: String]] {
        guard let customData = customData else { return [] }
        let parsed = customData.map { dictItem in
            return ["fieldName": dictItem.key, "fieldValue": dictItem.value]
        }
        return parsed
    }
}
