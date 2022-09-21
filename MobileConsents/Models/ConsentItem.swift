public enum ConsentItemType: String, Codable {
    case setting
    case info
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
