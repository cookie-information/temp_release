//
//  Purpose.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 25/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

public struct ProcessingPurpose: Codable {
    public let consentItemId: String
    public let consentGiven: Bool
    public let language: String
    
    enum CodingKeys: String, CodingKey {
        case consentItemId = "universalConsentItemId"
        case consentGiven
        case language
    }
    
    public init(consentItemId: String, consentGiven: Bool, language: String) {
        self.consentItemId = consentItemId
        self.consentGiven = consentGiven
        self.language = language
    }
}
