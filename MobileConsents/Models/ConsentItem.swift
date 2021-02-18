//
//  ConsentItem.swift
//  MobileConsentsSDK
//
//  Created by Jan Lipmann on 24/09/2020.
//  Copyright © 2020 ClearCode. All rights reserved.
//

public enum ConsentItemType: String, Decodable {
    case setting
    case info
}

public struct ConsentItem: Decodable, Equatable {
    public let id: String
    public let required: Bool
    public let type: ConsentItemType
    public let translations: Translated<ConsentTranslation>
    
    enum CodingKeys: String, CodingKey {
        case id = "universalConsentItemId"
        case translations
        case required
        case type
    }
}
