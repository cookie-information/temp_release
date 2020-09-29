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

extension Consent: Codable {
    enum CodingKeys: String, CodingKey {
        case consentSolutionId = "universalConsentSolutionId"
        case consentSolutionVersionId = "universalConsentSolutionVersionId"
        case timestamp, userID, processingPurposes, customData
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        consentSolutionId = try container.decode(String.self, forKey: .consentSolutionId)
        consentSolutionVersionId = try container.decode(String.self, forKey: .consentSolutionVersionId)
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        userID = try container.decode(String.self, forKey: .userID)
        processingPurposes = try container.decode([Purpose].self, forKey: .processingPurposes)
        
        let rawCustomData = try container.decode(Data.self, forKey: .customData)
        customData = try JSONSerialization.jsonObject(with: rawCustomData, options: []) as? [String: Any] ?? [:]
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(consentSolutionId, forKey: .consentSolutionId)
        try container.encode(consentSolutionVersionId, forKey: .consentSolutionVersionId)
        try container.encode(timestamp, forKey: .timestamp)
        try container.encode(userID, forKey: .userID)
        try container.encode(processingPurposes, forKey: .processingPurposes)
        let rawCustomData = try JSONSerialization.data(withJSONObject: customData, options: [])
        try container.encode(rawCustomData, forKey: .customData)
    }
}
