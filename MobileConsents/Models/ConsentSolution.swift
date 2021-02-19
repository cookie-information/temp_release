//
//  ConsentSolution.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 25/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

public struct ConsentSolution: Decodable, Equatable {
    public let id: String
    public let versionId: String
    public let title: Translated<TemplateTranslation>
    public let description: Translated<TemplateTranslation>
    public let templateTexts: TemplateTexts
    public let consentItems: [ConsentItem]
    
    enum CodingKeys: String, CodingKey {
        case id = "universalConsentSolutionId"
        case versionId = "universalConsentSolutionVersionId"
        case title
        case description
        case templateTexts
        case consentItems = "universalConsentItems"
    }
}
