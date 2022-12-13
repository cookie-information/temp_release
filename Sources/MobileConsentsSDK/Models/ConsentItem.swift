public enum ConsentItemType: String, Codable {
    case setting
    case info
    case functional = "Functional"
    case necessary = "Necessary"
    case statistical = "Statistical"
    case marketing = "Marketing"
    case privacyPolicy = "Privacy policy"
}

public struct ConsentItem: Codable, Equatable {
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
