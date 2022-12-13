import Foundation

/// UserConsent
public class UserConsent: NSObject, Codable {
    internal init(consentItem: ConsentItem, isSelected: Bool) {
        self.consentItem = consentItem
        self.isSelected = isSelected
    }
    
    public let consentItem: ConsentItem
    public var purpose: ConsentPurpose {
        .init(consentItem.translations.translation(with: "EN")?.shortText ?? "")
    }
    public let isSelected: Bool
}

public enum ConsentPurpose: Codable {
    case necessary
    case marketing
    case functional
    case statistical
    case custom(title: String)
    
    public init(_ rawValue: String) {
        switch rawValue.lowercased() {
        case "necessary": self = .necessary
        case "marketing": self = .marketing
        case "functional": self = .functional
        case "statistical": self = .statistical
        default: self = .custom(title: rawValue)
        }
    }
    
    public var description: String {
        String(describing: self)
    }
}
